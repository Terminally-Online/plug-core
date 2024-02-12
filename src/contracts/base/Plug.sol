// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugInterface } from "../interfaces/Plug.Interface.sol";
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { PlugSocketInterface } from "../interfaces/Plug.Socket.Interface.sol";

/**
 * @title Plug
 * @notice This contract represents a general purpose relay socket that can be
 *         used to route transactions to other contracts. This mechanism
 *         enables the ability to route all execution through a single contract
 *         instead of needing to operate an Executor instance for each contract.
 * @dev There is no need to approve assets to this contract as all transactions
 *      are executed through the socket which will manage its own permissions
 *      can be safely approved to interact with the assets of another account.
 * @author @nftchance (chance@utc24.io)
 */
contract Plug is PlugInterface {
    /**
     * See {PlugInterface-plug}.
     */
    function plug(PlugTypesLib.LivePlugs calldata $livePlugs)
        public
        payable
        virtual
        returns (bytes[] memory $results)
    {
        /// @dev Snapshot how much gas the transaction has.
        uint256 gas = gasleft();

        /// @dev Load the Plug Socket.
        PlugSocketInterface socket =
            PlugSocketInterface($livePlugs.plugs.socket);

        /// @dev Recover the address that signed the bundle of Plugs.
        address signer = socket.signer($livePlugs);

        /// @dev Make sure the bundle of Plugs is being executed by the declared
        ///      Executor or simply does not specify who can execute.
        require(
            msg.sender == $livePlugs.plugs.executor
                || $livePlugs.plugs.executor == address(0),
            "PlugRouterSocket: invalid-executor"
        );

        /// @dev Pass down the now-verified signature components and execute
        ///      the bundle from within the Socket that was declared.
        $results = socket.plug($livePlugs.plugs, signer, gas);
    }

    /**
     * See {PlugInterface-plug}.
     */
    function plug(PlugTypesLib.LivePlugs[] calldata $livePlugs)
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
