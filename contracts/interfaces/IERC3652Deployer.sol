// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;

interface IERC3652Deployer {
    function ERC3652_PROXY_CODE_HASH() external view returns(bytes32);  // solhint-disable-line func-name-mixedcase
    function parameters() external view returns(address, uint256);
    function addressOf(address token, uint256 tokenId) external view returns(address);
    function deploy(address token, uint256 tokenId) external returns(address proxy);
}
