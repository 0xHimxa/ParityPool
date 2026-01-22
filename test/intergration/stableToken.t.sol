// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StableToken} from "src/StableToken.sol";
import {RaffileEngine} from "src/engine.sol";
import {EngineConfig} from "script/config.s.sol";
import {DeployEngine} from "script/deploy.s.sol";


contract TestStabeleToken is Test {
 
 StableToken stableToken;

 EngineConfig.EngineParams config;
    address user = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address user2 = makeAddr("user23");

uint256 buyAmount = 2 ether;


    function setUp() public{
 DeployEngine deploy = new DeployEngine();
 EngineConfig.EngineParams memory _config;
 ( _config,stableToken, ) = deploy.run();

 config = _config;


vm.deal(user,100 ether);
vm.deal(user2,100 ether);



    }


// stable contract tests

function testPrecision() external view {

uint256 precision = stableToken.getPrecision();

assertEq(precision, 1e10);



}

function testPricePrecision() external view {

uint256 pricePrecision = stableToken.getPricePrecision();

assertEq(pricePrecision, 1e18);



}

function testBuyFee() external view {

uint256 buyFee = stableToken.getBuyFee();

assertEq(buyFee, 10);



}

function testSellFee() external view {

uint256 sellFee = stableToken.getSellFee();

assertEq(sellFee, 15);



}

function testFeePrecision() external view {

uint256 feePrecision = stableToken.getFeePrecision();

assertEq(feePrecision, 100);



}

function testFeeAddress() external view {

address feeAddress = stableToken.getFeeAddress();

assertEq(feeAddress, config.priceFeed);



}

function testBuyTokenFailedZeroEthSent() external{

vm.prank(user);
vm.expectRevert(StableToken.StableToken__EthAmountCantBeZero.selector);

stableToken.buyToken(user);







}

function testBuyTokenFailedOnlyOwner() external{
 
vm.prank(user2);
vm.expectRevert();
stableToken.buyToken{value: buyAmount}(user);


}


function testBuyFailedToAdrressZero() external{
    vm.prank(user);
    vm.expectRevert(StableToken.StableToken__UserBuyingAddressCantBeZero.selector);
    stableToken.buyToken{value: buyAmount}(address(0));

}



function testEthConverther() external{

vm.prank(user);
uint256 ethWorth = stableToken.getAndConvertEthPrice(buyAmount);


assertEq(ethWorth, 6000e18);




}



function testconvertUSDToEth() external{
uint256 ethAmount = stableToken.convertUSDToEth(6000e18);

assertEq(ethAmount, buyAmount);

}





function testBuyTokenSuccessed() external{
    vm.prank(user);
    stableToken.buyToken{value: buyAmount}(user);

uint256 ethWorth = stableToken.getAndConvertEthPrice(buyAmount);


uint256 fee = (ethWorth * 10) / 100; 

 uint256 mintAmount = ethWorth - fee;

assertEq(stableToken.balanceOf(user), mintAmount);



console.log(stableToken.balanceOf(user));

}




// engine contract tests




}