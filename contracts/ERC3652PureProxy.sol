// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "hardhat/console.sol";


contract ERC3652PureProxy {
    constructor() payable {
        assembly { // solhint-disable-line no-inline-assembly
            mstore(0, 0xc438959200000000000000000000000000000000000000000000000000000000)
            if staticcall(gas(), caller(), 0, 4, 0, 0) {
                returndatacopy(0x80, 0, returndatasize())
                if delegatecall(gas(), shr(96, mload(212)), 232, sub(returndatasize(), 104), 0, 0) {
                    selfdestruct(shr(96, mload(192)))
                }
            }
            revert(0, 0)
        }
    }
}
