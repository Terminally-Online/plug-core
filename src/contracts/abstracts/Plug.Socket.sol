// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import { PlugSocketInterface } from "../interfaces/Plug.Socket.Interface.sol";
import { PlugInitializable } from "./Plug.Initializable.sol";
import { ReentrancyGuard } from "solady/src/utils/ReentrancyGuard.sol";
import { PlugTypesLib } from "./Plug.Types.sol";

/**
 * @title Plug
 * @notice The core contract for the Plug framework that enables
 *         counterfactual revokable pin of extremely
 *         granular pin and execution paths.
 * @author @nftchance (chance@utc24.io)
 */
contract PlugSocket is PlugSocketInterface, PlugInitializable, ReentrancyGuard {
    /**
     * @notice Initialize a new Plug Socket instance.
     */
    constructor() PlugInitializable() {}

    /**
     * See {PlugSocketInterface-signer}.
     */
    function signer(PlugTypesLib.LivePlugs calldata $livePlugs)
        external
        view
        returns (address $signer)
    {
        /// @dev Determine the address that signed the Plug bundle.
        $signer = getLivePlugsSigner($livePlugs);
    }

    /**
     * See {PlugSocketInterface-plug}.
     */
    function plug(
        PlugTypesLib.Plugs calldata $plugs,
        address $signer,
        uint256 $gas
    )
        external
        payable
        virtual
        onlyTrustedForwarder()
        onlyTrusted($signer)
        nonReentrant
        returns (bytes[] memory $results)
    {
        /// @dev Process the Plug bundle with an external Executor.
        $results = _plug($plugs, $signer, $plugs.executor, $gas);
    }

    /**
     * See {PlugSocketInterface-plug}.
     */
    function plug(PlugTypesLib.Plugs calldata $plugs)
        external
        payable
        virtual
        onlyTrusted(msg.sender)
        nonReentrant
        returns (bytes[] memory $results)
    {
        /// @dev Process the Plug bundle without an external Executor.
        $results = _plug($plugs, msg.sender, address(0), 0);
    }

    /**
     * See {PlugInitializable-name}.
     */
    function name() public pure override returns (string memory) {
        return "PlugSocket";
    }
}
