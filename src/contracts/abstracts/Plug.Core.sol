// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import {PlugContext} from './Plug.Context.sol';
import {PlugTypes, PlugTypesLib} from './Plug.Types.sol';
import {IFuse} from '../interfaces/IFuse.sol';
import {PlugErrors} from '../libraries/Plug.Errors.sol';

/**
 * @title Plug Core
 * @notice The core contract for the Plug framework that enables
 *         counterfactual revokable pin of extremely
 *         granular pin and execution paths.
 * @author @nftchance
 */
abstract contract PlugCore is PlugContext, PlugTypes {
	using PlugErrors for bytes;

    error Reentrancy();

    error InvalidSignature();

    error InvalidNonce();

    constructor() {
        assembly {
            sstore(returndatasize(), 1)
        }
    }

    /**
     * @dev Returns the signer passed into `plug` on this contract.
     *      The value is always the zero address outside a transaction.
     */
    receive() external payable {
        assembly {
            mstore(0x0c, sload(returndatasize()))
            return(returndatasize(), 0x20)
        }
    }

	function _enforceFuse(
		PlugTypesLib.Fuse memory $fuse,
		PlugTypesLib.Current memory $current,
		bytes32 $pinHash
	) internal returns (bool $success, bytes memory $returnData) {
		/// @dev Call the Fuse to determine if it is valid.
		($success, $returnData) = address($fuse.neutral).call(
			abi.encodeWithSelector(
				IFuse($fuse.neutral).enforceFuse.selector,
				$fuse.live,
				$current,
				$pinHash
			)
		);

		/// @dev If the Fuse failed and is not optional, bubble up the revert.
		if (!$success && $fuse.forced) $returnData.bubbleRevert();
	}

	/**
	 * @notice Execution a built transaction.
	 * @param $to The address of the contract to execute.
	 * @param $data The data to execute on the contract.
	 * @param $voltage The value to send with the transaction.
	 * @param $sender The address of the sender.
	 * @return $result The return data of the transaction.
	 */
	function _execute(
		address $to,
		bytes memory $data,
		uint256 $voltage,
		address $sender
	) internal returns (bytes memory $result) {
        assembly {
            /// @dev Set the signer slot to the sender.
            sstore(0, shl(96, $sender))
            $result := mload(0x40)
            let success := call(
                gas(),
                $to,
                $voltage,
                add($data, 0x20),
                mload($data),
                0x00, /// @dev Ignored because we will use returndatacopy() instead.
                0x00  /// @dev ...
            )
            /// @dev If the call failed, bubble up the revert.
            if iszero(success) {
                /// @dev Copy the revert data into memory at 0x00.
                returndatacopy(0x00, 0x00, returndatasize())
                revert(0x00, returndatasize())
            }
        }
	}

	/**
	 * @notice Execute an array of plugs
	 * @param $plugs The plugs of plugs to execute.
	 * @param $sender The address of the sender.
	 * @return $results The return data of the plugs.
	 */
	function _plug(
		PlugTypesLib.Plug[] calldata $plugs,
		address $sender
	) internal returns (bytes[] memory $results) {
        assembly {
            /// @dev Ensure the contract is not reentrant.
            if iszero(and(1, sload(returndatasize()))) {
                /// @dev Store the error being throw in memory at 0x00.
                mstore(returndatasize(), 0xab143c06)
                /// @dev Throw with `Reentrancy()`.
                revert(0x1c, 0x04)
            }
        }

        /// @dev Warm up the results array.
        $results = new bytes[]($plugs.length);

		/// @dev Load the stack.
		uint256 i;
		uint256 j;
		uint256 k;
		address canGrant;
		address intendedSender;
		address pinSigner;
		bytes32 pinHash;

		/// @dev Load the structs into a hot reference.
		PlugTypesLib.Plug memory plug;
		PlugTypesLib.LivePin memory signedPin;
		PlugTypesLib.Pin memory pin;
		PlugTypesLib.Current memory current;

		/// @dev Iterate over the plugs.
		for (i; i < $plugs.length; i++) {
			/// @dev Load the plug from the plugs.
			plug = $plugs[i];

			/// @dev Reset the hot reference to the pinHash.
			pinHash = 0x0;

			/// @dev Load the transaction from the plug.
			current = plug.current;

			/// @dev If there are no pins, this plug comes from the signer
			if (plug.pins.length == 0) {
				canGrant = intendedSender = $sender;
			} else {
				/// @dev Iterate over the authority pins.
				for (j = 0; j < plug.pins.length; j++) {
					/// @dev Load the pin from the plug.
					signedPin = plug.pins[j];

					/// @dev Determine the signer of the pin.
					pinSigner = getLivePinSigner(signedPin);

					/// @dev Implied sending account is the signer of the first pin.
					if (j == 0) canGrant = intendedSender = pinSigner;

					/// @dev Ensure the pin signer has authority to grant
					///      the claimed pin.
					require(
						pinSigner == canGrant,
						'PlugCore:invalid-pin-signer'
					);

					/// @dev Warm up the pin reference.
					pin = signedPin.pin;

					/// @dev Ensure the pin is valid.
					require(
						pin.live == pinHash,
						'PlugCore:invalid-authority-pin-link'
					);

					/// @dev Retrieve the packet hash for the pin.
					pinHash = getLivePinHash(signedPin);

					/// @dev Loop through all the execution fuses declared in the pin
					///      and ensure they are in a state of acceptable execution.
					for (k = 0; k < pin.fuses.length; k++)
						_enforceFuse(pin.fuses[k], current, pinHash);
				}
			}

			/// @dev Verify the delegate at the end of the pin chain is the signer.
			require(canGrant == $sender, 'PlugCore:invalid-signer');

            /// @dev Execute the transaction.
            $results[i] = _execute(
                current.ground,
                current.data,
                current.voltage,
                intendedSender
            );
		}

        assembly {
            /// @dev Clear the signer slot and retoggle reentrency.
            sstore(0, 1)
        }
	}
}
