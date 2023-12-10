// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {PlugSocket} from '../abstracts/Plug.Socket.sol';
import {Ownable} from 'solady/src/auth/Ownable.sol';

contract PlugVaultSocket is PlugSocket, Ownable {
	bool private initialized;

	constructor() {
		/// @dev Initialize the owner as an invalid address.
		initialize(address(0xdead));
	}

	modifier initializer() {
		require(!initialized, 'PlugVaultSocket: already initialized');
		_;
		initialized = true;
	}

	/**
	 * @notice Initialize a new Plug Vault.
	 * @param $owner The owner of the vault.
	 */
	function initialize(address $owner) public virtual initializer {
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
