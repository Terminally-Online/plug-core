// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

library PlugSocketLib {
    address internal constant PLUG_ROUTER = 0x000009193925fa10DCD400a62CA178Ca000042F7;
}

/**
 * @title Plug Socket
 * @notice The socket contract of Plug enables the ability to utilize the forwarded sender/signer
 *         from a call bundle that may have originated from a Plug Router.
 * @author nftchance (chance@utc24.io)
 **/
abstract contract PlugSocket {
    address internal constant PLUG_ROUTER = 0x000009193925fa10DCD400a62CA178Ca000042F7;

    function _msgSender() internal view returns (address $signer) {
        assembly {
            mstore(0x00, caller())
            let withSender := PLUG_ROUTER
            if eq(caller(), withSender) {
                let success := staticcall(gas(), withSender, 0x00, 0x00, 0x20, 0x20)
                if iszero(success) { revert(codesize(), codesize()) }
                $signer := mload(0x20)
            }
        }
    }
}