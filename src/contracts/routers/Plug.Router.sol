// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import {PlugCore} from '../abstracts/Plug.Core.sol';
import {PlugTypesLib} from '../abstracts/Plug.Types.sol';
import {IPlug} from '../interfaces/IPlug.sol';

/**
 * @title Plug
 * @notice The core contract for the Plug framework that enables
 *         counterfactual revokable pin of extremely
 *         granular pin and execution paths.
 * @author @nftchance (chance@utc24.io)
 */
contract PlugRouter is PlugCore, IPlug {
	/**
	 * See {IPlug-plug}.
	 */
	function plug(
		PlugTypesLib.LivePlugs calldata $livePlugs
	) external payable returns (bytes[] memory $results) {
        /// @dev Determine who signed the intent.
        address intentSigner = getLivePlugsSigner($livePlugs);

        /// @dev Load the plugs as a hot reference.
        PlugTypesLib.Plugs calldata plugs = $livePlugs.plugs;

        /// @dev Prevent replay attacks by enforcing replay protection.
        _enforceBreaker(intentSigner, plugs.breaker);

        /// @dev Invoke the plugs.
        $results = _plug(plugs.plugs, intentSigner);
	}

	/**
	 * See {IPlug-plugContract}.
	 */
	function plugContract(
		PlugTypesLib.Plug[] calldata $plugs
	) external payable returns (bytes[] memory $result) {
		$result = _plug($plugs, msg.sender);
	}
}
