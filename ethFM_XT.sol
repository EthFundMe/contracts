// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
/// @notice This contract allows users to create campaigns on-chain
/// @custom:contact team@ethfund.me

error EthFundMe__Unauthorized();

contract EthFundME_XT {
    uint256 public FEE = 19000000000000000000;
    uint256 public constant MAX_LIMIT = 20;
    address private MTNR_0 = 0xC273AeC12Ea77df19c3C60818c962f7624Dc764A;
    address private MTNR_1 = 0xee9718Df51B678653750B0Ae7AB57E9576E56D8b;
    address private MTNR_2 = 0xB11A8eb867df90F09aDbeb4F550e1f8f66F1c5f2;
    address public PLTF_WT = 0xC273AeC12Ea77df19c3C60818c962f7624Dc764A;

    function _0x1(uint256 _fee) public _is0x {
        FEE = _fee;
    }

    function _0x0(uint256 _slot, address _newOwner) public _is0 {
        if (_slot == 0) {
            MTNR_0 = _newOwner;
        } else if (_slot == 1) {
            MTNR_1 = _newOwner;
        } else if (_slot == 2) {
            MTNR_2 = _newOwner;
        }
    }

    modifier _is0x() {
        if (
            msg.sender != MTNR_0 || msg.sender != MTNR_1 || msg.sender != MTNR_2
        ) {
            revert EthFundMe__Unauthorized();
        }
        _;
    }

    modifier _is0() {
        if (msg.sender != MTNR_0) {
            revert EthFundMe__Unauthorized();
        }
        _;
    }
}
