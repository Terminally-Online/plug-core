// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {
    Test,
    PlugLib,
    PlugTypesLib,
    LibClone
} from "../abstracts/test/Plug.Test.sol";
import { PlugLimitedCallsFuse } from "./Plug.LimitedCalls.Fuse.sol";

contract PlugLimitedCallsFuseTest is Test {
    PlugLimitedCallsFuse internal fuse;

    bytes32 plugsHash = bytes32(0);

    function setUp() public virtual {
        fuse = new PlugLimitedCallsFuse();
    }

    function test_enforceFuse() public {
        uint256 calls = 1;
        bytes memory terms = fuse.encode(1);
        uint256 decodedCalls = fuse.decode(terms);
        assertEq(decodedCalls, calls);
        fuse.enforceFuse(terms, plugsHash);
    }

    function testRevert_enforceFuse_Exceeded() public {
        uint256 calls = 1;
        bytes memory terms = fuse.encode(calls);
        fuse.enforceFuse(terms, plugsHash);
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ThresholdExceeded.selector, calls, 2)
        );
        fuse.enforceFuse(terms, plugsHash);
    }

    function testRevert_enforceFuse_ZeroCalls() public {
        uint256 calls = 0;
        bytes memory terms = fuse.encode(calls);
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ThresholdExceeded.selector, calls, 1)
        );
        fuse.enforceFuse(terms, plugsHash);
    }
}
