// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./ERC3652Proxy.sol";

contract ERC3652Factory {
    function addressOf(IERC721 token, uint256 tokenId) public view returns(address) {
        bytes32 codeHash = keccak256(abi.encodePacked(
            type(ERC3652Proxy).creationCode,
            abi.encode(token, tokenId)
        ));
        return Create2.computeAddress(0, codeHash);
    }

    function deploy(IERC721 token, uint256 tokenId) public returns(ERC3652Proxy) {
        return new ERC3652Proxy{ salt: 0 }(token, tokenId);
    }
}
