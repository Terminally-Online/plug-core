// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Test } from "../utils/Test.sol";
import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";

import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { Plug } from "../base/Plug.sol";
import { PlugFactory } from "../base/Plug.Factory.sol";

import { PlugVaultSocket } from "./Plug.Vault.Socket.sol";
import { PlugMockEcho } from "../mocks/Plug.Mock.Echo.sol";
import { ERC721 } from "solady/src/tokens/ERC721.sol";

contract PlugVaultSocketTest is Test {
    PlugFactory internal factory;

    PlugVaultSocket internal implementation;
    PlugVaultSocket internal vault;

    PlugMockEcho internal mock;

    address internal factoryOwner;
    address internal signer;
    uint256 internal signerPrivateKey = 0x12345;

    string internal baseURI = "https://onplug.io/metadata/";

    function setUp() public virtual {
        factoryOwner = _randomNonZeroAddress();
        signer = vm.addr(signerPrivateKey);

        factory = deployFactory();
        vault = deployVault();
    }

    function deployFactory() internal returns (PlugFactory $factory) {
        vm.etch(
            PlugEtcherLib.PLUG_FACTORY_ADDRESS, address(new PlugFactory()).code
        );
        implementation = new PlugVaultSocket();
        $factory = PlugFactory(payable(PlugEtcherLib.PLUG_FACTORY_ADDRESS));
        $factory.initialize(factoryOwner, baseURI, address(implementation));
    }

    function deployVault() internal returns (PlugVaultSocket $vault) {
        (, address vaultAddress) =
            factory.deploy(bytes32(abi.encodePacked(address(this), uint96(0))));
        $vault = PlugVaultSocket(payable(vaultAddress));
    }

    function test_name() public {
        assertEq(vault.name(), "PlugVaultSocket");
    }

    function test_symbol() public {
        assertEq(vault.symbol(), "PVS");
    }

    function testRevert_Initialize_Again() public {
        vm.deal(address(vault), 100 ether);
        vm.expectRevert(PlugLib.TradingAlreadyInitialized.selector);
        vault.initialize(address(this));
    }

    function testRevert_ReinitializeImplementation() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ImplementationAlreadyInitialized.selector, uint16(0)
            )
        );
        vm.prank(factoryOwner);
        factory.setImplementation(0, address(implementation));
    }

    function testRevert_UninitializedImplementation() public {
        bytes32 salt =
            bytes32(abi.encodePacked(address(this), uint80(0), uint16(2)));
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ImplementationInvalid.selector, uint16(2)
            )
        );
        factory.deploy(salt);
    }

    function test_ownership_Implementation() public {
        assertEq(implementation.ownership(), address(1));
    }

    function testRevert_owner_Implementation() public {
        vm.expectRevert();
        implementation.owner();
    }

    function test_owner() public {
        assertEq(vault.owner(), address(this));
    }

    function test_transferOwnership_Token() public {
        address newOwner = _randomNonZeroAddress();
        ERC721(vault.ownership()).transferFrom(
            address(this), newOwner, uint256(uint160(address(vault)))
        );
    }

    function testRevert_transferOwnership() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.CallerInvalid.selector, address(factory), address(this)
            )
        );
        vault.transferOwnership(_randomNonZeroAddress());
    }
}
