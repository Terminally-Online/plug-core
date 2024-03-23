//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { PlugFuseInterface } from "../../interfaces/Plug.Fuse.Interface.sol";
import { PlugLib, PlugTypesLib } from "../../libraries/Plug.Lib.sol";

abstract contract ThresholdFuse is PlugFuseInterface {
    /**
     * See {FuseEnforcer-enforceFuse}.
     */
    function enforceFuse(
        bytes calldata $live,
        PlugTypesLib.Current calldata $current,
        bytes32
    )
        public
        view
        override
        returns (bytes memory $through)
    {
        /// @dev Decode the terms to get the logic operator and threshold.
        (uint8 $operator, uint256 $threshold) = decode($live);

        /// @dev Make sure the base denominator is below (or before) the threshold.
        if ($operator == 0) {
            if ($threshold < _threshold()) {
                revert PlugLib.ThresholdExceeded($threshold, _threshold());
            }
        }
        /// @dev Make sure the base denominator is above (or after) after the threshold.
        else if ($threshold > _threshold()) {
            revert PlugLib.ThresholdInsufficient($threshold, _threshold());
        }

        /// @dev Continue the pass through.
        $through = $current.data;
    }

    /**
     * @dev Decode the terms to get the logic operator and threshold.
     */
    function decode(bytes calldata $data)
        public
        pure
        returns (uint8 $operator, uint256 $threshold)
    {
        ($operator, $threshold) = abi.decode($data, (uint8, uint256));
    }

    /**
     * @dev Encode the logic operator and threshold.
     */
    function encode(
        uint8 $operator,
        uint256 $threshold
    )
        public
        pure
        returns (bytes memory $data)
    {
        /// @dev Encode the logic operator and threshold.
        $data = abi.encode($operator, $threshold);
    }

    /**
     * @dev Unit denomination of the threshold.
     */
    function _threshold() internal view virtual returns (uint256);
}
