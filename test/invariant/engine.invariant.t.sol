// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StableToken} from "src/StableToken.sol";
import {RaffileEngine} from "src/engine.sol";
import {EngineConfig} from "script/config.s.sol";
import {DeployEngine} from "script/deploy.s.sol";
import {RaffileEngine} from "src/engine.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract InvariantsTest is StdInvariant, Test {
    StableToken stableToken;
    RaffileEngine engine;
    EngineConfig.EngineParams config;

    address owner;
    address user;

    uint256 constant MAX_ETH = 1_000 ether;

    /*//////////////////////////////////////////////////////////////
                                SETUP
    //////////////////////////////////////////////////////////////*/

    function setUp() public {
        DeployEngine deploy = new DeployEngine();
        (config, stableToken, engine) = deploy.run();

        owner = address(engine);
        user = makeAddr("user");

        vm.deal(user, MAX_ETH);
        vm.deal(owner, MAX_ETH);
    }




}