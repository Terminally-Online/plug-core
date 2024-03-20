// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Test, Vm } from "forge-std/Test.sol";
import { ECDSA } from "solady/src/utils/ECDSA.sol";

contract TestPlug {
    function getExpectedImageHash(
        address user,
        uint8 weight,
        uint16 threshold,
        uint32 checkpoint
    )
        internal
        pure
        returns (bytes32 $imageHash)
    {
        $imageHash = keccak256(
            abi.encodePacked(
                keccak256(
                    abi.encodePacked(
                        abi.decode(
                            abi.encodePacked(uint96(weight), user), (bytes32)
                        ),
                        uint256(threshold)
                    )
                ),
                uint256(checkpoint)
            )
        );
    }

    function sign(
        Vm $vm,
        bytes32 $hash,
        address $account,
        uint256 $userKey,
        bool $isSign
    )
        internal
        view
        returns (bytes memory $signature)
    {
        // Create the subdigest
        bytes32 subdigest = keccak256(
            abi.encodePacked("\x19\x01", block.chainid, $account, $hash)
        );

        /// @dev The actual hash that was signed w/ EIP-191 flag
        subdigest =
            $isSign ? ECDSA.toEthSignedMessageHash(subdigest) : subdigest;

        /// @dev Create the signature w/ the subdigest
        (uint8 v, bytes32 r, bytes32 s) = $vm.sign($userKey, subdigest);

        /// @dev Pack the signature w/ EIP-712 flag
        $signature = abi.encodePacked(r, s, v, uint8($isSign ? 2 : 1));
    }

    function pack(
        bytes memory $signature,
        uint8 $weight,
        uint16 $threshold,
        uint32 $checkpoint
    )
        internal
        pure
        returns (bytes memory $packedSignature)
    {
        /// @dev Flag for legacy signature
        uint8 legacySignatureFlag = uint8(0);

        /// @dev Pack the signature w/ flag, weight, threshold, checkpoint
        $packedSignature = abi.encodePacked(
            $threshold, $checkpoint, legacySignatureFlag, $weight, $signature
        );
    }
}
