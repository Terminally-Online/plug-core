// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Ownable } from "solady/src/auth/Ownable.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";
import { Receiver } from "solady/src/accounts/Receiver.sol";
import { LibBitmap } from "solady/src/utils/LibBitmap.sol";

/**
 * @title Plug.Trusted
 * @notice A BitMap is used to cast the address to a uint160. It is honestly rather
 *         unlikely though that we will ever have multiple addresses that are
 *         in the same slot. Still, it is a possibility and thus gas would be saved.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugTrusted is Ownable, Receiver {
    using LibBitmap for LibBitmap.Bitmap;
    using PlugLib for address;

    /// @dev The bitmap that stores the trusted forwarders.
    LibBitmap.Bitmap internal trustedForwarders;

    modifier onlyTrustedForwarder() {
        require(isTrustedForwarder(msg.sender), "Plug: Not a trusted forwarder");
        _;
    }

    modifier onlyTrusted(address $signer) {
        require(
            isTrustedForwarder($signer) || msg.sender == owner(),
            "Plug: Not a trusted forwarder or owner"
        );
        _;
    }

    /**
     * @notice Toggle the state of a forwarder on or off.
     * @param $forwarder The address of the forwarder.
     * @return $isTrusted true if the address is a trusted forwarder, false otherwise.
     */
    function toggleTrustedForwarder(address $forwarder)
        public
        virtual
        onlyOwner
        returns (bool $isTrusted)
    {
        $isTrusted = trustedForwarders.toggle(uint160($forwarder));
    }

    /**
     * @notice Determine and return whether or not an address is a trusted forwarder
     *         that will enable the ability to safely recover the signer (or intended
     *         sender) from the end of the calldata.
     * @param $forwarder The address of the forwarder.
     * @return $trusted true if the address is a trusted forwarder, false otherwise.
     */
    function isTrustedForwarder(address $forwarder)
        public
        view
        virtual
        returns (bool $trusted)
    {
        $trusted = msg.sender.isRouter()
            || trustedForwarders.get(uint160($forwarder));
    }
}
