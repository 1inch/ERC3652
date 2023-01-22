// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMock is ERC721 {
    // solhint-disable-next-line no-empty-blocks
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}
