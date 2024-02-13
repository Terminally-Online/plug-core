// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugEnforce } from "./Plug.Enforce.sol";
import { PlugTypes, PlugTypesLib } from "./Plug.Types.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";

abstract contract PlugExecute is PlugEnforce {
    using PlugLib for bytes;

    /**
     * @notice Execution a built transaction.
     * @param $current The current state of the transaction.
     * @return $success If the transaction was successful.
     * @return $result The return data of the transaction.
     */
    function _execute(
        PlugTypesLib.Current memory $current,
        address $sender
    )
        internal
        enforceCurrent($current)
        returns (bool $success, bytes memory $result)
    {
        /// @dev Build the final call data.
        bytes memory full = abi.encodePacked($current.data, $sender);

        /// @dev Make the external call with a standard call.
        ($success, $result) =
            address($current.target).call{ value: $current.value }(full);

        /// @dev If the call failed, bubble up the revert reason if possible.
        if (!$success) $result.bubbleRevert();

        /// @dev Decode the return data to remove the wrapped bytes in memory.
        $result = abi.decode($result, (bytes));
    }
}
