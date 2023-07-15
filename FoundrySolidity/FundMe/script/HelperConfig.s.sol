// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// Purpose of this contract is:
// 1. Deploy mocks for when we are deploying on a local anvil blockchain
// 2. keep contract addresses on different across different chains
// e.g. Sepolia ETH/USD, Mainnet ETH/USD

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

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

    // these two number is for us to prevent magical numbers in our code
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_VALUE = 2000e8;

    function getOrCreateAvnilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            // if we already define it then just pass it, do not go through the process again
            return activeNetworkConfig;
        }
        // return price feed address for Anvil local network
        // 1. Deploy the mocks (mock contracts are like dummy contracts)
        // 2. return the mock address
        vm.startBroadcast(); // because of this vm keyword, we cannot have this function as pure
        // MockV3Aggregator mockV3 = new MockV3Aggregator(8, 2000e8); // we hate magical numbers
        // instead we make our variables like this
        MockV3Aggregator mockV3 = new MockV3Aggregator(DECIMALS, INITIAL_VALUE);
        vm.stopBroadcast();

        NetworkConfig memory AnvilNetwork = NetworkConfig({
            priceFeed: address(mockV3)
        });

        return AnvilNetwork;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // return price feed address for mainnet network
        NetworkConfig memory MainetNetwork = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return MainetNetwork;
    }

    NetworkConfig public activeNetworkConfig;

    // Now we can detect the network in constructor and set the activeNetworkConfig

    constructor() {
        if (block.chainid == 11155111) {
            // you can find these chainids in chainlist.org
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAvnilEthConfig();
        }
    }
}
