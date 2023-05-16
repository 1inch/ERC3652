// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";

import { ERC3652Lib } from "./ERC3652Lib.sol";

contract ERC3652 {
    function addressOf(address token, uint256 tokenId) public view returns(address) {
        return Create2.computeAddress(0, keccak256(createProxyCode(token, tokenId)));
    }

    function deploy(address token, uint256 tokenId) public returns(address) {
        return Create2.deploy(0, 0, createProxyCode(token, tokenId));
    }

    function createProxyCode(address token, uint256 tokenId) public pure returns(bytes memory) {
        return ERC3652Lib.createProxyCode(token, tokenId);
    }

    function getProxyToken(address proxy) public view returns(address token) {
        (token,) = ERC3652Lib.getTokenAndId(proxy);
    }

    function getProxyTokenId(address proxy) public view returns(uint256 tokenId) {
        (,tokenId) = ERC3652Lib.getTokenAndId(proxy);
    }

    function getProxyTokenAndId(address proxy) public view returns(address token, uint256 tokenId) {
        (token, tokenId) = ERC3652Lib.getTokenAndId(proxy);
    }
}
