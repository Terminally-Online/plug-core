// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { TestPlus } from "../tests/TestPlus.sol";

import { PlugMockSocket } from "./Plug.Mock.Socket.sol";
import { PlugTypes, PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { PlugCore } from "../abstracts/Plug.Core.sol";

contract PlugMockSocketTest is PRBTest, StdCheats, TestPlus {
    PlugMockSocket internal mock;

    address internal signer;
    uint256 internal signerPrivateKey;

    function setUp() public {
	mock = new PlugMockSocket('PlugMockSocket', '0.0.0');

	signerPrivateKey = 0xabc123;
	signer = vm.addr(signerPrivateKey);
    }

    function test_Echo() public {
	string memory expected = 'Hello World';
	vm.expectEmit(address(mock));
	emit PlugMockSocket.EchoInvoked(address(this), address(this), expected);
	mock.echo(expected);
    }

    function test_EmptyEcho() public {
	vm.expectEmit(address(mock));
	emit PlugMockSocket.EchoInvoked(address(this), address(this), 'Hello World');
	mock.emptyEcho();
    }

    function testFail_MutedEcho() public { 
	vm.expectRevert('EchoMuted');
	mock.mutedEcho();
    }

    function test_GetLivePinSigner() public { 
	PlugTypesLib.Fuse[] memory fuses = new PlugTypesLib.Fuse[](0);
	PlugTypesLib.Pin memory pin = PlugTypesLib.Pin({
	    neutral: signer,
	    live: bytes32(0),
	    fuses: fuses,
	    salt: bytes32(0),
	    forced: true
	});
	bytes32 digest = mock.getPinDigest(pin);
	(uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, digest);
	bytes memory signature = abi.encodePacked(r, s, v);
	PlugTypesLib.LivePin memory livePin = PlugTypesLib.LivePin({
	    pin: pin,
	    signature: signature
	});
	address pinSigner = mock.getLivePinSigner(livePin);
	assertEq(pinSigner, signer);
    }
}
