// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {StableToken} from "src/StableToken.sol";
import {RaffileEngine} from "src/engine.sol";
import {IVRFCoordinatorV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract DeployEngine is Script {
uint256 subId;
IVRFCoordinatorV2Plus s_vrfCoordinator = IVRFCoordinatorV2Plus(0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B);
LinkTokenInterface LINKTOKEN;

function run() public{




    
}





   function _createNewSubscription() private  {
     subId = s_vrfCoordinator.createSubscription();
   // Add this contract as a consumer of its own subscription.
    s_vrfCoordinator.addConsumer(subId, address(this));
    }






}

