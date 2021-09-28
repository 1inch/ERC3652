// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "../../contracts/ERC3652Token.sol";


contract ERC3652Mock is ERC3652Token {
    // solhint-disable-next-line no-empty-blocks
    constructor(string memory name_, string memory symbol_) ERC3652Token(name_, symbol_) {
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}
