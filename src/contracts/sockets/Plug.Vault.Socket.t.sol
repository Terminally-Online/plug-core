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
        (, address socketAddress) =
            factory.deploy(abi.encodePacked(address(this), address(socketImplementation)));
        $vault = PlugVaultSocket(payable(socketAddress));
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

    function test_owner_Implementation() public {
        assertEq(socketImplementation.owner(), address(1));
    }

    function test_owner() public {
        assertEq(socket.owner(), address(this));
    }

    function testRevert_transferOwnership() public {
        socket.transferOwnership(_randomNonZeroAddress());
    }
}
