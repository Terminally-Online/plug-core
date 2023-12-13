// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugRouter } from "./Plug.Router.sol";
import { Ownable } from "solady/src/auth/Ownable.sol";
import { LibBitmap } from "solady/src/utils/LibBitmap.sol";

/**
 * @title Plug Vault Router
 * @notice This contract represents an personal relay for a single owner,
 *         and a declared set of senders/signers.
 * @author @nftchance (chance@utc24.io)
 */
contract PlugVaultRouter is PlugRouter, Ownable {
    /// @dev Use bitmaps based on the uint-converted address.
    using LibBitmap for LibBitmap.Bitmap;

    /// @dev Whether or not the contract has been initialized.
    bool private initialized;

    /// @dev The signers of the contract.
    LibBitmap.Bitmap internal senders;

    /**
     * @notice Initializes a new Plug Vault contract.
     */
    constructor() {
        initialize(msg.sender);
    }

    /**
     * @notice Modifier to ensure that the contract has not been initialized.
     */
    modifier initializer() {
        require(!initialized, "PlugVaultRouter:already-initialized");

        initialized = true;
        _;
    }

    /**
     * @notice Initialize a new Plug Vault.
     * @param $owner The owner of the vault.
     */
    function initialize(address $owner) public payable virtual initializer {
        /// @dev Initialize the owner.
        _initializeOwner($owner);

        /// @dev Initialize the Plug Socket.
        _initializeSocket("PlugVaultSocket", "0.0.0");
    }

    /**
     * @notice Toggle a signer on or off.
     * @dev The signer if there was one, otherwise the transaction caller.
     * @param $sender The address executing the transaction.
     */
    function toggleSender(address $sender) public onlyOwner {
        senders.toggle(uint160($sender));
    }

    /**
     * @notice Determine whether or not an address is a declared signer
     *         or the implicit owner of the vault.
     * @param $isSender true if the address is a signer, false otherwise.
     */
    function isSender(address $sender) public view returns (bool $isSender) {
        $isSender = $sender == owner() || senders.get(uint160($sender));
    }

    /**
     * @notice Prevent the contract from executing the transaction
     *         if the sender is not an approved signer.
     * @param $sender The address of the signer.
     */
    function _enforceSender(address $sender) internal view override {
        require(isSender($sender), "PlugSigners:signer-invalid");
    }
}
