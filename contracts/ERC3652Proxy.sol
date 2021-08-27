// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract ERC3652Proxy {
    IERC721 immutable public token;
    uint256 immutable public tokenId;

    modifier onlyOwner {
        require(msg.sender == owner(), "ERC3652: access denied");
        _;
    }

    constructor(uint256 tokenId_) {
        token = IERC721(msg.sender);
        tokenId = tokenId_;
    }

    function owner() public view returns(address) {
        return token.ownerOf(tokenId);
    }

    function execute(address target, uint256 value, bytes calldata data) external payable onlyOwner returns(bool, bytes memory) {
        return target.call{ value: value }(data);
    }
}
