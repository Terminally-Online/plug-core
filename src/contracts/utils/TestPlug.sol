// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Vm } from "forge-std/Vm.sol";
import { ECDSA } from "solady/src/utils/ECDSA.sol";

import { TestPlus } from "./TestPlus.sol";

import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";

import { LibClone } from "solady/src/utils/LibClone.sol";

import { PlugFactory } from "../base/Plug.Factory.sol";
import { Plug } from "../base/Plug.sol";
import { PlugVaultSocket } from "../sockets/Plug.Vault.Socket.sol";
import { PlugMockEcho } from "../mocks/Plug.Mock.Echo.sol";

abstract contract TestPlug is TestPlus {
    Vm private constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    PlugFactory internal factory;
    Plug internal plug;
    PlugVaultSocket internal vaultImplementation;
    PlugVaultSocket internal vault;
    PlugMockEcho internal mock;

    address internal factoryOwner;
    string internal baseURI = "https://api.onplug.io/metadata/";

    address internal signer;
    uint256 internal signerPrivateKey = 0x12345;

    function setUpPlug() internal {
        factoryOwner = _randomNonZeroAddress();
        signer = vm.addr(signerPrivateKey);

        vaultImplementation = new PlugVaultSocket();

        plug = deployPlug();
        factory = deployFactory();
        vault = deployVault();

        mock = new PlugMockEcho();
    }

    function deployPlug() internal virtual returns (Plug $plug) {
        vm.etch(PlugEtcherLib.PLUG_ADDRESS, address(new Plug()).code);
        $plug = Plug(payable(PlugEtcherLib.PLUG_ADDRESS));
    }

    function deployFactory() internal virtual returns (PlugFactory $factory) {
        vm.etch(
            PlugEtcherLib.PLUG_FACTORY_ADDRESS, address(new PlugFactory()).code
        );
        $factory = PlugFactory(payable(PlugEtcherLib.PLUG_FACTORY_ADDRESS));
        $factory.initialize(factoryOwner, baseURI, address(vaultImplementation));
    }

    function deployVault() internal virtual returns (PlugVaultSocket $vault) {
        (, address vaultAddress) =
            factory.deploy(bytes32(abi.encodePacked(signer, uint96(0))));
        $vault = PlugVaultSocket(payable(vaultAddress));
    }

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
        bytes32 $hash,
        address $socket,
        uint256 $userKey,
        bool $isSign
    )
        internal
        view
        returns (bytes memory $signature)
    {
        // Create the subdigest
        bytes32 subdigest = keccak256(
            abi.encodePacked("\x19\x01", block.chainid, $socket, $hash)
        );

        /// @dev The actual hash that was signed w/ EIP-191 flag
        subdigest =
            $isSign ? ECDSA.toEthSignedMessageHash(subdigest) : subdigest;

        /// @dev Create the signature w/ the subdigest
        (uint8 v, bytes32 r, bytes32 s) = vm.sign($userKey, subdigest);

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
