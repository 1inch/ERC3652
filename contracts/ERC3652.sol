// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./interfaces/IERC3652Deployer.sol";
import "./ERC3652Proxy.sol";

contract ERC3652 is ERC721 {
    IERC3652Deployer immutable public deployer;
    bytes32 immutable public ERC3652_PROXY_CODE_HASH;  // solhint-disable-line var-name-mixedcase

    // solhint-disable-next-line no-empty-blocks
    constructor(string memory name_, string memory symbol_, IERC3652Deployer deployer_) ERC721(name_, symbol_) {
        deployer = deployer_;
        ERC3652_PROXY_CODE_HASH = deployer_.ERC3652_PROXY_CODE_HASH();
    }

    function addressOf(uint256 tokenId) external view returns(address) {
        bytes32 salt = keccak256(abi.encode(address(this), tokenId));
        return Create2.computeAddress(salt, ERC3652_PROXY_CODE_HASH, address(deployer));
    }

    function deploy(uint256 tokenId) external returns(address) {
        return deployer.deploy(address(this), tokenId);
    }

    function _mint(address to, uint256 tokenId) internal override {
        deployer.deploy(address(this), tokenId);
        super._mint(to, tokenId);
    }
}
