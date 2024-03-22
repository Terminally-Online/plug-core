// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Test } from "../utils/Test.sol";

import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";

import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { PlugFactory } from "../base/Plug.Factory.sol";
import { Plug } from "./Plug.sol";
import { PlugVaultSocket } from "../sockets/Plug.Vault.Socket.sol";
import { PlugMockEcho } from "../mocks/Plug.Mock.Echo.sol";

contract PlugTest is Test {
    event EchoInvoked(address $sender, string $message);

    PlugFactory internal factory;
    Plug internal plug;
    PlugVaultSocket internal vault;
    PlugMockEcho internal mock;

    address internal factoryOwner;
    string internal baseURI = "https://onplug.io/metadata/";

    address internal signer;
    uint256 internal signerPrivateKey = 0x12345;

    function setUp() public virtual {
        factoryOwner = _randomNonZeroAddress();
        signer = vm.addr(signerPrivateKey);

        plug = deployPlug();
        factory = deployFactory();
        vault = deployVault();

        mock = new PlugMockEcho();
    }

    function deployPlug() internal returns (Plug $plug) {
        vm.etch(PlugEtcherLib.PLUG_ADDRESS, address(new Plug()).code);
        $plug = Plug(payable(PlugEtcherLib.PLUG_ADDRESS));
    }

    function deployFactory() internal returns (PlugFactory $factory) {
        vm.etch(
            PlugEtcherLib.PLUG_FACTORY_ADDRESS, address(new PlugFactory()).code
        );
        $factory = PlugFactory(payable(PlugEtcherLib.PLUG_FACTORY_ADDRESS));
        $factory.initialize(
            factoryOwner, baseURI, address(new PlugVaultSocket())
        );
    }

    function deployVault() internal returns (PlugVaultSocket $vault) {
        (, address vaultAddress) =
            factory.deploy(bytes32(abi.encodePacked(signer, uint96(0))));
        $vault = PlugVaultSocket(payable(vaultAddress));
    }

    function test_name() public {
        assertEq(plug.name(), "Plug");
    }

    function test_symbol() public {
        assertEq(plug.symbol(), "PLUG");
    }

    function test_PlugEmptyEcho_SignerSolver() public {
        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector)
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 0,
            solver: bytes("")
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(
                    vault.getPlugsHash(plugs),
                    address(vault),
                    signerPrivateKey,
                    false
                ),
                1,
                1,
                1
                )
        });

        vm.expectEmit(address(mock));
        emit EchoInvoked(address(vault), "Hello World");
        plug.plug(livePlugs);
    }

    function testRevert_PlugEmptyEcho_SignerSolver_InvalidRouter() public {
        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector)
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 0,
            solver: bytes("")
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(
                    vault.getPlugsHash(plugs),
                    address(vault),
                    signerPrivateKey,
                    false
                ),
                1,
                1,
                1
                )
        });

        plug = new Plug();
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.RouterInvalid.selector, address(plug)
            )
        );
        plug.plug(livePlugs);
    }

    function testRevert_PlugEmptyEcho_SignerSolver_InvalidSignature() public {
        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector)
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 0,
            solver: bytes("")
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(vault.getPlugsHash(plugs), address(vault), 0xabc1234, false),
                1,
                1,
                1
                )
        });

        vm.expectRevert(PlugLib.SignatureInvalid.selector);
        plug.plug(livePlugs);
    }

    function test_PlugEmptyEcho_ExternalSolver_NotCompensated() public {
        address solver = _randomNonZeroAddress();
        vm.deal(solver, 100 ether);
        vm.deal(address(vault), 100 ether);
        uint256 preBalance = address(solver).balance;

        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector)
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 0,
            solver: abi.encode(uint96(0), uint96(0), solver)
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(
                    vault.getPlugsHash(plugs),
                    address(vault),
                    signerPrivateKey,
                    false
                ),
                1,
                1,
                1
                )
        });

        vm.expectEmit(address(mock));
        emit EchoInvoked(address(vault), "Hello World");
        vm.prank(solver);
        plug.plug(livePlugs);
        assertEq(preBalance, address(solver).balance);
    }

    function test_PlugEmptyEcho_ExternalSolver_Compensated() public {
        address solver = _randomNonZeroAddress();
        vm.deal(solver, 100 ether);
        vm.deal(address(vault), 100 ether);
        uint256 preBalance = address(vault).balance;

        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector)
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 1 ether,
            solver: abi.encode(uint96(0.2 ether), uint96(1), solver)
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(
                    vault.getPlugsHash(plugs),
                    address(vault),
                    signerPrivateKey,
                    false
                ),
                1,
                1,
                1
                )
        });

        vm.expectEmit(address(mock));
        emit EchoInvoked(address(vault), "Hello World");

        vm.prank(solver);
        plug.plug(livePlugs);
        assertTrue(preBalance - 1 ether > address(vault).balance);
    }

    function testRevert_PlugEmptyEcho_ExternalSolver_CompensationFailure()
        public
    {
        address solver = _randomNonZeroAddress();
        vm.deal(solver, 100 ether);
        vm.deal(address(vault), 0);

        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector)
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 1 ether,
            solver: abi.encode(uint96(0.2 ether), uint96(24), solver)
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(
                    vault.getPlugsHash(plugs),
                    address(vault),
                    signerPrivateKey,
                    false
                ),
                1,
                1,
                1
                )
        });

        vm.prank(solver);
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.CompensationFailed.selector,
                PlugLib.PLUG_TREASURY_ADDRESS,
                1 ether
            )
        );
        plug.plug(livePlugs);
    }

    function testRevert_PlugEmptyEcho_ExternalSolver_Invalid() public {
        address solver = _randomNonZeroAddress();
        vm.deal(solver, 100 ether);
        vm.deal(address(vault), 100 ether);

        bytes memory encodedTransaction =
            abi.encodeWithSelector(PlugMockEcho.emptyEcho.selector);
        PlugTypesLib.Current memory current = PlugTypesLib.Current({
            target: address(mock),
            value: 0,
            data: encodedTransaction
        });
        PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
        plugsArray[0] = PlugTypesLib.Plug({
            current: current,
            fuses: new PlugTypesLib.Fuse[](0)
        });
        PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
            socket: address(vault),
            plugs: plugsArray,
            salt: bytes32(0),
            fee: 1 ether,
            solver: abi.encode(uint96(0), uint96(0), address(solver))
        });
        PlugTypesLib.LivePlugs memory livePlugs = PlugTypesLib.LivePlugs({
            plugs: plugs,
            signature: pack(
                sign(
                    vault.getPlugsHash(plugs),
                    address(vault),
                    signerPrivateKey,
                    false
                ),
                1,
                1,
                1
                )
        });

        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.SolverInvalid.selector, address(solver), address(this)
            )
        );
        plug.plug(livePlugs);
    }
}
