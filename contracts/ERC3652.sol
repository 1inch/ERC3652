// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./ERC3652Proxy.sol";

contract ERC3652 is ERC721 {
    // solhint-disable-next-line no-empty-blocks
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    }

    function addressOf(uint256 tokenId) external view returns(address) {
        return Create2.computeAddress(
            bytes32(tokenId),
            keccak256(abi.encodePacked(type(ERC3652Proxy).creationCode, tokenId))
        );
    }

    function _mint(address to, uint256 tokenId) internal override {
        new ERC3652Proxy{salt: bytes32(tokenId)}(tokenId);
        super._mint(to, tokenId);
    }
}
