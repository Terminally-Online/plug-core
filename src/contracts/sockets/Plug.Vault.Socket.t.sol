// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Test } from "../utils/Test.sol";

import { PlugFactory } from "../base/Plug.Factory.sol";
import { Plug } from "../base/Plug.sol";
import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";
import { PlugVaultSocket } from "./Plug.Vault.Socket.sol";

import { Initializable } from "solady/src/utils/Initializable.sol";
import { Ownable } from "solady/src/auth/Ownable.sol";

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

    function test_name() public {
        assertEq(vault.name(), "PlugVaultSocket");
    }

    function test_symbol() public {
        assertEq(vault.symbol(), "PVS");
    }

    function test_owner_Implementation() public {
        assertEq(implementation.owner(), address(1));
    }

    function test_owner() public {
        assertEq(vault.owner(), address(this));
    }

    function test_owner_getAccess() public {
        (bool isRouter, bool isSigner) = vault.getAccess(address(this));
        assertTrue(isSigner);
        assertFalse(isRouter);
    }

    function test_setAccess_Both() public {
        bool isRouter = true;
        bool isSigner = true;
        address signer = _randomNonZeroAddress();
        uint8 access = vault.getAccess(isRouter, isSigner);
        vault.setAccess(signer, access);
        (isSigner, isRouter) = vault.getAccess(signer);
        assertTrue(isSigner);
        assertTrue(isRouter);
    }

    function test_setAccess_IsRouter() public {
        bool isRouter = true;
        bool isSigner = false;
        address signer = _randomNonZeroAddress();
        uint8 access = vault.getAccess(isRouter, isSigner);
        vault.setAccess(signer, access);
        (isRouter, isSigner) = vault.getAccess(signer);
        assertFalse(isSigner);
        assertTrue(isRouter);
    }

    function test_setAccess_IsSigner() public {
        bool isRouter = false;
        bool isSigner = true;
        address signer = _randomNonZeroAddress();
        uint8 access = vault.getAccess(isRouter, isSigner);
        vault.setAccess(signer, access);
        (isRouter, isSigner) = vault.getAccess(signer);
        assertFalse(isRouter);
        assertTrue(isSigner);
    }

    function testRevert_setAccess_Unauthorized() public {
        bool isRouter = false;
        bool isSigner = true;
        address signer = _randomNonZeroAddress();
        uint8 access = vault.getAccess(isRouter, isSigner);
        vm.prank(_randomNonZeroAddress());
        vm.expectRevert(Ownable.Unauthorized.selector);
        vault.setAccess(signer, access);
    }

    function test_transferOwnership() public {
        bool isRouter;
        bool isSigner;
        address newOwner = _randomNonZeroAddress();
        vault.transferOwnership(newOwner);
        (isRouter, isSigner) = vault.getAccess(address(this));
        assertFalse(isSigner);
        (isRouter, isSigner) = vault.getAccess(newOwner);
        assertTrue(isSigner);
    }

    function testRevert_testOwnership_Unauthorized() public {
        vm.prank(_randomNonZeroAddress());
        vm.expectRevert(Ownable.Unauthorized.selector);
        vault.transferOwnership(_randomNonZeroAddress());
    }
}
