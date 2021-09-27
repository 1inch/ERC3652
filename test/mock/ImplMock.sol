// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract ImplMock {
    using SafeERC20 for IERC20;

    function transferToken(IERC20 token, address to, uint256 amount) external {
        token.safeTransfer(to, amount);
    }
}
