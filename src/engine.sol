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
  error RaffileEngine__InsufficientTokenToBuyTicket();
error RaffileEngine__InsufficientBalanceBuyMoreToken();
error RaffileEngine__AlreadyJoined();


    event userBuyToken(address indexed user, uint256 indexed amount);
    event userSellToken(address indexed user, uint256 indexed amount);

    StableToken public immutable stableToken;
    uint256  immutable rafileTikenPrice;
    address[] raffile_Players;


uint256 public raffleId;
uint256 public entranceFee = 5e18;
mapping(address => uint256) public ticketBalance; 

mapping(uint256 => TicketRange[]) public roundRanges;
mapping(uint256 => uint256) public roundTotalTickets;
mapping(uint256 => mapping(address => bool)) public hasEnteredRound;


uint256 public totalTicketsUseInRaffle;
uint256 public currentRound;




struct TicketRange {
    uint256 start;
    uint256 end;
    address owner;
}



    constructor(address _stableTokenAddress,uint256 _rafileTikenPrice) {
        stableToken = StableToken(_stableTokenAddress);
        rafileTikenPrice = _rafileTikenPrice;
    }




function buyTickets(uint256 tokenAmount) external {
    uint256 userTokenBalance = stableToken.balanceOf(msg.sender);
    if (userTokenBalance < tokenAmount) {
        revert RaffileEngine__InsufficientBalanceBuyMoreToken();
    }

    uint256 tickets = tokenAmount / entranceFee;
    if (tickets == 0) {
        revert RaffileEngine__InsufficientTokenToBuyTicket();
    }

    uint256 cost = tickets * entranceFee;

    stableToken.transferFrom(msg.sender, address(this), cost);

    ticketBalance[msg.sender] += tickets;
}






function enterRaffle(uint256 ticketsToUse) external {
    if (ticketsToUse == 0) {
        revert RaffileEngine__InsufficientTokenToBuyTicket();
    }

    if (ticketBalance[msg.sender] < ticketsToUse) {
        revert RaffileEngine__InsufficientBalanceToJoin();
    }

    if (hasEnteredRound[raffleId][msg.sender]) {
        revert RaffileEngine__AlreadyJoined();
    }

    // Mark user as entered
    hasEnteredRound[raffleId][msg.sender] = true;

    // Consume tickets
    ticketBalance[msg.sender] -= ticketsToUse;

    // Assign ticket range
    uint256 start = roundTotalTickets[raffleId] + 1;
    uint256 end = start + ticketsToUse - 1;

    roundRanges[raffleId].push(
        TicketRange({
            start: start,
            end: end,
            owner: msg.sender
        })
    );

    // Update total
    roundTotalTickets[raffleId] = end;
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

}
