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

    function decodeSalt(
        bytes calldata $salt
    )
        external
        pure
        returns (address $admin, address $implementation)
    {
        $admin = address(uint160(uint256(bytes32($salt[:0x14]) >> 96)));
        $implementation = address(uint160(uint256(bytes32($salt[0x14:]) >> 96)));
    }

    function test_salt() public {
        bytes memory packed = abi.encodePacked(address(1), address(socketImplementation));
        (address admin, address implementation) = this.decodeSalt(packed);
        assert(admin == address(1));
        assert(implementation == address(socketImplementation));
    }

    function test_DeployDeterministic(uint256) public {
        vm.deal(address(this), 1000 ether);
        uint256 initialValue = _random() % 100 ether;
        bytes memory salt = abi.encodePacked(address(1), address(socketImplementation));
        (, address vault) = factory.deploy{ value: initialValue }(salt);
        assertEq(address(vault).balance, initialValue);
        (bool alreadyDeployed,) = factory.deploy{ value: initialValue }(salt);
        assertTrue(alreadyDeployed);
    }
}
