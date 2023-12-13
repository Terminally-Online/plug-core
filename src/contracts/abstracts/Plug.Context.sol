// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

abstract contract PlugContext {
    // constructor() {
    //     assembly {
    //         sstore(returndatasize(), 1)
    //     }
    // }
    //
    // /**
    //  * @notice Modifier that prevents reentrancy attacks while
    //  *         also providing the sender of message for forwarded
    //  *         sender access in external consumers.
    //  * @dev If a plug is being executed, the sender is the
    //  *      address that has been stored in the slot, otherwise
    //  *      it will always be address zero.
    //  */
    // modifier memoized(address $sender) {
    //     /// @dev Ensure the sender is not already set.
    //     require(
    //         memo & 0x1 == 0,
    //         'PlugContext:transient-sender-already-set'
    //     );
    //
    //     /// @dev Update the slot with the sender and mark the
    //     ///      last bit as 1 to indicate the function is entered.
    //     memo = uint160($sender) << 1 | 0x1;
    //     _;
    //     /// @dev Reset the slot to 0.
    //     delete memo;
    // }
    //
    // function _msgSender() internal view returns (address $signer) {
    //     /// @dev If a plug is being executed, the sender is the
    //     ///      address that has been stored in the slot.
    //     if (memo & 0x1 == 1)
    //         $signer = address(uint160(memo >> 1));
    //     else
    //         $signer = msg.sender;
    // }
}
