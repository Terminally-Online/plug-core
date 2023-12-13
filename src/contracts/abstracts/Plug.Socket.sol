// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

abstract contract PlugSocket {
    address internal constant PLUG_WITH_SENDER = 0x0000000000002Bdbf1Bf3279983603Ec279CC6dF;
    address internal constant PLUG_WITH_SIGNER = 0x0000000000002Bdbf1Bf3279983603Ec279CC6dF;

    function _msgSender() internal view returns (address $signer) {
        assembly {
            mstore(0x00, caller())
            let withSender := PLUG_WITH_SENDER
            if eq(caller(), withSender) {
                let success := staticcall(gas(), withSender, 0x00, 0x00, 0x20, 0x20)
                if iszero(success) {
                    revert(codesize(), codesize())
                }
                $signer := mload(0x20)
            }
            let withSigner := PLUG_WITH_SIGNER
            if eq(caller(), withSigner) {
                let success := staticcall(gas(), withSigner, 0x00, 0x00, 0x20, 0x20)
                if iszero(success) {
                    revert(codesize(), codesize())
                }
                $signer := mload(0x20)
            }
        }
    }
}
