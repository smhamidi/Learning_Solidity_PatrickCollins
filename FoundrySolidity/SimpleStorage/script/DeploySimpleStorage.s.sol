// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// we have to import script.sol in order to write a solidity contract as an script
import {Script} from "forge-std/Script.sol";

// we also have to import our own contract
import {SimpleStorage} from "../src/SimpleStorage.sol"; // Professional and efficient way to import is like this

// This contract is made in order for us to deploy our contract using the solidity language itself
// in order to write our contract with the roll of a script we have to inherit from script.sol
contract DeploySimpleStorage is Script {
    // run(), is the main function to work with in foundry
    function run() external returns (SimpleStorage) {
        // vm object belong to foundry, in pure solidity this will not work
        vm.startBroadcast(); // Anything after this line will be sent to rpc
        // any transaction that we actully sends is going to be in this block

        SimpleStorage simplestorage = new SimpleStorage();
        // we could also make a SimpleStorage Contract with some value pass to it, the code is as follows
        // SimpleStorage simplestorage = new SimpleStorage{value: 1 ether}();

        vm.stopBroadcast(); // End of broadcasting

        return simplestorage;
    }
}
// head to .env file to see how you can broadcast this script
