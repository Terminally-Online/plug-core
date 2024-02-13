// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Test } from "../utils/Test.sol";

import { PlugFactory } from "../base/Plug.Factory.sol";
import { Plug } from "./Plug.sol";
import { Initializable } from "solady/src/utils/Initializable.sol";

contract PlugTest is Test {
    Plug internal implementation;
    Plug internal router;
    PlugFactory internal factory;

    function setUp() public virtual {
        implementation = new Plug();
        factory = new PlugFactory();

        // (, address routerAddress) =
        //     factory.deploy(address(implementation), address(this), bytes32(0));
        // router = Plug(routerAddress);
    }

    // function testRevert_RepeatedInitialization() public {
    //     vm.deal(address(router), 100 ether);
    //     vm.expectRevert(Initializable.InvalidInitialization.selector);
    //     router.initialize(address(this));
    // }
}
