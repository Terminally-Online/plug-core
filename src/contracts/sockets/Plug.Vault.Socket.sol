// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugSocket } from "../abstracts/Plug.Socket.sol";
import { Ownable } from "solady/src/auth/Ownable.sol";
import { Initializable } from "solady/src/utils/Initializable.sol";

import { LibBitmap } from "solady/src/utils/LibBitmap.sol";

/**
 * @title Plug Vault Socket
 * @notice This contract represents an personal relay for a single owner, and
 *         declared set of signers.
 * @author @nftchance (chance@utc24.io)
 */
contract PlugVaultSocket is PlugSocket, Ownable, Initializable {
    using LibBitmap for LibBitmap.Bitmap;

    /// @dev Bitmap of the allowed routers of the contract.
    LibBitmap.Bitmap internal routers;
    /// @dev Bitmap of the allowed signers of the contract.
    LibBitmap.Bitmap internal signers;

    /*
     * @notice The constructor for the Plug Vault Socket will
     *         initialize to address(1) when not deployed through
     *         a Socket factory.
     */
    constructor() {
        initialize(address(1));
    }

    /**
     * @notice Initializes a new Plug Vault Socket contract.
     */
    function initialize(address $owner) public initializer {
        /// @dev Initialize the owner.
        _initializeOwner($owner);
        _initializePlug(name(), version());

        /// @dev Add the owner as a signer.
        signers.toggle(uint160($owner));
    }

    /**
     * @notice Toggle a signer on or off.
     * @param $signer The address of the signer.
     * @return $isSigner true if the address is a signer, false otherwise.
     */
    function toggleSigner(address $signer)
        public
        onlyOwner
        returns (bool $isSigner)
    {
        $isSigner = signers.toggle(uint160($signer));
    }

    /**
     * @notice Name used for the domain separator.
     */
    function name() public pure returns (string memory) {
        return "PlugVaultSocket";
    }

    /**
     * @notice Version used for the domain separator.
     */
    function version() public pure returns (string memory) {
        return "0.0.1";
    }

    /**
     * @notice Enforce previous approval of a router by the owner of the
     *         Socket to successfully execute a bundle.
     * @param $router The address of the router.
     */
    function _enforceRouter(address $router)
        internal
        pure
        override
        returns (bool $allowed)
    {
        $allowed = routers.get(uint160($router)) || super._enforceRouter($router);
    }

    /**
     * @notice Enforce previous approval of a signer by the owner of the
     *         Socket to successfully execute a bundle.
     * @param $signer The address of the signer.
     */
    function _enforceSigner(address $signer)
        internal
        pure
        override
        returns (bool $allowed)
    {
        $allowed =
            signers.get(uint160($signer));
    }

    /**
     * @notice Prevent double-initialization of the owner.
     */
    function _guardInitializeOwner()
        internal
        pure
        virtual
        override
        returns (bool $guard)
    {
        $guard = true;
    }
}
