// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { IERC20, SafeERC20 } from "@1inch/solidity-utils/contracts/libraries/SafeERC20.sol";

contract TokenTransferDelegatee {
    using SafeERC20 for IERC20;

    function tokenTransfer(IERC20 token, address to, uint256 amount) external {
        token.safeTransfer(to, amount);
    }
}
