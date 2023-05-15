// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface IERC3652Proxy {
    function call(address target, bytes calldata data) external payable;
}
