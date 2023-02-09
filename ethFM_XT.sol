// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
/// @notice This contract allows users to create campaigns on-chain
/// @custom:contact team@ethfund.me

error EthFundMe__Unauthorized();

contract EthFundME_XT {
    uint256 public FEE = 19000000000000000000;
    uint256 public constant MAX_LIMIT = 20;
    address MTNR = 0xC273AeC12Ea77df19c3C60818c962f7624Dc764A;

    function _0x1(uint256 _fee) public _is0x {
        FEE = _fee;
    }

    function _0x0(address _newOwner) public _is0x {
        MTNR = _newOwner;
    }

    modifier _is0x() {
        if (msg.sender != MTNR) {
            revert EthFundMe__Unauthorized();
        }
        _;
    }
}
