// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./interfaces/IERC3652Deployer.sol";
import "./ERC3652Proxy.sol";


contract ERC3652Deployer is IERC3652Deployer {
    struct Parameters {
        address token;
        uint256 tokenId;
    }

    bytes32 constant public override ERC3652_PROXY_CODE_HASH = keccak256(type(ERC3652Proxy).creationCode);

    Parameters public override parameters;

    function addressOf(address token, uint256 tokenId) external view override returns(address) {
        bytes32 salt = keccak256(abi.encode(token, tokenId));
        return Create2.computeAddress(salt, ERC3652_PROXY_CODE_HASH);
    }

    function deploy(address token, uint256 tokenId) external override returns(address proxy) {
        parameters = Parameters({
            token: token,
            tokenId: tokenId
        });

        bytes32 salt = keccak256(abi.encode(token, tokenId));
        proxy = address(new ERC3652Proxy{salt: salt}());

        delete parameters;
    }
}
