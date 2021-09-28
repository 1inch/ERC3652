// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;


contract ERC3652PureProxy {
    constructor() payable {
        assembly { // solhint-disable-line no-inline-assembly
            mstore(0, 0x46696ade00000000000000000000000000000000000000000000000000000000)
            if staticcall(gas(), caller(), 0, 4, 0, 0) {
                returndatacopy(0x80, 0, returndatasize())
                if delegatecall(gas(), shr(96, mload(192)), 212, sub(returndatasize(), 84), 0, 0) {
                    return(0,0)
                }
            }
            revert(0, 0)
        }
    }
}
