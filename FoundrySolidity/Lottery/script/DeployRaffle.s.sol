// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {CreateSubscription} from "./Interaction.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinator,
            bytes32 gasLane,
            uint64 subscriptionID,
            uint32 callBackGasLimit
        ) = helperConfig.activeNetworkConfig();

        if (subscriptionID == 0) {
            // this means we are using anvil chain and we have to create our own subscriptionID
            CreateSubscription createsubscriptionID = new CreateSubscription();
            subscriptionID = createsubscriptionID.createSubscription(
                vrfCoordinator
            );
        }
        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinator,
            gasLane,
            subscriptionID,
            callBackGasLimit
        );
        vm.stopBroadcast();
        return (raffle, helperConfig);
    }
}
