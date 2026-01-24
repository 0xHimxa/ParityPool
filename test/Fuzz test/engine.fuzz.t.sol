// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StableToken} from "src/StableToken.sol";
import {RaffileEngine} from "src/engine.sol";
import {EngineConfig} from "script/config.s.sol";
import {DeployEngine} from "script/deploy.s.sol";
import {RaffileEngine} from "src/engine.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract TestStabeleToken is Test {
    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/

    StableToken stableToken;
    RaffileEngine engine;

    EngineConfig.EngineParams config;
    address engAddress;

    // Test users
    address user = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address user1 = makeAddr("user12");
    address user2 = makeAddr("user23");

    // Common test amount
    uint256 buyAmount = 2 ether;

    /*//////////////////////////////////////////////////////////////
                                SETUP
    //////////////////////////////////////////////////////////////*/

    function setUp() public {
        DeployEngine deploy = new DeployEngine();
        EngineConfig.EngineParams memory _config;

        // Deploy engine, token, and load config
        (_config, stableToken, engine) = deploy.run();
        config = _config;
        engAddress = address(engine);

        // Fund test accounts
        vm.deal(user, 100 ether);
        vm.deal(user2, 100 ether);
        vm.deal(engAddress, 100 ether);
    }



function testBuyRaffileToken(uint88 amount, address to) external {

vm.assume(to != address(0));
vm.assume(to.code.length == 0);
vm.assume(uint160(to) > 10);
uint256 fundEth = bound(amount,1,type(uint88).max);
vm.deal(to, fundEth);
uint256 userBalanceB4 = to.balance;


console.log(userBalanceB4, "user Balance before buy");
vm.startPrank(to);
engine.buyRaffileToken{value: fundEth}();
vm.stopPrank();

uint256 userBalanceAfter = to.balance;
console.log(userBalanceAfter, "user Balance after buy");

assertEq(address(stableToken).balance, fundEth);
assert(userBalanceAfter == 0);




}






}