// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./ERC3652PureProxyFactory.sol";


contract ERC3652Token is ERC721, ERC3652PureProxyFactory {
    // solhint-disable-next-line no-empty-blocks
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    }

    function addressOf(uint256 tokenId) external view returns(address) {
        return _pureProxyAddressOf(bytes32(tokenId));
    }

    function callFor(uint256 tokenId, address target, bytes calldata data) external payable {
        require(msg.sender == ownerOf(tokenId), "ERC3652: access denied");
        require(
            _pureProxyDelegateCall(bytes32(tokenId), msg.sender, target, msg.value, data),
            "ERC3652: call failed"
        );
    }
}
