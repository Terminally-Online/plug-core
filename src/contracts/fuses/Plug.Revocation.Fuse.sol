//SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

/// @dev Plug abstracts.
import { PlugFuseInterface } from "../interfaces/Plug.Fuse.Interface.sol";
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { PlugLocalSocket } from "../abstracts/sockets/Plug.Local.Socket.sol";

/// @dev Hash declarations and decoders for the Plug framework.
import { ECDSA } from "solady/src/utils/ECDSA.sol";

/**
 * @title Revocation Enforcer
 * @notice This Fuse Enforcer operates as an independent instance of the
 *         Plug enabling the revocation of previously signed pins.
 *         After revocation, it is not possible for the signer to reuse the
 *         exact same pin therefore it is recommended to set salt as
 *         as the timestamp of generation (in milliseconds) to ensure that
 *         the signer can still reuse the same pin with a new salt.
 * @author @nftchance
 */
contract PlugRevocationFuse is PlugFuseInterface, PlugLocalSocket {
    /// @notice Use the ECDSA library for signature verification.
    using ECDSA for bytes32;

    constructor() PlugLocalSocket() { }

    /**
     * See {FuseEnforcer-enforceFuse}.
     */
    function enforceFuse(
        bytes calldata,
        PlugTypesLib.Current calldata $current,
        bytes32 $plugsHash
    )
        public
        view
        override
        returns (bytes memory $through)
    {
        /// @dev Ensure the plug has not been revoked.
        require(!isRevoked[$plugsHash], "PlugRevocationFuse:revoked");

        /// @dev Continue the pass through.
        $through = $current.data;
    }

    /**
     * @notice Enables a Delegator to revoke the pins of a previously
     *         signed signature.
     * @param $livePlugs The signed bundle of Plugs to revoke.
     * @param $domainHash The domain hash of the Plugs bundle.
     */
    function revoke(
        PlugTypesLib.LivePlugs calldata $livePlugs,
        bytes32 $domainHash
    )
        public
    {
        /// @dev Only allow the signer of a Plugs bundle to revoke a
        ///      signature. Revocation itself uicould be plugged.
        require(
            getSigner($livePlugs, $domainHash) == _msgSender(),
            "PlugRevocationFuse:invalid-revoker"
        );

        /// @dev Determine the hash of the pin.
        bytes32 plugsHash = getLivePlugsHash($livePlugs);

        /// @dev Ensure the bundle of Plugs has not already been revoked.
        require(!isRevoked[plugsHash], "PlugRevocationFuse:already-revoked");

        /// @dev Mark the bundle of Plugs as revoked.
        isRevoked[plugsHash] = true;
    }

    /**
     * @notice Determine the signer of a signed pin.
     * @dev We use custom functions here because the domain separator is
     *      different for each LivePin.
     * @param $livePlugs The signed bundle of Plugs to execute.
     * @param $domainHash The domain hash of the pin.
     * @return $signer The address of the signer.
     */
    function getSigner(
        PlugTypesLib.LivePlugs memory $livePlugs,
        bytes32 $domainHash
    )
        public
        view
        returns (address $signer)
    {
        /// @dev Determine the digest of the pin and recover the signer.
        $signer = getDigest($livePlugs.plugs, $domainHash).recover(
            $livePlugs.signature
        );
    }

    /**
     * @notice Determine the digest of a pin.
     * @param $livePlugs The pin to determine the digest of.
     * @param $domainHash The domain hash of the pin.
     * @return $digest The digest of the pin.
     */
    function getDigest(
        PlugTypesLib.Plugs memory $livePlugs,
        bytes32 $domainHash
    )
        public
        pure
        returns (bytes32 $digest)
    {
        /// @dev Encode the pin and domain hash and hash them.
        $digest = keccak256(
            abi.encodePacked("\x19\x01", $domainHash, getPlugsHash($livePlugs))
        );
    }

    /**
     * See {PlugInitializable-name}.
     */
    function name() public pure override returns (string memory) {
        return "PlugRevocationFuse";
    }
}
