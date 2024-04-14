//SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

/// @dev Shape declarations in the Plug framework.
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";

interface PlugFuseInterface {
    /**
     * @notice Enforces a fuse on a transaction.
     * @param $terms The execution terms applied to the underlying.
     * @param $plugsHash The hash of the bundle of Plugs that includes
     *                   the `salt` field allowing for redefinition of
     *                   the same action without forbiding action-state.
     *                   This cannot be calculated at the time of creating
     *                   the bundle due to the recursive nature of the
     *                   Plug framework that would be required.
     */
    function enforceFuse(bytes calldata $terms, bytes32 $plugsHash) external;
}
