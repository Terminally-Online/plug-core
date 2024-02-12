// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugTypes, PlugTypesLib } from "./Plug.Types.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";
import { PlugFuseInterface } from "../interfaces/Plug.Fuse.Interface.sol";

/**
 * @title Plug Enforce
 * @notice The enforcement mechanisms of Plug to ensure that transactions
 *         are only executed as defined.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugEnforce is PlugTypes {
    using PlugLib for bytes;

    /**
     * @notice Modifier to enforce the router of the transaction.
     * @dev Implicitly the address is assumed to be the current sender.
     */
    modifier enforceRouter() {
        require(_enforceRouter(msg.sender), "Plug:invalid-router");
        _;
    }

    /**
     * @notice Modifier to enforce the signer of the transaction.
     * @param $signer The signer of the transaction.
     */
    modifier enforceSigner(address $signer) {
        require(_enforceSigner($signer), "Plug:invalid-signer");
        _;
    }

    /**
     * @notice Confirm that the only specified routers can execute the transaction.
     * @dev If you would like to limit the available routers override this
     *      function in your contract with the additional logic.
     * @param $router The router of the transaction.
     */
    function _enforceRouter(address $router)
        internal
        pure
        returns (bool $allowed)
    {
        $allowed = $router == PlugLib.ROUTER_ADDRESS;
    }

    /**
     * @notice Confirm that signer has permission to declare execution of a
     *         Plug bundle on the parent-socket that inherits this contract.
     * @dev If you would like to limit the available signers override this
     *      function in your contract with the additional logic.
     * @param $signer The signer of the bundle.
     */
    function _enforceSigner(address $signer)
        internal
        view
        virtual
        returns (bool $allowed)
    { }

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
