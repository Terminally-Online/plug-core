// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Test, PlugEtcherLib, LibClone } from "../utils/Test.sol";

import { PlugFactory } from "./Plug.Factory.sol";
import { PlugVaultSocket } from "../sockets/Plug.Vault.Socket.sol";

contract PlugFactoryTest is Test {
    function setUp() public virtual {
        setUpPlug();
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

    function test_Deploy_AlreadyDeployed() public { }
}
