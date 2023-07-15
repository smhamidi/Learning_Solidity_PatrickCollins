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
}
