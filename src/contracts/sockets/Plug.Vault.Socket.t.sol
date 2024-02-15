// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Test } from "../utils/Test.sol";

import { PlugFactory } from "../base/Plug.Factory.sol";
import { Plug } from "../base/Plug.sol";
import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";
import { PlugVaultSocket } from "./Plug.Vault.Socket.sol";

import { Initializable } from "solady/src/utils/Initializable.sol";

contract PlugVaultSocketTest is Test {
    PlugVaultSocket internal implementation;
    PlugVaultSocket internal vault;
    PlugFactory internal factory;

    function setUp() public virtual {
        implementation = new PlugVaultSocket();
        factory = new PlugFactory();

        (, address vaultAddress) =
            factory.deploy(address(implementation), address(this), bytes32(0));
        vault = PlugVaultSocket(payable(vaultAddress));
    }

    function etchRouterSocket() internal returns (Plug) {
        vm.etch(PlugEtcherLib.ROUTER_SOCKET_ADDRESS, address(new Plug()).code);
        return Plug(payable(PlugEtcherLib.ROUTER_SOCKET_ADDRESS));
    }

    function test_SingletonUse(uint256) public {
        vm.deal(address(vault), 100 ether);
        vm.expectRevert(bytes("PlugTypes:already-initialized"));
        vault.initialize(address(this));
    }

    // function test_ToggleSigner(uint256) public {
    //     assertEq(vault.isSigner(address(this)), true);
    //     address nonZeroAddress = _randomNonZeroAddress();
    //     assertEq(vault.isSigner(nonZeroAddress), false);
    //     vault.toggleSigner(nonZeroAddress);
    //     assertEq(vault.isSigner(nonZeroAddress), true);
    // }
}
