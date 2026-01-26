// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StableToken} from "src/StableToken.sol";
import {RaffileEngine} from "src/engine.sol";



contract Handler is Test {
    StableToken stableToken;
    RaffileEngine engine;
     address vrf;

   
   

    /*//////////////////////////////////////////////////////////////
                                SETUP
    //////////////////////////////////////////////////////////////*/

 constructor(address _vrf, address token, address  eng) {

vrf= _vrf;
engine = RaffileEngine(payable(eng));
stableToken = StableToken(token);
     
    }




function buyRaffileToken() external{

}
function sellRaffileToken(uint256 value) external{
    
}
function buyTickets(uint256 tokenAmount) external{}
function enterRaffle(uint256 ticketsToUse) external{}






    




}