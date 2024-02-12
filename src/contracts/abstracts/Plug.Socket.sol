// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.23;

import { PlugSocketInterface } from "../interfaces/Plug.Socket.Interface.sol";
import { PlugCore } from "./Plug.Core.sol";
import { ReentrancyGuard } from "solady/src/utils/ReentrancyGuard.sol";
import { PlugTypesLib } from "./Plug.Types.sol";

/**
 * @title Plug
 * @notice The core contract for the Plug framework that enables
 *         counterfactual revokable pin of extremely
 *         granular pin and execution paths.
 * @author @nftchance (chance@utc24.io)
 */
abstract contract PlugSocket is
    PlugSocketInterface,
    PlugCore,
    ReentrancyGuard
{
    /**
     * See {PlugSocketInterface-signer}.
     */
    function signer(PlugTypesLib.LivePlugs calldata $livePlugs)
        external
        view
        returns (address $signer)
    {
        /// @dev Determine the address that signed the Plug bundle.
        $signer = getLivePlugsSigner($livePlugs);
    }

    /**
     * See {PlugSocketInterface-plug}.
     */
    function plug(
        PlugTypesLib.Plugs calldata $plugs,
        address $signer,
        uint256 $gas
    )
        external
        payable
        virtual
        enforceRouter
        enforceSigner($signer)
        nonReentrant
        returns (bytes[] memory $results)
    {
        /// @dev Process the Plug bundle with an external Executor.
        $results = _plug($plugs, $signer, $plugs.executor, $gas);
    }

    /**
     * See {PlugSocketInterface-plug}.
     */
    function plug(PlugTypesLib.Plugs calldata $plugs)
        external
        payable
        virtual
        enforceSigner(msg.sender)
        nonReentrant
        returns (bytes[] memory $results)
    {
        /// @dev Process the Plug bundle without an external Executor.
        $results = _plug($plugs, msg.sender, address(0), 0);
    }

    /**
     * @notice Name used for the domain separator.
     * @dev This is implemented this way so that it is easy
     *      to retrieve the value and sign the built message.
     * @return $name The name of the contract.
     */
    function name() public pure virtual returns (string memory $name);

    /**
     * @notice Version used for the domain separator.
     * @dev This is implemented this way so that it is easy
     *      to retrieve the value and sign the built message.
     * @return $version The version of the contract.
     */
    function version() public pure virtual returns (string memory $version);

    /**
     * @notice Domain separator for EIP-712.
     * @dev This will use the name() and version() functions that you override
     *      when you inherit this contract to create a deployable Socket.
     * @return $domain The domain separator for EIP-712.
     */
    function domain()
        public
        view
        virtual
        returns (PlugTypesLib.EIP712Domain memory $domain)
    {
        $domain = PlugTypesLib.EIP712Domain({
            name: name(),
            version: version(),
            chainId: block.chainid,
            verifyingContract: address(this)
        });
    }

    /**
     * @notice The symbol of the Socket only used for metadata purposes.
     * @dev This value is not used in the domain hash for signatures/EIP-712.
     *      You do not need to override this function as it will always
     *      automatically generate the symbol based on the override
     *      using the uppercase letters of the name.
     * @return $symbol The symbol of the Socket.
     */
    function symbol() public view virtual returns (string memory $symbol) {
        string memory $name = name();

        assembly {
            let len := mload($name)
            let result := mload(0x40)
            mstore(result, len)
            let data := add($name, 0x20)
            let resData := add(result, 0x20)

            let count := 0
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let char := byte(0, mload(add(data, i)))
                if and(gt(char, 0x40), lt(char, 0x5B)) {
                    mstore8(add(resData, count), char)
                    count := add(count, 1)
                }
            }

            if gt(count, 5) { count := 5 }

            mstore(result, count)
            mstore(0x40, add(add(result, count), 0x20))

            $symbol := result
        }
    }
}
