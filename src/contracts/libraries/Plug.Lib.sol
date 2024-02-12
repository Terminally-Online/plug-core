// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

library PlugLib {
    address internal constant ROUTER_ADDRESS = 0x00b09C89Ace100AB7A4Dc47ebfBd1E7997920062;

    event SocketDeployed(
        address indexed implementation, address indexed vault, bytes32 salt
    );

    function isRouter(address _address) internal pure returns (bool) {
        return _address == ROUTER_ADDRESS;
    }
}
