// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {PlugTradingInterface} from '../interfaces/Plug.Trading.Interface.sol';
import {PlugLib} from '../libraries/Plug.Lib.sol';
import {ERC721Interface} from '../interfaces/ERC.721.Interface.sol';

abstract contract PlugTrading is PlugTradingInterface {
	address public ownership;

	address private _owner;

	modifier onlyTradable() {
		require(msg.sender == ownership, 'PlugTrading:forbidden-caller');
		_;
	}

	/**
	 * @notice Only the owner of the token can call functions that have
     *         this modifier applied onto it.
	 */
	modifier onlyOwner() {
		require(msg.sender == owner(), 'PlugTrading:forbidden-caller');
		_;
	}

	function _initializeOwnership(address $ownership) internal {
		ownership = $ownership;
	}

	function transferOwnership(address $newOwner) public virtual onlyTradable {
		_owner = $newOwner;
	}

	function owner() public view virtual returns (address) {
		return _owner;
	}
}
