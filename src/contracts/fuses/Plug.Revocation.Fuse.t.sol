// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Test, PlugTypesLib } from "../abstracts/test/Plug.Test.sol";
import { PlugRevocationFuse } from "./Plug.Revocation.Fuse.sol";

contract PlugRevocationFuseTest is Test {
    PlugRevocationFuse internal fuse;

    bytes32 plugsHash = bytes32("0");

    function setUp() public {
        fuse = new PlugRevocationFuse();
    }

    function test_enforceFuse_NotRevoked() public {
        bytes memory terms = fuse.encode(address(this));
        (address decodedSigner) = fuse.decode(terms);
        assertEq(decodedSigner, address(this));
        fuse.enforceFuse(terms, plugsHash);
    }

    function testRevert_enforceFuse_Revoked() public {
        fuse.revoke(plugsHash, true);
        bytes memory terms = fuse.encode(address(this));
        vm.expectRevert(bytes("PlugRevocationFuse:revoked"));
        fuse.enforceFuse(terms, plugsHash);
    }
}
