// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {PlugTradingInterface} from '../interfaces/Plug.Trading.Interface.sol';
import {PlugLib} from '../libraries/Plug.Lib.sol';
import {ERC721Interface} from '../interfaces/ERC.721.Interface.sol';

/**
 * @title Plug Trading
 * @notice Enables the ability to represent Socket ownership through the current
 *         state of an ERC721 that is managed inside the factory that deployed
 *         the Vault. This way, Vaults can be traded on any major marketplace
 *         enabling the ability to spread workflows and earnings of
 *         aforementioned workflows such as points and yield.
 * @author nftchance (chance@onplug.io)
 */
abstract contract PlugTrading is PlugTradingInterface {
	/// @dev The address that houses the ownership information.
	address public ownership;

	bytes32 public imageHash;

	/**
	 * @notice Modifier enforcing the caller to be the ownership proxy.
	 */
	modifier onlyOwnership() {
		/// @dev Ensure the `caller` is the ownership proxy.
		require(msg.sender == ownership, 'PlugTrading:forbidden-caller');
		_;
	}

	/**
	 * @notice Modifier enforcing that  only the owner of the token can call
	 *         functions that have this modifier applied.
	 */
	modifier onlyOwner() {
		/// @dev Ensure the `caller` is the owner of the Socket.
		require(msg.sender == owner(), 'PlugTrading:forbidden-caller');
		_;
	}

	/**
	 * @notice Transfer the ownership of a Vault to a new address when the
	 *         NFT is transferred.
	 * @param $newOwner The address of the new owner.
	 */
	function transferOwnership(address $newOwner) public virtual onlyOwnership {
        _transferOwnership($newOwner);
	}

	/**
	 * @notice Get the owner of the Vault.
	 */
	function owner() public view virtual returns (address $owner) {
		$owner = ERC721Interface(ownership).ownerOf(
			uint256(uint160(address(this)))
		);
	}

	/**
	 * @notice Set the address of the ownership proxy which is a ERC721
	 *         compliant contract that lives inside of the factory.
	 */
	function _initializeOwnership(address $ownership) internal {
		/// @dev Check if the inheriting contract requires single-use
		///      ownership initialization.
		if (_guardInitializeOwnership()) {
			/// @dev Confirm the ownership has not been set yet.
			require(ownership == address(0), 'PlugTrading:already-initialized');
		}

		/// @dev Set the state of the ownership proxy.
		ownership = $ownership;
	}

    function _transferOwnership(address $newOwner) internal {
        /// @dev Calculate the image hash based on the new owner. For now, this version
        ///      assumes definition of a single Socket owner.
		bytes32 expectedImageHash = keccak256(
			abi.encodePacked(
				keccak256(
					abi.encodePacked(
						abi.decode(
							abi.encodePacked(uint96(1), $newOwner),
							(bytes32)
						),
						uint256(1)
					)
				),
				uint256(1)
			)
		);

		// TODO: Utilize the updated the image hash to update the image hash in the
        //       signature contract instead of this one.
        imageHash = expectedImageHash;

        /// @dev Emit the event to signify transfer change as well as a change in
        ///      the image hash so that it can be utilized elsewhere.
        emit PlugLib.SocketOwnershipTransferred(
            owner(),
            $newOwner,
            expectedImageHash
        );
    }

	/**
	 * @notice Guard the initial ownership of the Vault to ensure that the
	 *         ownership is set to the correct address and cannot be changed
	 *         one it has been defined. This makes the state immutable in
	 *         practice even though the variable itself is not semantically
	 *         immutable outside the scope of logic enforcement.
	 * @dev By default this function has an empty implementation so that not
	 *      all inheriting contracts are required to define this function. If
	 *      you would like to enforce single-use ownership initialization, you
	 *      can override this function and return `true` to enforce the guard.
	 */
	function _guardInitializeOwnership()
		internal
		pure
		virtual
		returns (bool $guard)
	{}
}
