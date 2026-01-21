// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {StableToken} from "src/StableToken.sol";
import {RaffileEngine} from "src/engine.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {EngineConfig} from "./config.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract DeployEngine is Script {
    uint256 subId;

    LinkTokenInterface LINKTOKEN;
    address user =  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 linkFunding = 3 ether; 

    function run() public {
        EngineConfig config = new EngineConfig();
        EngineConfig.EngineParams memory params = config.getNetworkConfig();

        vm.startBroadcast(user);



        if (params.subId == 0) {
            console.log(params.subId, "here");
vm.roll(1);// Add this line to prevent underflow in simulation
            params.subId = VRFCoordinatorV2_5Mock(params.vrfCoordnator).createSubscription();
            console.log(params.subId, "created");
        }


        StableToken stableToken = new StableToken();
        RaffileEngine engine = new RaffileEngine(
            address(stableToken), params.vrfCoordnator, params.keyHash, params.linkToken, params.subId
        );

        stableToken.transferOwnership(address(engine));

        VRFCoordinatorV2_5Mock(params.vrfCoordnator).addConsumer(params.subId, address(engine));


if(block.chainid == 31337){
        VRFCoordinatorV2_5Mock(params.vrfCoordnator).fundSubscription(params.subId, linkFunding);
}
else if(block.chainid == 11155111){
LinkTokenInterface(params.linkToken).transferAndCall(params.vrfCoordnator, linkFunding, abi.encode(params.subId));
    
}

        vm.stopBroadcast();

    }
}

