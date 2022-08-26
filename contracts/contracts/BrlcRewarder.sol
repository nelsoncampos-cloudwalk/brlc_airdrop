// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BrlcRewarder is Ownable {
    address[] winners;

    IERC20 brlc = IERC20(address(0xC6d1eFd908ef6B69dA0749600F553923C465c812));

    function getRewarderWallet() public view returns(address) {
        return address(this);
    }

    function getRewarderBalance() public view returns (uint) {
        return brlc.balanceOf(address(this));
    }

    function getWinners() public view returns(address[] memory) {
        return winners;
    }

    function reward(address reciver) public onlyNewAddress(reciver) hasBalance {
        uint amount = 4.20 * 10 ** 6;
        brlc.approve(address(this), getRewarderBalance());
        brlc.transferFrom(address(this), reciver, amount);
        winners.push(reciver);
        emit Airdrop(reciver);
    }


    modifier hasBalance {
        uint balance = getRewarderBalance();
        require(balance > 0, "Rewarder doesn't has more balance");
        _;
    }
 

    modifier onlyNewAddress(address reciver) {
        for(uint i = 0; i < winners.length; i++) {
            require(winners[i] != reciver, "You alredy get the reward");
        }
        _;
    }

    event Airdrop(address);
}
