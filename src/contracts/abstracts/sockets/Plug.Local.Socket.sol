// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugSocket } from "../Plug.Socket.sol";
import { PlugTypesLib } from "../Plug.Types.sol";

/**
 * @title Plug Local Socket
 * @notice Consumers of this abstract MUST implement `.name()` and MAY choose
 *         to implement `.version()` in the case it diverges from the core
 *         or is not a native primitive of Plug.
 * @notice It is of critical importance that a trusted forwarder is not simultaneously
 *         a LocalSocket and Multicallable (or another variant) as one could
 *         create malicious calldata that allows them to impersonate an account
 *         they should not have permission to. If the only means of self-calling
 *         is through a Plug Local Socket that is okay because the decoded
 *         sender is always appended to the end of the calldata.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugLocalSocket is PlugSocket {
    /**
     * See {PlugEnforce-_enforceCurrent}.
     */
    function _enforceCurrent(PlugTypesLib.Current memory $current)
        internal
        view
        override
        returns (bool $allowed)
    {
        $allowed = $current.target == address(this);
    }

    /**
     * See {PlugEnforce-_enforceRouter}.
     */
    function _enforceRouter(address $router)
        internal
        view
        override
        returns (bool $allowed)
    {
        $allowed = $router == address(this) || super._enforceRouter($router);
    }
}
