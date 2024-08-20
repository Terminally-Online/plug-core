// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugSocket } from "../abstracts/Plug.Socket.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";
import { Receiver } from "solady/accounts/Receiver.sol";
import { Ownable } from "solady/auth/Ownable.sol";
import { UUPSUpgradeable } from "solady/utils/UUPSUpgradeable.sol";
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { MerkleProofLib } from "solady/utils/MerkleProofLib.sol";

/**
 * @title Plug Vault Socket
 * @author @nftchance (chance@onplug.io)
 */
contract PlugVaultSocket is PlugSocket, Ownable, Receiver, UUPSUpgradeable {
    /**
     * @notice Only allow calls from senders that represent the Socket owner
     *         or the Socket itself to allow owner-only action as well as
     *         internal actions declared by the Socket owner.
     */
    modifier onlyThis() {
        if (msg.sender != owner()) {
            if (msg.sender != address(this)) {
                /// @dev If the sender is an invalid caller, revert.
                revert PlugLib.CallerInvalid(address(this), msg.sender);
            }
        }
        _;
    }

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
        $name = "Plug Vault Socket";
    }

    /**
     * See { PlugSocket-version }
     */
    function version() public pure override returns (string memory $version) {
        $version = "0.0.1";
    }

    /**
     * @notice Confirm that the only specified routers can execute the transaction.
     * @dev If you would like to limit the available routers override this
     *      function in your contract with the additional logic.
     * @param $router The router of the transaction.
     */
    function _enforceRouter(
        address $router
    )
        internal
        view
        virtual
        override
        returns (bool $allowed)
    {
        // $allowed = $router == router;
    }

    /**
     * See { PlugEnforce._enforceSignature }
     */
    function _enforceSignature(
        PlugTypesLib.LivePlugs calldata $input
    )
        internal
        view
        virtual
        override
        returns (bool $allowed)
    {
        $allowed = true;
    }

    /**
     * See { PlugEnforce._enforceSender }
     */
    function _enforceSender(
        address $sender
    )
        internal
        view
        virtual
        override
        returns (bool $allowed)
    {
        $allowed = $sender == owner() || $sender == address(this);
    }

    /**
     * See { UUPSUpgradeable._authorizeUpgrade }
     */
    function _authorizeUpgrade(address) internal virtual override onlyThis { }

    /**
     * See { PlugTrading._guardInitializeOwnership }
     */
    function _guardInitializeOwnership() internal pure virtual returns (bool $guard) {
        $guard = true;
    }
}
