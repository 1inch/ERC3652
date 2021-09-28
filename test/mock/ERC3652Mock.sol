// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

import "../../contracts/ERC3652.sol";
import "../../contracts/interfaces/IERC3652Deployer.sol";

contract ERC3652Mock is ERC3652 {
    constructor(string memory name_, string memory symbol_, IERC3652Deployer deployer_) ERC3652(name_, symbol_, deployer_) {
    }

    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }
}
