// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ERC3652Proxy {
    error AccessDenied();

    IERC721 public immutable token;
    uint256 public immutable tokenId;

    constructor(IERC721 token_, uint256 tokenId_) payable {
        token = token_;
        tokenId = tokenId_;
    }

    function call(address target, uint256 value, bytes calldata cd) external returns(bool success, bytes memory ret) {
        if (token.ownerOf(tokenId) != msg.sender) revert AccessDenied();
        (success, ret) = target.call{ value: value }(cd);
    }
}
