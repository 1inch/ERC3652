// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Create2.sol";

library ERC3652Lib {
    uint256 public constant ADDRESS_MASK = (1 << 160) - 1;
    uint256 public constant PROXY_CODE_TOKEN_ADDRESS_BYTE_OFFSET = 77;
    uint256 public constant PROXY_CODE_TOKEN_ID_BYTE_OFFSET = 47;

    bytes public constant PROXY_CODE =
        // Universal constructor (11 bytes length)
        // codecopy(0, 0, codesize())
        hex"38"    // codesize
        hex"5f"    // push0
        hex"5f"    // push0
        hex"39"    // codecopy
        // return(13, sub(codesize(), 13))
        hex"60_0b" // push1 13
        hex"38"    // codesize
        hex"03"    // sub
        hex"60_0b" // push1 13
        hex"f3"    // return

        // Proxy code
        // mstore(0, IERC721.ownerOf.selector)
        hex"7f_6352211e00000000000000000000000000000000000000000000000000000000" // push4 0x6352211e
        hex"5f"    // push0
        hex"52"    // mstore
        // mstore(4, tokenId)
        hex"7f_0000000000000000000000000000000000000000000000000000000000000000" // push32 tokenId
        hex"60_04" // push1 4
        hex"52"    // mstore
        // staticcall(gas(), token, 0, 0x24, 0, 0x20)
        hex"60_20" // push1 0x20
        hex"5f"    // push0
        hex"60_24" // push1 0x24
        hex"5f"    // push0
        hex"73_0000000000000000000000000000000000000000" // push20 token
        hex"5a"    // gas
        hex"fa"    // staticcall
        hex"50"    // pop
        // if not(eq(caller(), mload(0))) revert(0,0)
        hex"5f"    // push0
        hex"51"    // mload
        hex"33"    // caller
        hex"14"    // eq
        hex"60_6f" // push1 0x6f
        hex"57"    // jumpi
        hex"5f"    // push0
        hex"5f"    // push0
        hex"fd"    // revert
        // calldatacopy(0, data.offset, data.length)
        hex"5b"     // jumpdest
        hex"60_24"  // push1 0x24   // 0x24
        hex"35"     // calldataload // 0x40
        hex"80"     // dup1         // 0x40 0x40
        hex"60_04"  // push1 0x04   // 0x4 0x40 0x40
        hex"01"     // add          // 0x44 0x40
        hex"35"     // calldataload // len 0x40
        hex"80"     // dup1         // len len 0x40
        hex"91"     // swap2        // 0x40 len len
        hex"60_24"  // push1 0x24   // 0x24 0x40 len len
        hex"01"     // add          // 0x64 len len
        hex"5f"     // push0        // 0 0x64 len len
        hex"37"     // calldatacopy // len
        // delegatecall(gas(), target, data.offset, data.length, 0, 0)
        hex"5f"     // push0        // 0 len
        hex"5f"     // push0        // 0 0 len
        hex"91"     // swap2        // len 0 0
        hex"5f"     // push0        // 0 len 0 0
        hex"60_04"  // push1 4      // 4 0 len 0 0
        hex"35"     // calldataload // target 0 len 0 0
        hex"5a"     // gas          // gas target 0 len 0 0
        hex"f4"     // delegatecall
        // returndatacopy(0, rds(), rds())
        hex"3d"     // returndatasize   // rds success
        hex"3d"     // returndatasize   // rds rds success
        hex"5f"     // push0            // 0 rds rds success
        hex"3e"     // returndatacopy   // success
        hex"5f"     // push0            // 0 success
        hex"3d"     // returndatasize   // rds 0 success
        hex"91"     // swap2            // success 0 rds
        hex"60_93"  // push1 0x8b       // 0x8b success 0 rds
        hex"57"     // jumpi            // 0 rds
        hex"fd"     // revert
        hex"5b"     // jumpdest
        hex"f3"     // return
        ;

    function createProxyCode(address token, uint256 tokenId) internal pure returns(bytes memory code) {
        code = PROXY_CODE;
        assembly ("memory-safe") {
            let codePtr := add(code, 0x20)
            let tokenPtr := add(codePtr, PROXY_CODE_TOKEN_ADDRESS_BYTE_OFFSET)
            mstore(tokenPtr, or(mload(tokenPtr), token))
            mstore(add(codePtr, PROXY_CODE_TOKEN_ID_BYTE_OFFSET), tokenId)
        }
    }

    function getTokenAndId(bytes memory code) internal pure returns(address token, uint256 tokenId) {
        assembly {
            let ptr := add(code, 0x20)
            token := and(mload(add(ptr, PROXY_CODE_TOKEN_ADDRESS_BYTE_OFFSET)), ADDRESS_MASK)
            tokenId := mload(add(ptr, PROXY_CODE_TOKEN_ID_BYTE_OFFSET))
        }
    }

    function getTokenAndId(address proxy) internal view returns(address token, uint256 tokenId) {
        return getTokenAndId(proxy.code);
    }
}
