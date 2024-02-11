// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import { PlugSocketInterface } from "../interfaces/Plug.Socket.Interface.sol";
import { PlugCore } from "./Plug.Core.sol";
import { PlugTypesLib } from "./Plug.Types.sol";

/**
 * @title Plug
 * @notice The core contract for the Plug framework that enables
 *         counterfactual revokable pin of extremely
 *         granular pin and execution paths.
 * @author @nftchance (chance@utc24.io)
 */
contract PlugSocket is PlugSocketInterface, PlugCore {
    address internal constant ROUTER_ADDRESS = address(0);

    /**
     * See {PlugSocketInterface-plug}.
     */
    /// TODO: Add a modifier to ensure that only the Router or Socket
    ///       owner/signer can execute the plugs.
    /// TODO: Add non-reentrant modifier.
    function plug(
        PlugTypesLib.Plugs calldata $plugs,
        address $signer,
        address $executor,
        uint256 $gas
    )
        external
        payable
        returns (bytes[] memory $results)
    {
        /// @dev If the call came from the router use the gas snapshot taken
        ///      otherwise update it to prevent undersetting.
        $gas = msg.sender == ROUTER_ADDRESS
            ? $gas
            : gasleft();

        /// @dev If the call came from the router use the signer that was
        ///      solved for in the router, otherwise use the msg.sender
        ///      as we are assuming a direct Socket interaction.
        $signer = msg.sender == ROUTER_ADDRESS
            ? $signer
            : msg.sender;

        /// @dev If the call came from the router use the executor that was
        ///      solved for in the router, otherwise check if the sender
        ///      is the same as signer. If not, compensation will be needed
        ///      otherwise set it to the zero address as no compensation will
        ///      be needed.
        $executor = msg.sender == ROUTER_ADDRESS
            ? $executor
            : msg.sender == $signer ? $signer : address(0);

        /// @dev Process the Plug bundle.
        /// TODO: We can probably move this logic into this function itself, but
        ///       we will want to confirm that we have contract calling handled first.
        $results = _plug($plugs, $signer, $executor, $gas);
    }
}
