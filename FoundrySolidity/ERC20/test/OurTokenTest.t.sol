// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address private bob = makeAddr("Bob");
    address private alice = makeAddr("Alice");

    uint256 private STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assert(STARTING_BALANCE == ourToken.balanceOf(bob));
    }

    function testAllowenceWorks() public {
        uint256 initialAllowence = 1000;
        uint256 transferAmount = 500;

        // Now we want to allow alice to move token on behalf of bob
        vm.prank(bob);
        ourToken.approve(alice, initialAllowence);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }
}
