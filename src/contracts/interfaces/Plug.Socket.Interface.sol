//SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

/// @dev Shape declarations in the Plug framework.
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";

interface PlugSocketInterface {
    /**
     * @notice Allows anyone to submit a plugs of signed plugs for processing.
     * @param $plugs The Plug bundle to execute.
     * @param $signer The address of the bundle signer.
     * @param $executor The address of the executor.
     * @param $gas The gas to execute the plugs.
     * @return $results The return data of each plug executed.
     */
    function plug(
        PlugTypesLib.Plugs calldata $plugs,
        address $signer,
        address $executor,
        uint256 $gas
    )
        external
        payable
        returns (bytes[] memory $results);

    /**
     * @notice Allows a smart contract to submit a plugs of plugs for processing,
     *         allowing itself to be the delegate.
     * @param $plugs The plugs of plugs to execute.
     * @return $results The return data of each plug executed.
     */
    // function plugContract(PlugTypesLib.Plug[] calldata $plugs)
    //     external
    //     payable
    //     returns (bytes[] memory $results);
}
