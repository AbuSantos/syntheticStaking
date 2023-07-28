// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./IERC20.sol";

contract SyntheticStaking {
    IERC20 public rewardsToken;
    IERC20 public stakingToken;

    uint public rewardRate = 100;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;

    mapping(address => uint) public userRewardPerTokenPaid;
    mapping(address => uint) public reward;

    uint private _totalSupply;
    mapping(address => uint) private _balances;

    constructor(address _rewardsToken, address _stakingToken) {
        rewardsToken = IERC20(_rewardsToken);
        stakingToken = IERC20(_stakingToken);
    }

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        // accessing there rewards from each user as gotten from the earned fucntion
        reward[account] = earned(account);
        //then we updater the user rewardPerTokenpaid
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }

    function rewardPerToken() public view returns (uint) {
        if (_totalSupply == 0) return 0;
    //using the R(l(u,t)/l(t)), computes the running sum of R(rewards), rate of user staked at a time over the totalSupply
        return
            rewardPerTokenStored +
            ((rewardRate * (block.timestamp - lastUpdateTime) * 1e18) /
                _totalSupply);
    }

    function earned(address account) public view returns (uint) {}

    function stake(uint _amount) external updateReward(msg.sender) {
        _totalSupply += _amount;
        _balances[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _amount) external updateReward(msg.sender) {
        _totalSupply -= _amount;
        _balances[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function getReward() external updateReward(msg.sender) {
        uint rewards = reward[msg.sender];
        reward[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, rewards);
    }
}
