// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Test } from "../utils/Test.sol";

import { PlugTypes, PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { PlugFactory } from "../base/Plug.Factory.sol";
import { PlugMockEcho } from "./Plug.Mock.Echo.sol";

import { PlugEtcherLib } from "../libraries/Plug.Etcher.Lib.sol";

import "forge-std/console.sol";

contract PlugMockSocketTest is Test {
    PlugMockEcho internal mock;

    // address internal signer;
    // uint256 internal signerPrivateKey;

    // uint8 internal v;
    // bytes32 internal r;
    // bytes32 internal s;
    // bytes32 internal digest;

    function setUp() public virtual {
        // signerPrivateKey = 0xabc123;
        // signer = vm.addr(signerPrivateKey);

        // router = PlugEtcher.routerSocket();
        // router = etchRouterSocket();
        mock = new PlugMockEcho();
    }

    // function etchRouterSocket() internal returns (Plug) {
    //     vm.etch(PlugEtcherLib.ROUTER_SOCKET_ADDRESS, address(new Plug()).code);
    //     return Plug(payable(PlugEtcherLib.ROUTER_SOCKET_ADDRESS));
    // }

    function test_Echo() public {
        string memory expected = "Hello World";
        vm.expectEmit(address(mock));
        emit PlugMockEcho.EchoInvoked(address(this), expected);
        mock.echo(expected);
    }

    function test_EmptyEcho() public {
        vm.expectEmit(address(mock));
        emit PlugMockEcho.EchoInvoked(address(this), "Hello World");
        mock.emptyEcho();
    }

    function test_MutedEcho(uint256 $echo) public view {
        mock.mutedEcho($echo);
    }

    // function test_GetLivePlugsSigner() public {
    //     /// @dev Encode the transaction that is going to be called.
    //     bytes memory encodedTransaction =
    //         abi.encodeWithSelector(mock.mutedEcho.selector);
    //     PlugTypesLib.Current memory current = PlugTypesLib.Current({
    //         target: address(mock),
    //         value: 0,
    //         data: encodedTransaction
    //     });
    //
    //     /// @dev Bundle the Plug and sign it.
    //     PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
    //     plugsArray[0] = PlugTypesLib.Plug({
    //         current: current,
    //         fuses: new PlugTypesLib.Fuse[](0)
    //     });
    //
    //     PlugTypesLib.Plugs memory plugs = PlugTypesLib.Plugs({
    //         socket: address(mock),
    //         plugs: plugsArray,
    //         salt: bytes32(0),
    //         fee: 0,
    //         maxFeePerGas: 0,
    //         maxPriorityFeePerGas: 0,
    //         executor: address(0)
    //     });
    //
    //     digest = mock.getPlugsDigest(plugs);
    //     (v, r, s) = vm.sign(signerPrivateKey, digest);
    //     bytes memory plugsSignature = abi.encodePacked(r, s, v);
    //
    //     PlugTypesLib.LivePlugs memory livePlugs =
    //         PlugTypesLib.LivePlugs({ plugs: plugs, signature: plugsSignature });
    //
    //     address plugsSigner = router.getLivePlugsSigner(livePlugs);
    //     assertEq(plugsSigner, signer);
    // }
    //
    // function test_PlugEmptyEcho_SignerExecutor() public {
    //     /// @dev Encode the transaction that is going to be called.
    //     bytes memory encodedTransaction =
    //         abi.encodeWithSelector(mock.emptyEcho.selector);
    //     PlugTypesLib.Current memory current = PlugTypesLib.Current({
    //         ground: address(mock),
    //         voltage: 0,
    //         data: encodedTransaction
    //     });
    //
    //     /// @dev There are no conditions in this plug meaning a user is executing their own intent.
    //     PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
    //     plugsArray[0] = PlugTypesLib.Plug({
    //         current: current,
    //         fuses: new PlugTypesLib.Fuse[](0)
    //     });
    //
    //     /// @dev Make sure this transaction cannot be replayed.
    //     PlugTypesLib.Plugs memory plugs =
    //         PlugTypesLib.Plugs({ plugs: plugsArray, salt: bytes32(0) });
    //
    //     /// @dev Sign the execution.
    //     digest = router.getPlugsDigest(plugs);
    //     (v, r, s) = vm.sign(signerPrivateKey, digest);
    //     bytes memory plugsSignature = abi.encodePacked(r, s, v);
    //     PlugTypesLib.LivePlugs memory livePlugs =
    //         PlugTypesLib.LivePlugs({ plugs: plugs, signature: plugsSignature });
    //     address plugsSigner = router.getLivePlugsSigner(livePlugs);
    //     assertEq(plugsSigner, signer);
    //
    //     /// @dev Execute the plug.
    //     router.plug(livePlugs);
    // }
    //
    // function test_PlugEmptyEcho_ExternalExecutor() public {
    //     /// @dev Encode the transaction that is going to be called.
    //     bytes memory encodedTransaction =
    //         abi.encodeWithSelector(mock.emptyEcho.selector);
    //     PlugTypesLib.Current memory current = PlugTypesLib.Current({
    //         ground: address(mock),
    //         voltage: 0,
    //         data: encodedTransaction
    //     });
    //
    //     /// @dev There are no conditions in this plug meaning an executor can do anything.
    //     PlugTypesLib.Plug memory Plug = PlugTypesLib.Plug({
    //         current: current,
    //         fuses: new PlugTypesLib.Fuse[](0)
    //     });
    //     PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
    //     plugsArray[0] = Plug;
    //
    //     /// @dev Make sure this transaction cannot be replayed.
    //     PlugTypesLib.Plugs memory plugs =
    //         PlugTypesLib.Plugs({ plugs: plugsArray, salt: bytes32(0) });
    //
    //     /// @dev Sign the execution.
    //     digest = router.getPlugsDigest(plugs);
    //     (v, r, s) = vm.sign(signerPrivateKey, digest);
    //     bytes memory plugsSignature = abi.encodePacked(r, s, v);
    //     PlugTypesLib.LivePlugs memory livePlugs =
    //         PlugTypesLib.LivePlugs({ plugs: plugs, signature: plugsSignature });
    //     address plugsSigner = router.getLivePlugsSigner(livePlugs);
    //     assertEq(plugsSigner, signer);
    //
    //     /// @dev Execute the plug.
    //     vm.expectEmit(address(mock));
    //     emit PlugMockEcho.EchoInvoked(address(router), signer, "Hello World");
    //     console.logAddress(signer);
    //
    //     hoax(_randomNonZeroAddress());
    //     router.plug(livePlugs);
    // }
    //
    // function testFail_PlugMutedEcho() public {
    //     /// @dev Encode the transaction that is going to be called.
    //     bytes memory encodedTransaction =
    //         abi.encodeWithSelector(mock.mutedEcho.selector);
    //     PlugTypesLib.Current memory current = PlugTypesLib.Current({
    //         ground: address(mock),
    //         voltage: 0,
    //         data: encodedTransaction
    //     });
    //
    //     /// @dev There are no conditions in this plug meaning a user is executing their own intent.
    //     PlugTypesLib.Plug memory Plug = PlugTypesLib.Plug({
    //         current: current,
    //         fuses: new PlugTypesLib.Fuse[](0)
    //     });
    //     PlugTypesLib.Plug[] memory plugsArray = new PlugTypesLib.Plug[](1);
    //     plugsArray[0] = Plug;
    //
    //     /// @dev Make sure this transaction cannot be replayed.
    //     PlugTypesLib.Plugs memory plugs =
    //         PlugTypesLib.Plugs({ plugs: plugsArray, salt: bytes32(0) });
    //
    //     /// @dev Sign the execution.
    //     digest = router.getPlugsDigest(plugs);
    //     (v, r, s) = vm.sign(signerPrivateKey, digest);
    //     bytes memory plugsSignature = abi.encodePacked(r, s, v);
    //     PlugTypesLib.LivePlugs memory livePlugs =
    //         PlugTypesLib.LivePlugs({ plugs: plugs, signature: plugsSignature });
    //     address plugsSigner = router.getLivePlugsSigner(livePlugs);
    //     assertEq(plugsSigner, signer);
    //
    //     /// @dev Execute the plug.
    //     router.plug(livePlugs);
    // }
}
