// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

library PlugSocketLib {
    address internal constant PLUG_ROUTER = 0x0000000000002Bdbf1Bf3279983603Ec279CC6dF;
}

abstract contract PlugSocket {
    address internal constant PLUG_ROUTER = 0x0000000000002Bdbf1Bf3279983603Ec279CC6dF;

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
