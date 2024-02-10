// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugTypes, PlugTypesLib } from "./Plug.Types.sol";
import { PlugFuseInterface } from "../interfaces/Plug.Fuse.Interface.sol";
import { PlugErrors } from "../libraries/Plug.Errors.sol";

/**
 * @title Plug Core
 * @notice The core contract for the Plug framework that enables
 *         counterfactual intent execution with granular conditional
 *         verification and execution.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugCore is PlugTypes {
    using PlugErrors for bytes;

    // bytes32 internal constant OUT_OF_GAS = keccak256(

    /**
     * @notice Confirm that signer of the intent has permission to declare
     *         the execution of an intent.
     * @dev If you would like to limit the available signers override this
     *      function in your contract with the additional logic.
     */
    function _enforceSigner(address $signer) internal view virtual { }

    /**
     * @notice Enforce the fuse of the current plug to confirm
     *         the specified conditions have been met.
     * @param $fuse The fuse to enforce.
     * @param $current The state of the transaction to execute.
     * @param $pinHash The hash of the pin.
     * @return $through The return data of the fuse.
     */
    function _enforceFuse(
        PlugTypesLib.Fuse memory $fuse,
        PlugTypesLib.Current memory $current,
        bytes32 $pinHash
    )
        internal
        returns (bytes memory $through)
    {
        /// @dev Warm up the slot for the return data.
        bool success;

        /// @dev Call the Fuse to determine if it is valid.
        (success, $through) = $fuse.target.call(
            abi.encodeWithSelector(
                PlugFuseInterface.enforceFuse.selector,
                $fuse.data,
                $current,
                $pinHash
            )
        );

        /// @dev If the Fuse failed and is not optional, bubble up the revert.
        if (!success) $through.bubbleRevert();

        /// @dev Decode the return data to remove the wrapped bytes in memory.
        $through = abi.decode($through, (bytes));
    }

    /**
     * @notice Possibly restrict the capability of the defined
     *         execution path dependent on larger external factors
     *         such as only allowing a transaction to be executed
     *         on the socket itself.
     * @param $current The current state of the transaction.
     */
    function _enforceCurrent(PlugTypesLib.Current memory $current)
        internal
        view
        virtual
    { }

    /**
     * @notice Execution a built transaction.
     * @param $current The current state of the transaction.
     * @return $result The return data of the transaction.
     */
    function _execute(
        PlugTypesLib.Current memory $current,
        address $sender
    )
        internal
        returns (bytes memory $result)
    {
        /// @dev Build the final call data.
        bytes memory full = abi.encodePacked($current.data, $sender);

        /// @dev Warm up the slot for the return data.
        bool success;

        /// @dev Ensure the current gas is within the limit.
        require(gasleft() >= $current.gasLimit, "Plug:current-out-of-gas");

        /// @dev Make the external call with a standard call.
        (success, $result) = address($current.target).call{
            gas: $current.gasLimit,
            value: $current.value
        }(full);

        /// @dev If the call failed, bubble up the revert reason if possible.
        if (!success) $result.bubbleRevert();
    }

    /**
     * @notice Pay the Executor for the gas used + fee earned.
     * @param $to The address to compensate.
     * @param $amount The amount to compensate.
     */
    function _compensate(address $to, uint256 $amount) internal {
        (bool success,) = $to.call{ value: $amount }("");
        require(success, "Plug:compensation-failed");
    }

    function _enforceBalance(
        PlugTypesLib.Plug memory $plug,
        address $sender
    )
        internal
        view
        returns (uint256 $gas)
    {
        /// @dev Confirm the gas values will not overflow.
        /// TODO: Account for this -- All of these values should be declared on the Plug.
        uint256 preVerificationGas = 0;
        uint256 maxFeePerGas = 0;
        uint256 maxPriorityFeePerGas = 0;
        uint256 maxGas = preVerificationGas | $plug.gasLimit
            | $plug.current.gasLimit | maxFeePerGas | maxPriorityFeePerGas;

        /// @dev Ensure the gas values will not overflow.
        require(maxGas <= type(uint120).max, "Plug:gas-overflow");

        /// @dev Account for the increased cost when using a different sender.
        $gas = msg.sender == $sender ? 1 : 3;
        /// @dev Calculate the required base gas.
        $gas =
            preVerificationGas + $plug.gasLimit * $gas + $plug.current.gasLimit;
        /// @dev Calculate the incentivized gas limit to ensure the transaction is prioritized.
        $gas *= maxFeePerGas;

        /// @dev Ensure the contract has sufficient value to operate.
        require(
            $plug.current.value + $gas < address(this).balance,
            "Plug:insufficient-balance"
        );
    }

    /**
     * @notice Execute an array of plugs
     * @param $plugs The plugs to execute.
     * @param $sender The address of the sender.
     * @return $results The return data of the plugs.
     */
    function _plug(
        PlugTypesLib.Plugs calldata $plugs,
        address $sender
    )
        internal
        returns (bytes[] memory $results, uint256 $gasUsed)
    {
        /// @dev Load the plugs from the live plugs.
        PlugTypesLib.Plug[] memory plugs = $plugs.plugs;

        /// @dev Load the stack.
        PlugTypesLib.Plug memory plug;
        uint256 gas;

        uint256 allowedGas;
        uint256 enforcementGas;
        uint256 currentGas;

        uint256 i;
        uint256 ii;
        uint256 length = plugs.length;
        $results = new bytes[](length);

        /// @dev Prevent random people from plugging.
        _enforceSigner($sender);

        /// @dev Unique hash of the Plug bundle being executed.
        bytes32 plugsHash = getPlugsHash($plugs);

        /// @dev Iterate over the plugs.
        for (i; i < length; i++) {
            /// @dev Snapshot how much gas is left.
            gas = gasleft();

            /// @dev Load the plug from the plugs.
            plug = plugs[i];

            /// @dev Ensure the balance is sufficient to cover the cost of gas + the
            ///      the value needed for the current.
            allowedGas = _enforceBalance(plug, $sender);

            /// @dev Iterate through all the execution fuses declared in the pin
            ///      and ensure they are in a state of acceptable execution
            ///      while building the pass through data based on the nodes.
            for (ii = 0; ii < plug.fuses.length; ii++) {
                plug.current.data =
                    _enforceFuse(plug.fuses[ii], plug.current, plugsHash);
            }

            /// @dev Confirm the current is within specification.
            _enforceCurrent(plug.current);

            /// @dev Account for all the gas that was used in enforcement.
            enforcementGas = gas - gasleft();

            /// @dev Ensure the gas limit declared was not exceeded.
            require(
                enforcementGas < plug.gasLimit, "Plug:enforcement-exceeds-gas"
            );

            /// @dev Update the snapshot of how much gas is left.
            gas = gasleft();

            /// @dev Execute the transaction.
            $results[i] = _execute(plug.current, $sender);

            /// @dev Account for the gas used in the execution.
            currentGas = gas - gasleft();

            /// @dev Ensure the gas limit declared was not exceeded.
            require(
                currentGas < plug.current.gasLimit, "Plug:current-exceeds-gas"
            );

            /// @dev Add the gas used to the total gas used.
            $gasUsed += enforcementGas + currentGas;
        }

        /// @dev Calculate the gas price based on the current block.
        uint256 gasPrice = $plugs.maxPriorityFeePerGas + block.basefee;
        /// @dev Determine which gas price to use based on if it is a legacy
        ///      transaction (on a chain that does not support it) or if the
        ///      the transaction is submit post EIP-1559.
        gasPrice = $plugs.maxFeePerGas == $plugs.maxPriorityFeePerGas
            ? $plugs.maxFeePerGas
            : $plugs.maxFeePerGas < gasPrice ? $plugs.maxFeePerGas : gasPrice;

        /// @dev Reimburse the Executor for the gas used.
        _compensate(msg.sender, $plugs.fee + $gasUsed * gasPrice);
    }
}
