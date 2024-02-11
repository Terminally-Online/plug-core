// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugTypes, PlugTypesLib } from "./Plug.Types.sol";
import { PlugFuseInterface } from "../interfaces/Plug.Fuse.Interface.sol";
import { PlugErrors } from "../libraries/Plug.Errors.sol";
import { PlugExecute } from "./Plug.Execute.sol";

/**
 * @title Plug Core
 * @notice The core contract for the Plug framework that enables
 *         counterfactual intent execution with granular conditional
 *         verification and execution.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugCore is PlugExecute {
    using PlugErrors for bytes;

    /**
     * @notice Execute an array of plugs
     * @param $plugs The plugs to execute.
     * @param $signer The address of the bundle signer.
     * @param $executor The address of the executor.
     * @param $gas Snapshot of gas at the start of interaction.
     * @return $results The return data of the plugs.
     */
    function _plug(
        PlugTypesLib.Plugs calldata $plugs,
        address $signer,
        address $executor,
        uint256 $gas
    )
        internal
        returns (bytes[] memory $results)
    {
        /// @dev Prevent random people from plugging.
        _enforceSigner($signer);

        /// @dev Load the Plug stack.
        PlugTypesLib.Plug[] calldata plugs = $plugs.plugs;
        PlugTypesLib.Current memory current;
        bytes32 plugsHash = getPlugsHash($plugs);

        /// @dev Load the loop stack.
        uint256 i;
        uint256 ii;
        uint256 length = plugs.length;
        $results = new bytes[](length);

        /// @dev Iterate over the plugs.
        for (i; i < length; i++) {
            /// @dev Load the plug from the plugs.
            current = plugs[i].current;

            /// @dev Iterate through all the execution fuses declared in the pin
            ///      and ensure they are in a state of acceptable execution
            ///      while building the pass through data based on the nodes.
            for (ii = 0; ii < plugs[i].fuses.length; ii++) {
                (, current.data) =
                    _enforceFuse(plugs[i].fuses[ii], current, plugsHash);
            }

            /// @dev Confirm the current is within specification.
            _enforceCurrent(current);

            /// @dev Execute the transaction.
            (, $results[i]) = _execute(current, $signer);
        }

        /// @dev Pay the Executor for the gas used and the fee earned if
        ///      it was not the original signer of the Plug bundle.
        if ($executor != address(0)) {
            /// @dev Calculate the gas price based on the current block.
            uint256 value = $plugs.maxPriorityFeePerGas + block.basefee;
            /// @dev Determine which gas price to use based on if it is a legacy
            ///      transaction (on a chain that does not support it) or if the
            ///      the transaction is submit post EIP-1559.
            value = $plugs.maxFeePerGas == $plugs.maxPriorityFeePerGas
                ? $plugs.maxFeePerGas
                : $plugs.maxFeePerGas < value ? $plugs.maxFeePerGas : value;

            /// @dev Augment the native gas price with the Executor "gas" fee.
            value = $plugs.fee + ($gas - gasleft()) * value;

            /// @dev Transfer the money the Executor is owed and confirm it
            ///      the transfer is successful.
            (bool success,) = $executor.call{ value: value }("");
            require(success, "Plug:compensation-failed");
        }
    }
}
