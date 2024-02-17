// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Test } from "../utils/Test.sol";

import { PlugTypes, PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { PlugFactory } from "../base/Plug.Factory.sol";
import { PlugMockEcho } from "./Plug.Mock.Echo.sol";

import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";

import "forge-std/console.sol";

contract PlugMockSocketTest is Test {
    PlugMockEcho internal mock;

    // address internal signer;
    // uint256 internal signerPrivateKey;

    // uint8 internal v;
    // bytes32 internal r;
    // bytes32 internal s;
    // bytes32 internal digest;

    function setUp() public virtual {
        // signerPrivateKey = 0xabc123;
        // signer = vm.addr(signerPrivateKey);

        // router = PlugEtcher.routerSocket();
        // router = etchRouterSocket();
        mock = new PlugMockEcho();
    }

    function test_Echo() public {
        string memory expected = "Hello World";
        vm.expectEmit(address(mock));
        emit PlugMockEcho.EchoInvoked(address(this), expected);
        mock.echo(expected);
    }

    function test_EmptyEcho() public {
        vm.expectEmit(address(mock));
        emit PlugMockEcho.EchoInvoked(address(this), "Hello World");
        mock.emptyEcho();
    }

    function test_MutedEcho(uint256 $echo) public view {
        mock.mutedEcho($echo);
    }
}
