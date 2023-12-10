// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { PlugMockSocket } from "./Plug.Mock.Socket.sol";

contract FooTest is PRBTest, StdCheats {
    PlugMockSocket internal mock;

    function setUp() public virtual {
		mock = new PlugMockSocket('PlugMockSocket', '0.0.0');
    }

    function test_Echo() external {
		string memory expected = 'Hello World';
		vm.expectEmit(address(mock));
		emit PlugMockSocket.EchoInvoked(address(this), address(this), expected);
		mock.echo(expected);
    }

	function test_EmptyEcho() external {
		vm.expectEmit(address(mock));
		emit PlugMockSocket.EchoInvoked(address(this), address(this), 'Hello World');
		mock.emptyEcho();
	}

	function testFail_MutedEcho() external { 
		vm.expectRevert('EchoMuted');
		mock.mutedEcho();
	}
}
