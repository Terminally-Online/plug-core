//SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import {PlugSocket} from './Plug.Socket.sol';
import {PlugTypesLib} from '../abstracts/Plug.Types.sol';
import {IFuse} from '../interfaces/IFuse.sol';

abstract contract PlugFuse is PlugSocket, IFuse {
	/**
	 * See {IFuseEnforcer-enforceFuse}.
	 */
	function enforceFuse(
		bytes calldata $live,
		PlugTypesLib.Current calldata $current,
		bytes32 $pinHash
	) public virtual returns (bytes memory $callback);
}
