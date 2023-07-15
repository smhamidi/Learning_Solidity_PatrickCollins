// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Purpose of this contract is:
// 1. Deploy mocks for when we are deploying on a local anvil blockchain
// 2. keep contract addresses on different across different chains
// e.g. Sepolia ETH/USD, Mainnet ETH/USD

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    // If we are on a local anvil, we deploy mocks
    // otherwise grab the existing address from the live network
    // With doing this, it does not matter what chain we are dealing with, It WORKS ANYWAY.

    // maybe our config is complex, it can contain for example, price feed address, vrf address and many more
    // it is a good idea to make config, its own type

    struct NetworkConfig {
        address priceFeed; // This is the address of ETH/USD price feed in that chain
    }

    // Our NetworkConfig is an array so you have to specify the storage location in returns argument
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // return price feed address for sepolia network
        NetworkConfig memory SepoliaNetwork = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return SepoliaNetwork;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        // return price feed address for Anvil local network
    }

    NetworkConfig public activeNetworkConfig;

    // Now we can detect the network in constructor and set the activeNetworkConfig

    constructor() {
        if (block.chainid == 11155111) {
            // you can find these chainids in chainlist.org
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }
}
