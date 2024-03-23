// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { ERC1155 } from "solady/src/tokens/ERC1155.sol";

contract PlugMockERC1155 is ERC1155 {
    string[] public uris;

    function initializeToken(string memory $uri) public {
        /// @dev Initialize the token.
        uris.push($uri);
    }

    function mint(
        address $to,
        uint256 $tokenId,
        uint256 $amount,
        bytes memory $data
    )
        public
    {
        /// @dev Make sure the token exists.
        require(
            $tokenId < uris.length, "MockERC1155: invalid token id"
        );

        /// @dev Mint the token.
        _mint($to, $tokenId, $amount, $data);
    }

    function uri(uint256 $tokenId)
        public
        view
        override
        returns (string memory)
    {
        /// @dev Make sure the token exists.
        require(
            $tokenId < uris.length, "MockERC1155: invalid token id"
        );

        /// @dev Return the token URI.
        return uris[$tokenId];
    }
}
