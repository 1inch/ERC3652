// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Create2.sol";

import "./ERC3652PureProxy.sol";


contract ERC3652PureProxyFactory {
    bytes32 immutable public pureProxyCodeHash;
    bytes public ownerPlusTargetPlusData;

    constructor() {
        pureProxyCodeHash = keccak256(type(ERC3652PureProxy).creationCode);
    }

    function _pureProxyAddressOf(bytes32 salt) internal view returns(address) {
        return Create2.computeAddress(salt, pureProxyCodeHash);
    }

    function _pureProxyDelegateCall(bytes32 salt, address owner, address target, uint256 value, bytes calldata data) internal returns(bool) {
        ownerPlusTargetPlusData = abi.encodePacked(owner, target, data);
        try new ERC3652PureProxy{ salt: salt, value: value }() returns (ERC3652PureProxy) {
            delete ownerPlusTargetPlusData;
            return true;
        } catch (bytes memory) {
            delete ownerPlusTargetPlusData;
            return false;
        }
    }
}
