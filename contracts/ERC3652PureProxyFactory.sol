// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/utils/Create2.sol";

import "./ERC3652PureProxy.sol";


contract ERC3652PureProxyFactory {
    bytes32 immutable public pureProxyCodeHash;
    bytes public targetPlusData;

    constructor() {
        pureProxyCodeHash = keccak256(type(ERC3652PureProxy).creationCode);
    }

    function _pureProxyAddressOf(bytes32 salt) internal view returns(address) {
        return Create2.computeAddress(salt, pureProxyCodeHash);
    }

    function _pureProxyDelegateCall(bytes32 salt, address target, bytes calldata data) internal returns(bool) {
        targetPlusData = abi.encodePacked(target, data);
        try new ERC3652PureProxy{ salt: salt, value: msg.value }() returns (ERC3652PureProxy) {
            delete targetPlusData;
            return true;
        } catch (bytes memory) {
            delete targetPlusData;
            return false;
        }
    }
}
