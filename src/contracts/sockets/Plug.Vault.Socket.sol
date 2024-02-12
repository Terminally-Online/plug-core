// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugSocket } from "../abstracts/Plug.Socket.sol";
import { Receiver } from "solady/src/accounts/Receiver.sol";
import { Ownable } from "solady/src/auth/Ownable.sol";
import { Initializable } from "solady/src/utils/Initializable.sol";
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { LibBitmap } from "solady/src/utils/LibBitmap.sol";

/**
 * @title Plug Vault Socket
 * @author @nftchance (chance@utc24.io)
 */
contract PlugVaultSocket is PlugSocket, Receiver, Ownable, Initializable {
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
        /// @dev Initialize the Plug Socket.
        _initializePlug(name(), version());

        /// @dev Add the owner as a signer to enable seamless
        ///      direct fulfillment of a Plug bundle without
        ///      the need for a signature.
        signers.toggle(uint160($owner));
    }

    /**
     * @notice Toggle a router on or off.
     * @dev Note that you cannot toggle off the default router.
     * @param $router The address of the router.
     * @return $isRouter true if the address is a router, false otherwise.
     */
    function toggleRouter(address $router)
        public
        virtual
        onlyOwner
        returns (bool $isRouter)
    {
        $isRouter = routers.toggle(uint160($router));
    }

    /**
     * @notice Toggle a signer on or off.
     * @param $signer The address of the signer.
     * @return $isSigner true if the address is a signer, false otherwise.
     */
    function toggleSigner(address $signer)
        public
        virtual
        onlyOwner
        returns (bool $isSigner)
    {
        $isSigner = signers.toggle(uint160($signer));
    }

    /**
     * See { PlugSocket-name }
     */
    function name() public pure override returns (string memory $name) {
        $name = "PlugVaultSocket";
    }

    /**
     * See { PlugSocket-version }
     */
    function version() public pure override returns (string memory $version) {
        $version = "0.0.1";
    }

    /**
     * See { PlugEnforce._enforceRouter }
     */
    function _enforceRouter(address $router)
        internal
        view
        override
        returns (bool $allowed)
    {
        $allowed =
            routers.get(uint160($router)) || super._enforceRouter($router);
    }

    /**
     * See { PlugEnforce._enforceSigner }
     */
    function _enforceSigner(address $signer)
        internal
        view
        override
        returns (bool $allowed)
    {
        $allowed = signers.get(uint160($signer));
    }

    /**
     * @notice Prevent double-initialization of the owner.
     * @return $guard true to enable the guard in Ownable.
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
