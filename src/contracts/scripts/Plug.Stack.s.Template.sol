/// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import { Script } from "forge-std/Script.sol";
import { console2 } from "forge-std/console2.sol";

import { Plug } from "../base/Plug.sol";

import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";

/**
 * @title Plug Stack Deployment
 * @dev Deploy all the key Plug primitives to a new chain using the immutable
 *      Create2 factory for constant addresses across all major EVM chains.
 * @notice To deploy the most up to date version of Plug, you can always just run
 *         this script and everything will be deployed as configured. If you need
 *         a specific piece, do not edit or run this script and instead utilize one
 *         of the 'Piece' deployment scripts for singular deployment.
 */
contract PlugStackDeployment is Script {
    function run() external {
        vm.startBroadcast();

        /// @auto INSERT SEGMENTS
        //       PlugEtcherLib.factory.safeCreate2(
        //           0x00000000000000000000000000000000000000002bbc593dd77cb93fbb932d5f,
        // 	type(Plug).creationCode
        // );

        vm.stopBroadcast();
    }
}
