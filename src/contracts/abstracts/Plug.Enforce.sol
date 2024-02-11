// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugTypes, PlugTypesLib } from "./Plug.Types.sol";
import { PlugFuseInterface } from "../interfaces/Plug.Fuse.Interface.sol";
import { PlugErrors } from "../libraries/Plug.Errors.sol";

/**
 * @title Plug Enforce
 * @notice The enforcement mechanisms of Plug to ensure that transactions
 *         are only executed as defined.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugEnforce is PlugTypes {
    using PlugErrors for bytes;

    function _enforceExecutor(
        address $signer,
        address $executor
    )
        internal
        view
        returns (address $signerOut, address $executorOut)
    { }

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
     * @return $success If the fuse was successful.
     * @return $through The return data of the fuse.
     */
    function _enforceFuse(
        PlugTypesLib.Fuse memory $fuse,
        PlugTypesLib.Current memory $current,
        bytes32 $pinHash
    )
        internal
        returns (bool $success, bytes memory $through)
    {
        /// @dev Call the Fuse to determine if it is valid.
        ($success, $through) = $fuse.target.call(
            abi.encodeWithSelector(
                PlugFuseInterface.enforceFuse.selector,
                $fuse.data,
                $current,
                $pinHash
            )
        );

        /// @dev If the Fuse failed and is not optional, bubble up the revert.
        if (!$success) $through.bubbleRevert();

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
}
