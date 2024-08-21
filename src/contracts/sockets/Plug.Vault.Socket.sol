// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {PlugSocket} from '../abstracts/Plug.Socket.sol';
import {PlugLib} from '../libraries/Plug.Lib.sol';
import {Receiver} from 'solady/accounts/Receiver.sol';
import {Ownable} from 'solady/auth/Ownable.sol';
import {UUPSUpgradeable} from 'solady/utils/UUPSUpgradeable.sol';
import {PlugTypesLib} from '../abstracts/Plug.Types.sol';
import {ECDSA} from 'solady/utils/ECDSA.sol';
import {MerkleProofLib} from 'solady/utils/MerkleProofLib.sol';

/**
 * @title Plug Vault Socket
 * @author @nftchance (chance@onplug.io)
 */
contract PlugVaultSocket is PlugSocket, Ownable, Receiver, UUPSUpgradeable {
	/// @notice Use the ECDSA library for signature verification.
	using ECDSA for bytes32;

	/*
	 * @notice The constructor for the Plug Vault Socket will
	 *         initialize to address(1) when not deployed through
	 *         a Socket factory.
	 */
	constructor() {
		initialize(address(1));
	}

	/**
	 * @notice Initializes a new Plug Vault Socket.
	 * @param $owner The address of the owner.
	 */
	function initialize(address $owner) public {
		_initializeOwner($owner);
	}

	/**
	 * See { PlugSocket-name }
	 */
	function name() public pure override returns (string memory $name) {
		$name = 'Plug Vault Socket';
	}

	/**
	 * See { PlugSocket-version }
	 */
	function version() public pure override returns (string memory $version) {
		$version = '0.0.1';
	}

	/**
	 * See { PlugEnforce._enforceSignature }
	 */
	function _enforceSignature(
		PlugTypesLib.LivePlugs calldata $input
	) internal view virtual override returns (bool $allowed) {
		/// @dev The last bit denotes whether it is a standard signature
		///      or a merkle proof signature.
		bytes1 signatureType = $input.signature[0];

		/// @dev Utilize a standard signature recovery method that is only designed
		///      to support one domain and intent at a time.
		if (signatureType & 0x03 == signatureType) {
			$allowed =
				owner() ==
				getPlugsDigest($input.plugs).recover($input.signature);
		}
		/// @dev Utilize a merkle proof signature recovery method that holds several
		///      domains and intents at a time inside a single signature.
		else if (signatureType & 0x04 == signatureType) {
			/// @dev Recover the merkle proof data from the packed signature.
			(bytes32 root, bytes32[] memory proof, bytes memory signature) = abi
				.decode($input.signature[1:], (bytes32, bytes32[], bytes));

			/// @dev Ensure the merkle tree contains the data of the signed bundle.
			if (
				MerkleProofLib.verify(
					proof,
					root,
					getPlugsHash($input.plugs)
				) == false
			) revert PlugLib.ProofInvalid();

			/// @dev Calculate the offset needed to extract solely the signature from
			///      the packed state of the `signature` data provided.
			uint256 offset = proof.length * 32 + 161;

			$allowed =
				owner() ==
				getPlugsDigest($input.plugs).recover(
					$input.signature[offset:offset + signature.length]
				);
		}
	}

	/**
	 * See { PlugEnforce._enforceSender }
	 */
	function _enforceSender(
		address $sender
	) internal view virtual override returns (bool $allowed) {
		$allowed = $sender == owner() || $sender == address(this);
	}

	/**
	 * See { UUPSUpgradeable._authorizeUpgrade }
	 */
	function _authorizeUpgrade(address) internal virtual override onlyOwner {}

	/**
	 * See { PlugTrading._guardInitializeOwnership }
	 */
	function _guardInitializeOwnership()
		internal
		pure
		virtual
		returns (bool $guard)
	{
		$guard = true;
	}
}
