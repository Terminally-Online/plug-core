//SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import { IFuse } from "../interfaces/IFuse.sol";
import { PlugSocket } from "./Plug.Socket.sol";
import { PlugTypes, PlugTypesLib } from "../abstracts/Plug.Types.sol";

abstract contract PlugFuse is IFuse, PlugSocket, PlugTypes {
    /**
     * See {IFuseEnforcer-enforceFuse}.
     */
    function enforceFuse(
        bytes calldata $live,
        PlugTypesLib.Current calldata $current,
        bytes32 $pinHash
    )
        public
        virtual
        returns (bytes memory $callback);
}
