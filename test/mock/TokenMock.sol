// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenMock is ERC20 {
    // solhint-disable-next-line no-empty-blocks
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
