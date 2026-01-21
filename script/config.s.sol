//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract EngineConfig  is Script {
    uint256  public constant  anvilChainId = 31337;
    uint256  public constant  sepoliaChainId = 11155111;
    uint256  public constant  goerliChainId = 5;
    uint256  public constant  mainnetChainId = 1;

 struct EngineParams{
    address vrfCoordnator;
    bytes32 keyHash;
    address linkToken;
    uint256 subId;


 }

 function getNetworkConfig() public returns (EngineParams memory){

if(block.chainid == anvilChainId){

 //return getAvilConfig();
}


 }



}



