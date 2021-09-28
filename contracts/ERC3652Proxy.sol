// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/IERC3652Deployer.sol";


contract ERC3652Proxy {
    address immutable public token;
    uint256 immutable public tokenId;

    constructor() {
        (token, tokenId) = IERC3652Deployer(msg.sender).parameters();
    }

    function owner() public view returns(address) {
        return IERC721(token).ownerOf(tokenId);
    }

    function execute(address target, bytes calldata data) external payable returns(bool, bytes memory) {
        require(msg.sender == owner(), "ERC3652: access denied");

        // solhint-disable-next-line avoid-low-level-calls
        return target.delegatecall(data);
    }
}
