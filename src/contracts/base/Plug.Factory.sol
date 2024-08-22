// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { PlugFactoryInterface } from "../interfaces/Plug.Factory.Interface.sol";

import { PlugLib, PlugTypesLib } from "../libraries/Plug.Lib.sol";
import { LibClone } from "solady/utils/LibClone.sol";
import { Ownable } from "solady/auth/Ownable.sol";

import { PlugSocketInterface } from "../interfaces/Plug.Socket.Interface.sol";

/**
 * @title Plug Factory
 * @notice This contract is responsible for deploying new Plug Sockets that can be used
 *         as personal accounts for an individual. The owner can execute transactions
 *         through the Sockets. The Sockets are deployed using the Beacon Proxy
 *         pattern, and the owner can upgrade the implementation at any time. On top
 *         of being the deployment mechanism for the Sockets, the Factory also manages
 *         the ownership of the Sockets through the ERC721 standard allowing the
 *         Sockets to be traded on any major marketplace with ease.
 * @author @nftchance (chance@onplug.io)
 */
contract PlugFactory is PlugFactoryInterface, Ownable {
    /**
     * @notice Initialize a reference implementation that will not be
     *         with real intent of consumption.
     */
    constructor() {
        _initializeOwner(address(1));
    }

    /**
     * See { PlugFactoryInterface.initialize }
     */
    function initialize(address $owner, address $implementation) public virtual {
        /// @dev Configure the starting state of the tradable functionatlity
        ///      that enables non-fungible representation of Socket ownership.
        _initializeOwner($owner);
    }

    /**
     * See { PlugFactoryInterface.deploy }
     */
    function deploy(
        bytes calldata $salt
    )
        public
        payable
        virtual
        returns (bool $alreadyDeployed, address $socketAddress)
    {
        /// @dev Recover the packed implementation and admin from the salt.
        address implementation = address(uint160(uint256(bytes32($salt[0x14:]) >> 96)));
        address admin = address(uint160(uint256(bytes32($salt[:0x14]) >> 96)));

        /// @dev Ensure the implementation is valid.
        if (implementation == address(0) || admin == address(0)) {
            revert PlugLib.ImplementationInvalid(implementation);
        }

        bytes32 salt = bytes32(bytes20(uint160(admin)));

        /// @dev Deploy the new vault using a Beacon Proxy pattern.
        ($alreadyDeployed, $socketAddress) =
            LibClone.createDeterministicERC1967(msg.value, implementation, salt);

        /// @dev If the vault was not already deployed, initialize it.
        if (!$alreadyDeployed) {
            /// @dev Emit an event for the creation of the Vault to make
            ///      tracking things easier offchain.
            emit PlugLib.SocketDeployed(implementation, admin, salt);

            /// @dev Initialize the Socket with the ownership proxy pointing
            ///      this factory that is deploying the Socket.
            PlugSocketInterface($socketAddress).initialize(admin);
        }
    }

    /**
     * See { PlugFactoryInterface.getAddress }
     */
    function getAddress(
        address $implementation,
        bytes32 $salt
    )
        public
        view
        returns (address $vault)
    {
        $vault = LibClone.predictDeterministicAddressERC1967($implementation, $salt, address(this));
    }

    /**
     * See { PlugFactoryInterface.initCodeHash }
     */
    function initCodeHash(
        address $implementation
    )
        public
        view
        virtual
        returns (bytes32 $initCodeHash)
    {
        $initCodeHash = LibClone.initCodeHashERC1967($implementation);
    }
}
