// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {
    Test,
    PlugLib,
    PlugEtcherLib,
    PlugTypesLib,
    Plug,
    PlugFactory,
    PlugVaultSocket,
    PlugMockEcho
} from "../abstracts/test/Plug.Test.sol";

contract PlugVaultSocketTest is Test {
    function setUp() public virtual {
        setUpPlug();
    }

    function deployVault() internal override returns (PlugVaultSocket $vault) {
        (, address vaultAddress) =
            factory.deploy(bytes32(abi.encodePacked(address(this), uint96(0))));
        $vault = PlugVaultSocket(payable(vaultAddress));
    }

    function test_name() public {
        assertEq(socket.name(), "Plug Vault Socket");
    }

    function test_symbol() public {
        assertEq(socket.symbol(), "PVS");
    }

    function testRevert_Initialize_Again() public {
        vm.deal(address(socket), 100 ether);
        socket.initialize(address(this));
    }

    function testRevert_ReinitializeImplementation() public {
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ImplementationAlreadyInitialized.selector, uint16(0))
        );
        vm.prank(factoryOwner);
        factory.setImplementation(0, address(vaultImplementation));
    }

    function testRevert_UninitializedImplementation() public {
        bytes32 salt = bytes32(abi.encodePacked(address(this), uint80(0), uint16(2)));
        vm.expectRevert(abi.encodeWithSelector(PlugLib.ImplementationInvalid.selector, uint16(2)));
        factory.deploy(salt);
    }

    function test_owner_Implementation() public {
        address owner = vaultImplementation.owner();
        assertEq(owner, address(1));
    }

    function test_owner() public {
        assertEq(socket.owner(), address(this));
    }

    function testRevert_transferOwnership() public {
        socket.transferOwnership(_randomNonZeroAddress());
    }
}
