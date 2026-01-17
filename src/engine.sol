// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {StableToken} from "./StableToken.sol";

contract RaffileEngine {
    error RaffileEngine__EthAmountCantBeZero();
    error RaffileEngine__FailedToBuyToken();
    error RaffileEngine__RaffileTokenBalanceIsZero();
    error RaffileEngine__InsufficientBalance();

    event userBuyToken(address indexed user, uint256 indexed amount);

    StableToken public immutable stableToken;

    constructor(address _stableTokenAddress) {
        stableToken = StableToken(_stableTokenAddress);
    }

    function buyRaffileToken() external payable {
        if (msg.value == 0) {
            revert RaffileEngine__EthAmountCantBeZero();
        }
        bool success = stableToken.buyToken{value: msg.value}(msg.sender);

        if (!success) {
            revert RaffileEngine__FailedToBuyToken();
        }
        emit userBuyToken(msg.sender, msg.value);
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
        stableToken.sellToken(msg.sender, value);
    }
}
