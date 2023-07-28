// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./IERC20.sol";

contract SyntheticStaking {
    IERC20 public rewardToken;
    IERC20 public stakingToken;

    uint public rewardRate = 100;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;

    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address =>uint) public reward;
    constructor() {}
}
