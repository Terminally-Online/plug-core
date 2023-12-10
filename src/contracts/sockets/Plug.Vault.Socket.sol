// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {PlugSocket} from '../abstracts/Plug.Socket.sol';
import {Ownable} from 'solady/src/auth/Ownable.sol';

contract PlugVaultSocket is PlugSocket, Ownable {
	constructor() {
		/// @dev Initialize the owner as an invalid address.
		_initializeOwner(address(0xdead));

		/// @dev The plug is not initialized here to prevent the
		/// 	 any messages from being relayed through here.
	}

	/**
	 * @notice Initialize a new Plug Vault.
	 * @param $owner The owner of the vault.
	 */
	function initialize(address $owner) external virtual {
		/// @dev Initialize the owner.
		_initializeOwner($owner);

		/// @dev Initialize the Plug Socket.
		_initializeSocket('PlugVaultSocket', '0.0.0');
	}

	/**
	 * @notice Prevent the initializer from being called multiple times. 	
	 * @return true if the initializer has already been called.
	 */
	function _guardInitializeOwner()
		internal
		pure
		virtual
		override
		returns (bool)
	{
		return true;
	}
}
