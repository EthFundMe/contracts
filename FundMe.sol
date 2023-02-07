// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;
/// @notice This contract allows users to create campaigns on-chain
/// @custom:contact team@ethfund.me

error EthFundMe__Unauthorized();

contract FundMe {
    uint256 public FEE = 19000000000000000000;
    address MTNR = 0xC273AeC12Ea77df19c3C60818c962f7624Dc764A;

    function setFEE(uint256 _fee) public isOwner {
        FEE = _fee;
    }

    modifier isOwner() {
        if (msg.sender != MTNR) {
            revert EthFundMe__Unauthorized();
        }
        _;
    }
}
