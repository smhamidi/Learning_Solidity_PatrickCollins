// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Anything before vm.startBroadcast() is not a real TX
        HelperConfig helperConfig = new HelperConfig();
        address Eth2UsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();

        FundMe fundMe = new FundMe(Eth2UsdPriceFeed);

        vm.stopBroadcast();
        return fundMe;
    }
}
