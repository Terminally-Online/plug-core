// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {
    Test,
    PlugEtcherLib,
    LibClone,
    PlugFactory,
    PlugVaultSocket
} from "../abstracts/test/Plug.Test.sol";

contract PlugFactoryTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    function setUp() public virtual {
        setUpPlug();
    }

    function test_DeployDeterministic(uint256) public {
        vm.deal(address(this), 1000 ether);
        uint256 initialValue = _random() % 100 ether;
        bytes32 salt = bytes32(abi.encodePacked(address(1), uint96(0)));

        (, address vault) = factory.deploy{ value: initialValue }(salt);
        assertEq(address(vault).balance, initialValue);
        (bool alreadyDeployed,) = factory.deploy{ value: initialValue }(salt);
        assertTrue(alreadyDeployed);
    }
}
