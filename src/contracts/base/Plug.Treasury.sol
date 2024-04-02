// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Receiver} from 'solady/src/accounts/Receiver.sol';
import {Ownable} from 'solady/src/auth/Ownable.sol';
import {Multicallable} from 'solady/src/utils/Multicallable.sol';
import {PlugSwapper, PlugLib} from '../abstracts/Plug.Swapper.sol';

/**
 * @title PlugTreasury
 * @notice The Treasury contract that receives fees from the Plug
 *         framework. While the owner of the treasury can execute
 *         arbitrary transactions, the Treasury also has a built-in
 *         Swapper to enable streamlined fee collection while allowing
 *         the tokens to remain in the Treasury rather than needing
 *         another token transfer.
 */
contract PlugTreasury is Receiver, Ownable, Multicallable, PlugSwapper {
	/**
	 * @notice Initialize the contract with the owner.
	 * @param $owner The address of the owner.
	 */
	function initialize(address $owner) public {
		_initializeOwner($owner);
	}

	/**
	 * @notice Set the targets allowed to be executed by the Treasury.
	 * @param $targets The targets to set the allowed status for.
	 * @param $allowed The allowed status to set.
	 */
	function setTargetsAllowed(
		address[] calldata $targets,
		bool $allowed
	) public virtual onlyOwner {
		for (uint256 $i; $i < $targets.length; $i++) {
			targetToAllowed[$targets[$i]] = $allowed;
		}
	}

	/**
	 * @notice Execute an arbitrary set of transactions from the Treasury.
     * @dev Only the owner of the Treasury can execute arbitrary calls and
     *      the targets do not have to be on the list of allowed targets.
	 * @param $transactions An array of encoded transactions to execute
     *        within the context of the Treasury.
	 */
	function multicall(
		bytes[] calldata $transactions
	) public virtual override onlyOwner returns (bytes[] memory) {
        return super.multicall($transactions);
	}

	/**
	 * See {Ownable-_initializeOwner}.
	 */
	function _guardInitializeOwner()
		internal
		pure
		override
		returns (bool $guard)
	{
		$guard = true;
	}
}