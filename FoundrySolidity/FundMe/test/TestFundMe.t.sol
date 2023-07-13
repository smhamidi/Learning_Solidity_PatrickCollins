// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// our contract to test have to inherit from foundry test contract
import {Test} from "forge-std/Test.sol";

// if we want to show something in the console we can also import console
import {console} from "forge-std/Test.sol";

// we also need our own contract in order to test the functionality
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    // The first function to run in test is setUp().
    function setUp() external {}
}
