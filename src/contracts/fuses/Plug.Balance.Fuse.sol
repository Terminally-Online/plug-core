// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { PlugFuseInterface } from
    "../interfaces/Plug.Fuse.Interface.sol";
import { PlugThresholdFuseEnforce } from
    "../abstracts/fuses/Plug.Threshold.Fuse.Enforce.sol";
import { PlugLib, PlugTypesLib } from "../libraries/Plug.Lib.sol";
import { ERC20 } from "solady/src/tokens/ERC20.sol";
import { ERC721 } from "solady/src/tokens/ERC721.sol";

/**
 * @title Plug Balance Fuse
 * @dev A fuse that provides enforcement for thresholds for
 *      Native, ERC20, and ERC721, but not ERC1155 balances.
 * @author nftchance (chance@onplug.io)
 */
contract PlugBalanceFuse is
    PlugFuseInterface,
    PlugThresholdFuseEnforce
{
    /**
     * See {PlugFuseInterface-enforceFuse}.
     */
    function enforceFuse(
        bytes calldata $live,
        PlugTypesLib.Current calldata $current,
        bytes32
    )
        public
        view
        returns (bytes memory $through)
    {
        /// @dev Determine the balance lookup definition.
        (
            address $holder,
            address $asset,
            uint8 $type,
            uint8 $operator,
            uint256 $threshold
        ) = decode($live);

        /// @dev Memory reference for the balance of the holder.
        uint256 balance = 0;

        /// @dev If it is a native asset.
        if ($type == 0) {
            balance = $holder.balance;
        }
        /// @dev Otherwise, get the balance of the ERC20 asset.
        else if ($type == 1) {
            balance = ERC20($asset).balanceOf($holder);
        }
        /// @dev Otherwise, get the balance of the ERC721 asset.
        else if ($type == 2) {
            balance = ERC721($asset).balanceOf($holder);
        }

        _enforceFuse($operator, $threshold, balance);

        /// @dev Otherwise, return the current value.
        $through = $current.data;
    }

    /**
     * See { PlugFuseInterface-decode }.
     */
    function decode(bytes calldata $data)
        public
        pure
        returns (
            address $holder,
            address $asset,
            uint8 $type,
            uint8 $operator,
            uint256 $threshold
        )
    {
        ($holder, $asset, $type, $operator, $threshold) = abi.decode(
            $data, (address, address, uint8, uint8, uint256)
        );
    }

    /**
     * See { PlugFuseInterface-encode }.
     */
    function encode(
        address $holder,
        address $asset,
        uint8 $type,
        uint8 $operator,
        uint256 $threshold
    )
        public
        pure
        returns (bytes memory $data)
    {
        /// @dev Encode the holder, asset, operator, and threshold.
        $data =
            abi.encode($holder, $asset, $type, $operator, $threshold);
    }
}