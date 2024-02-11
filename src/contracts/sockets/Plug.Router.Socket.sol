// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugTypes, PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { Initializable } from "solady/src/utils/Initializable.sol";
import { PlugSocketInterface } from "../interfaces/Plug.Socket.Interface.sol";

/**
 * @title Plug Router Socket
 * @notice This contract represents a general purpose relay socket that can be
 *         used to route transactions to other contracts.
 * @notice Do not approve assets to this contract as anyone can sign and/or
 *         execute transactions which means they can use your approvals.
 * @author @nftchance (chance@utc24.io)
 */
contract PlugRouterSocket is PlugTypes, Initializable {
    /**
     * @notice Automatically initialize the contract that is used for the
     *         the implementation to prevent nefarious interaction with
     *         this contract.
     */
    constructor() {
        initialize();
    }

    /**
     * @notice Initialize a new Plug Router.
     */
    function initialize() public payable virtual initializer {
        _initializeSocket("PlugRouter", "0.0.0");
    }

    function plug(PlugTypesLib.LivePlugs calldata $livePlugs)
        public
        payable
        virtual
        returns (bytes[] memory $results)
    {
        /// @dev Snapshot how much gas the transaction was provided with.
        uint256 gas = gasleft();

        /// @dev Determine the address that signed the Plug bundle.
        address signer = getLivePlugsSigner($livePlugs);

        address executor = $livePlugs.plugs.executor;

        /// @dev Make sure the bundle of Plugs is being executed by the declared
        ///      Executor or simply does not specify who can execute.
        require(
            msg.sender == executor
                || executor == address(0),
            "PlugRouterSocket: invalid-executor"
        );

        /// @dev Pass down the now-verified signature and execute the bundle.
        /// TODO: Need a way to associate the signer with the actual
        ///       caller or require a declaration of the caller.
        $results = PlugSocketInterface(signer).plug(
            $livePlugs.plugs, signer, executor, gas
        );
    }

    function plugBatch(PlugTypesLib.LivePlugs[] calldata $livePlugs)
        public
        payable
        virtual
        returns (bytes[][] memory $results)
    {
        /// @dev Load the stack.
        uint256 i;
        uint256 length = $livePlugs.length;
        $results = new bytes[][](length);

        /// @dev Iterate over the plugs and execute them.
        for (i; i < length; i++) {
            $results[i] = plug($livePlugs[i]);
        }
    }
}
