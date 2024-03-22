// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Test } from "../utils/Test.sol";
import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";

import { PlugFactory } from "./Plug.Factory.sol";
import { PlugVaultSocket } from "../sockets/Plug.Vault.Socket.sol";

import { LibClone } from "solady/src/utils/LibClone.sol";

contract PlugFactoryTest is Test {
    PlugFactory internal factory;

    address factoryOwner;
    string baseURI = "https://onplug.io/metadata/";

    function setUp() public virtual {
        factoryOwner = _randomNonZeroAddress();
        factory = deployFactory();
    }

    function deployFactory() internal returns (PlugFactory $factory) {
        vm.etch(
            PlugEtcherLib.PLUG_FACTORY_ADDRESS, address(new PlugFactory()).code
        );
        $factory = PlugFactory(payable(PlugEtcherLib.PLUG_FACTORY_ADDRESS));
        $factory.initialize(
            factoryOwner, baseURI, address(new PlugVaultSocket())
        );
    }

    function test_DeployDeterministic(uint256) public {
        vm.deal(address(this), 100 ether);
        address owner = _randomNonZeroAddress();
        uint256 initialValue = _random() % 100 ether;

        bytes32 salt =
            bytes32(abi.encodePacked(owner, uint80(_random()), uint16(0)));

        // TODO: Check for the token event emission.

        (, address vault) = factory.deploy{ value: initialValue }(salt);

        // TODO: Check for repeated deployment calls to make sure that we don't double deploy.

        assertEq(address(vault).balance, initialValue);
    }
}
