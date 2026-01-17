// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {StableToken} from "./StableToken.sol";

contract RaffileEngine {
    error RaffileEngine__EthAmountCantBeZero();
    error RaffileEngine__FailedToBuyToken();
    error RaffileEngine__RaffileTokenBalanceIsZero();
    error RaffileEngine__InsufficientBalance();
  error RaffileEngine__FailedToSellToken();
  error RaffileEngine__BuyRaffleTokenToJoin();
  error RaffileEngine__InsufficientBalanceToJoin();

    event userBuyToken(address indexed user, uint256 indexed amount);
    event userSellToken(address indexed user, uint256 indexed amount);

    StableToken public immutable stableToken;
    uint256  immutable rafileTikenPrice;
    address[] raffile_Players;

    constructor(address _stableTokenAddress,uint256 _rafileTikenPrice) {
        stableToken = StableToken(_stableTokenAddress);
        rafileTikenPrice = _rafileTikenPrice;
    }

    function buyRaffileToken() external payable {
        if (msg.value == 0) {
            revert RaffileEngine__EthAmountCantBeZero();
        }
        bool success = stableToken.buyToken{value: msg.value}(msg.sender);
        emit userBuyToken(msg.sender, msg.value);


        if (!success) {
            revert RaffileEngine__FailedToBuyToken();
        }
    }

    function sellRaffileToken(uint256 value) external {
        uint256 userTokenBalance = stableToken.balanceOf(msg.sender);
        if (userTokenBalance == 0) {
            revert RaffileEngine__RaffileTokenBalanceIsZero();
        }
        if (userTokenBalance < value) {
            revert RaffileEngine__InsufficientBalance();
        }
        stableToken.transferFrom(msg.sender, address(this), value);
        emit userSellToken(msg.sender, value);

       bool success = stableToken.sellToken(msg.sender, value);
       if (!success) {
            revert RaffileEngine__FailedToSellToken();
        }
    }


    function enterRaffle(uint256 amount) external{
        uint256 userTokenBalance = stableToken.balanceOf(msg.sender);
        if(userTokenBalance == 0){
            revert RaffileEngine__BuyRaffleTokenToJoin();
        }
        if(userTokenBalance < amount){
            revert RaffileEngine__InsufficientBalanceToJoin();
        }

        stableToken.transferFrom(msg.sender, address(this), value);
        raffile_Players.push(msg.sender);
        emit 




    }
}
