// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./ERC3652PureProxyFactory.sol";


contract ERC3652Factory is ERC3652PureProxyFactory {
    function addressOf(IERC721 token, uint256 tokenId) external view returns(address) {
        return _pureProxyAddressOf(keccak256(abi.encode(token, tokenId)));
    }

    function callFor(IERC721 token, uint256 tokenId, address target, bytes calldata data) external payable {
        require(msg.sender == token.ownerOf(tokenId), "ERC3652: access denied");
        require(
            _pureProxyDelegateCall(bytes32(tokenId), msg.sender, target, msg.value, data),
            "ERC3652: call failed"
        );
    }
}
