// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {
    Test,
    PlugLib,
    PlugTypesLib,
    PlugMockERC20,
    PlugMockERC721
} from "../abstracts/test/Plug.Test.sol";
import { PlugBalanceFuse } from "./Plug.Balance.Fuse.sol";

contract PlugBalanceFuseTest is Test {
    PlugBalanceFuse internal fuse;

    PlugTypesLib.Current current = PlugTypesLib.Current({
        target: address(fuse),
        value: 0,
        data: "0x"
    });
    bytes32 plugsHash = bytes32(0);

    uint8 belowOperator;
    uint8 aboveOperator = 1;

    uint256 belowBalance = 100 + 1;
    uint256 aboveBalance = 100 - 1;

    uint8 nativeType;
    uint8 erc20Type = 1;
    uint8 erc721Type = 2;

    uint256 balance = 100;

    function setUp() public virtual {
        setUpPlug();

        fuse = new PlugBalanceFuse();

        vm.deal(address(this), balance);
        mockERC20.mint(address(this), balance);
        mockERC721.mint(address(this), balance);
    }

    function test_enforceFuse_BelowNativeBalance() public {
        bytes memory terms = fuse.encode(
            address(this),
            address(0),
            nativeType,
            belowOperator,
            belowBalance
        );
        (
            address decodedHolder,
            address decodedAsset,
            uint8 decodedType,
            uint8 decodedOperator,
            uint256 decodedBalance
        ) = fuse.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(0));
        assertEq(decodedType, nativeType);
        assertEq(decodedOperator, belowOperator);
        assertEq(decodedBalance, belowBalance);

        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_BelowNativeBalance_Exceeded() public {
        uint256 expected = balance - 1;
        bytes memory terms = fuse.encode(
            address(this),
            address(0),
            nativeType,
            belowOperator,
            expected
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ThresholdExceeded.selector, expected, balance
            )
        );
        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_AboveNativeBalance() public {
        bytes memory terms = fuse.encode(
            address(this),
            address(0),
            nativeType,
            aboveOperator,
            aboveBalance
        );
        (
            address decodedHolder,
            address decodedAsset,
            uint8 decodedType,
            uint8 decodedOperator,
            uint256 decodedBalance
        ) = fuse.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(0));
        assertEq(decodedType, nativeType);
        assertEq(decodedOperator, aboveOperator);
        assertEq(decodedBalance, aboveBalance);

        fuse.enforceFuse(terms, current, plugsHash);
    }

    function testRevert_enforceFuse_AboveNativeBalance_Insufficient()
        public
    {
        uint256 expected = balance + 1;
        bytes memory terms = fuse.encode(
            address(this),
            address(0),
            nativeType,
            aboveOperator,
            expected
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ThresholdInsufficient.selector,
                expected,
                balance
            )
        );
        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_BelowERC20Balance() public {
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC20),
            erc20Type,
            belowOperator,
            belowBalance
        );
        (
            address decodedHolder,
            address decodedAsset,
            uint8 decodedType,
            uint8 decodedOperator,
            uint256 decodedBalance
        ) = fuse.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(mockERC20));
        assertEq(decodedType, erc20Type);
        assertEq(decodedOperator, belowOperator);
        assertEq(decodedBalance, belowBalance);

        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_BelowERC20Balance_Exceeded() public {
        uint256 expected = balance - 1;
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC20),
            erc20Type,
            belowOperator,
            expected
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ThresholdExceeded.selector, expected, balance
            )
        );
        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_AboveERC20Balance() public {
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC20),
            erc20Type,
            aboveOperator,
            aboveBalance
        );
        (
            address decodedHolder,
            address decodedAsset,
            uint8 decodedType,
            uint8 decodedOperator,
            uint256 decodedBalance
        ) = fuse.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(mockERC20));
        assertEq(decodedType, erc20Type);
        assertEq(decodedOperator, aboveOperator);
        assertEq(decodedBalance, aboveBalance);

        fuse.enforceFuse(terms, current, plugsHash);
    }

    function testRevert_enforceFuse_AboveERC20Balance_Insufficient()
        public
    {
        uint256 expected = balance + 1;
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC20),
            erc20Type,
            aboveOperator,
            expected
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ThresholdInsufficient.selector,
                expected,
                balance
            )
        );
        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_BelowERC721Balance() public {
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC721),
            erc721Type,
            belowOperator,
            2
        );
        (
            address decodedHolder,
            address decodedAsset,
            uint8 decodedType,
            uint8 decodedOperator,
            uint256 decodedBalance
        ) = fuse.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(mockERC721));
        assertEq(decodedType, erc721Type);
        assertEq(decodedOperator, belowOperator);
        assertEq(decodedBalance, 2);

        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_BelowERC721Balance_Exceeded() public {
        uint256 expected = 0;
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC721),
            erc721Type,
            belowOperator,
            expected
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ThresholdExceeded.selector, expected, 1
            )
        );
        fuse.enforceFuse(terms, current, plugsHash);
    }

    function test_enforceFuse_AboveERC721Balance() public {
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC721),
            erc721Type,
            aboveOperator,
            0
        );
        (
            address decodedHolder,
            address decodedAsset,
            uint8 decodedType,
            uint8 decodedOperator,
            uint256 decodedBalance
        ) = fuse.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(mockERC721));
        assertEq(decodedType, erc721Type);
        assertEq(decodedOperator, aboveOperator);
        assertEq(decodedBalance, 0);

        fuse.enforceFuse(terms, current, plugsHash);
    }

    function testRevert_enforceFuse_AboveERC721Balance_Insufficient()
        public
    {
        uint256 expected = 1 + 1;
        bytes memory terms = fuse.encode(
            address(this),
            address(mockERC721),
            erc721Type,
            aboveOperator,
            expected
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                PlugLib.ThresholdInsufficient.selector, expected, 1
            )
        );
        fuse.enforceFuse(terms, current, plugsHash);
    }
}
