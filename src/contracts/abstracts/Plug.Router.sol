// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { ReentrancyGuard } from "solady/src/utils/ReentrancyGuard.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";
import { PlugBalanceInterface } from
    "../interfaces/Plug.Balance.Interface.sol";

import { SafeTransferLib } from "solady/src/utils/SafeTransferLib.sol";

abstract contract PlugRouter is ReentrancyGuard {

    function plugNative(
        address payable $target,
        bytes calldata $data,
        uint256 $fee
    ) public payable virtual nonReentrant {
        uint256 preNative = address(this).balance - msg.value;

        (bool success, bytes memory reason) =
            $target.call{ value: msg.value }($data);
        PlugLib.bubbleRevert(success, reason);

        uint256 postNative = address(this).balance - $fee;

        // TODO: Handle fee checks and return surplus native tokens.
    }

    /**
     * @notice Run a transaction that consumes ERC20 tokens.
     * @param $tokenOut The address of the token being swapped.
     * @param $target The address of the contract to call.
     * @param $data The data to send to the target.
     * @param $sell The amount of tokens to sell.
     * @param $fee The fee to charge in $tokenOut amount.
     */
    function plugToken(
        address $tokenOut,
        address payable $target,
        bytes calldata $data,
        uint256 $sell,
        uint256 $fee
    ) public virtual payable nonReentrant { 
        /// @dev Retrieve the tokens being swapped from the transaction caller (a Socket)
        ///      and transfer them to this contract.
        SafeTransferLib.safeTransferFrom(
            $tokenOut, msg.sender, address(this), $sell
        );

        /// @dev Give the target permission to move the token being swapped if needed.
        SafeTransferLib.safeApprove($tokenOut, $target, $sell - $fee);

        /// @dev Submit the call that is going to return a declared amount of tokens.
        (bool success, bytes memory reason) =
            $target.call{ value: msg.value }($data);
        /// @dev If the call was not successful, bubble up the revert. Otherwise,
        ///      continue on with the execution.
        PlugLib.bubbleRevert(success, reason);

        /// @dev If the target did not use all of the tokens within allowance, revert
        ///      as a looming allowance is a security risk.
        if (
            PlugBalanceInterface($tokenOut).allowance(
                address(this), $target
            ) != 0
        ) {
            revert PlugLib.TokenAllowanceInvalid();
        }

        // TODO: Return surplus tokens that were not used in fee or transaction.
    }

    /**
     * @notice Run a transaction that consumes native tokens and returns EC20 tokens.
     * @param $tokenIn The address of the token being received.
     * @param $target The address of the contract to call.
     * @param $data The data to send to the target.
     * @param $fee The fee to charge in native token amount.
     */
    function plugNativeToToken(
        address $tokenIn,
        address payable $target,
        bytes calldata $data,
        uint256 $fee
    )
        public
        payable
        virtual
        nonReentrant
    {
        /// @dev Create the connected token interface.
        PlugBalanceInterface tokenIn = PlugBalanceInterface($tokenIn);

        /// @dev Take a snapshot of how much of the token being swapped for was within
        ///      the contract before the swap is fulfilled.
        uint256 preTokenIn = tokenIn.balanceOf(address(this));
        /// @dev Take a snapshot of how much of the native currency was within the
        ///      contract before this transaction was executed.
        uint256 preNative = address(this).balance - msg.value;
        /// @dev Calculate the amount of the native token that is available to use
        ///      when swapping the token.
        uint256 amountOut = msg.value - $fee;

        /// @dev Submit the call that is going to return a declared amount of tokens.
        (bool success, bytes memory reason) =
            $target.call{ value: amountOut }($data);
        /// @dev If the call was not successful, bubble up the revert. Otherwise,
        ///      continue on with the execution.
        PlugLib.bubbleRevert(success, reason);

        /// @dev Retrieve how many tokens this contract now holds.
        uint256 postTokenIn = tokenIn.balanceOf(address(this));

        /// @dev Confirm the tokens were received as expected. If not, revert.
        if (preTokenIn >= postTokenIn) {
            revert PlugLib.TokenReceiptInvalid();
        }

        /// @dev Deliver the swapped tokens to the sender.
        SafeTransferLib.safeTransfer(
            $tokenIn, msg.sender, postTokenIn - preTokenIn
        );

        /// @dev Retrieve how many native tokens this contract now holds.
        uint256 postNative = address(this).balance - $fee;

        /// @dev Return any surplus native tokens to the sender.
        if (postNative > preNative) {
            SafeTransferLib.safeTransferETH(
                msg.sender, postNative - preNative
            );
        }
    }

    /**
     * @notice Run a transaction that consumes ERC20s and returns ERC20s.
     * @param $tokenOut The address of the token being swapped.
     * @param $tokenIn The address of the token being received.
     * @param $target The address of the contract to call.
     * @param $data The data to send to the target.
     * @param $sell The amount of tokens to sell.
     * @param $fee The fee to charge in $tokenOut amount.
     */
    function plugTokenToToken(
        address $tokenOut,
        address $tokenIn,
        address payable $target,
        bytes calldata $data,
        uint256 $sell,
        uint256 $fee
    )
        public
        payable
        virtual
        nonReentrant
    {
        /// @dev Create the connected token interface.
        PlugBalanceInterface tokenIn = PlugBalanceInterface($tokenIn);

        /// @dev Take a snapshot of how much of the token being swapped for was within
        ///      the contract before the swap is fulfilled.
        uint256 preTokenIn = tokenIn.balanceOf(address(this));

        /// @dev Retrieve the tokens being swapped from the transaction caller (a Socket)
        ///      and transfer them to this contract.
        SafeTransferLib.safeTransferFrom(
            $tokenOut, msg.sender, address(this), $sell
        );

        /// @dev Give the target permission to move the token being swapped if needed.
        SafeTransferLib.safeApprove($tokenOut, $target, $sell - $fee);

        /// @dev Submit the call that is going to return a declared amount of tokens.
        (bool success, bytes memory reason) =
            $target.call{ value: msg.value }($data);
        /// @dev If the call was not successful, bubble up the revert. Otherwise,
        ///      continue on with the execution.
        PlugLib.bubbleRevert(success, reason);

        /// @dev If the target did not use all of the tokens within allowance, revert
        ///      as a looming allowance is a security risk.
        if (
            PlugBalanceInterface($tokenOut).allowance(
                address(this), $target
            ) != 0
        ) {
            revert PlugLib.TokenAllowanceInvalid();
        }

        /// @dev Retrieve how many tokens this contract now holds.
        uint256 postTokenIn = tokenIn.balanceOf(address(this));

        /// @dev Confirm the tokens were received as expected. If not, revert.
        if (preTokenIn >= postTokenIn) {
            revert PlugLib.TokenReceiptInvalid();
        }

        /// @dev Deliver the swapped tokens to the sender.
        SafeTransferLib.safeTransfer(
            $tokenIn, msg.sender, postTokenIn - preTokenIn
        );
    }

    /**
     * @notice Run a transaction that consumes ERC20s and returns native tokens.
     * @param $tokenOut The address of the token being swapped.
     * @param $target The address of the contract to call.
     * @param $data The data to send to the target.
     * @param $sell The amount of tokens to sell.
     * @param $fee The fee to charge in basis points on native token.
     */
    function plugTokenToNative(
        address $tokenOut,
        address payable $target,
        bytes calldata $data,
        uint256 $sell,
        uint256 $fee
    )
        public
        payable
        virtual
        nonReentrant
    {
        /// @dev Take a snapshot of how much of the native currency was within the
        ///      contract before this transaction was executed.
        uint256 preNative = address(this).balance - msg.value;

        /// @dev Retrieve the tokens being swapped from the transaction caller (a Socket)
        ///      and transfer them to this contract.
        SafeTransferLib.safeTransferFrom(
            $tokenOut, msg.sender, address(this), $sell
        );

        /// @dev Give the target permission to move the token being swapped if needed.
        SafeTransferLib.safeApprove($tokenOut, $target, $sell);

        /// @dev Submit the call that is going to return a declared amount of tokens.
        (bool success, bytes memory reason) =
            $target.call{ value: msg.value }($data);
        /// @dev If the call was not successful, bubble up the revert. Otherwise,
        ///      continue on with the execution.
        PlugLib.bubbleRevert(success, reason);

        /// @dev If the target did not use all of the tokens within allowance, revert
        ///      as a looming allowance is a security risk.
        if (
            PlugBalanceInterface($tokenOut).allowance(
                address(this), $target
            ) != 0
        ) {
            revert PlugLib.TokenAllowanceInvalid();
        }

        /// @dev Retrieve how many native tokens this contract now holds.
        uint256 postNative = address(this).balance;

        /// @dev Confim that the native balance actually increased.
        if(postNative <= preNative) {
            revert PlugLib.TokenReceiptInvalid();
        }

        /// @dev Determine the increase in native tokens.
        uint256 diffNative = postNative - preNative;

        /// @dev Handle the fee if one is present.
        if($fee > 0) { 
            /// @dev Calculate the fee in the form of basis points and transfer 
            ///      the remainder to the sender.
            uint256 fee = (diffNative * $fee) / 10 ** 18;
            /// @dev Transfer the native tokens earned without the fee to the sender.
            SafeTransferLib.safeTransferETH(msg.sender, diffNative - fee);
        } 
        /// @dev If there is no fee, return the entire amount to the sender. 
        else if (diffNative > 0) {
            /// @dev Transfer the native tokens earned to the sender.
            SafeTransferLib.safeTransferETH(msg.sender, diffNative);
        }
    }
}
