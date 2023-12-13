// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { TestPlus } from "../tests/TestPlus.sol";

import { PlugFactorySocket } from "../sockets/Plug.Factory.Socket.sol";
import { PlugVaultRouter } from "./Plug.Vault.Router.sol";

import {LibClone} from "solady/src/utils/LibClone.sol";

contract PlugFactorySocketTest is PRBTest, StdCheats, TestPlus  {
	PlugVaultRouter internal implementation;
	PlugFactorySocket internal factory;

    PlugVaultRouter internal vault;

	function setUp() public virtual {
		implementation = new PlugVaultRouter();
		factory = new PlugFactorySocket();

        (, address vaultAddress) = factory.deploy(address(implementation), address(this), bytes32(0));
        vault = PlugVaultRouter(payable(vaultAddress));
	}

	function test_SingletonUse(uint256) public {
        vm.deal(address(vault), 100 ether);
        vm.expectRevert('PlugVaultRouter:already-initialized');
        vault.initialize(address(this));
    }

    function test_ToggleSigner(uint256) public {
        assertEq(vault.isSender(address(this)), true);
        address nonZeroAddress = _randomNonZeroAddress();
        assertEq(vault.isSender(nonZeroAddress), false);
        vault.toggleSender(nonZeroAddress);
        assertEq(vault.isSender(nonZeroAddress), true);
    }
}
