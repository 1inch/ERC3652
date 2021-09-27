// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract ERC3652PureProxy {
    constructor() payable {
        assembly { // solhint-disable-line no-inline-assembly
            mstore(0, 0xc438959200000000000000000000000000000000000000000000000000000000)
            if staticcall(gas(), caller(), 0, 4, 0, 0) {
                calldatacopy(0, 0, calldatasize())
                if delegatecall(gas(), shr(96, mload(52)), 72, sub(mload(0), 40), 0, 0) {
                    selfdestruct(shr(96, mload(32)))
                }
            }
            revert(0, 0)
        }
    }
}
