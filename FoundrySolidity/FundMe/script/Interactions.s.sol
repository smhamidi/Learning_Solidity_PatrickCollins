// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

import {FundMe} from "../src/FundMe.sol";

import {console} from "forge-std/Script.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecent) public {
        FundMe(payable(mostRecent)).fund{value: SEND_VALUE}();
        console.log(
            "Fund the lastest contract with %s amount of eth",
            SEND_VALUE
        );
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecent) public {
        FundMe(payable(mostRecent)).withdraw();
        console.log("withdraw the lastest contract");
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}
