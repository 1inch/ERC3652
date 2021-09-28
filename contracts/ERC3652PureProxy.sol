// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract ERC3652PureProxy {
    constructor() payable {
        assembly { // solhint-disable-line no-inline-assembly
            mstore(0, 0xc438959200000000000000000000000000000000000000000000000000000000)
            if staticcall(gas(), caller(), 0, 4, 0, 0) {
                returndatacopy(0, 0, returndatasize())
                if delegatecall(gas(), shr(96, mload(20)), 40, sub(returndatasize(), 40), 0, 0) {
                    selfdestruct(shr(96, mload(0)))
                }
            }
            revert(0, 0)
        }
    }
}
