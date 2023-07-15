// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // setUp function always runs first
    function setUp() external {
        // For our deployment of the contract we have to make it first
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // Who is the owner of this contract, us or the FundMeTest contract?
        // the owner is the contract itself because we have not called setUp
        // function, we have called test which then leads to the contract running
        // setUp function, so because of this, the owner is the contract itself

        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
    }

    function testDemo() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testAggregatorVersion() public {
        assertEq(fundMe.getVersion(), 4); // if we dont specify a chain, this will
        // revert because the address doesn't belongs to anvil simulated chain
    }
}
