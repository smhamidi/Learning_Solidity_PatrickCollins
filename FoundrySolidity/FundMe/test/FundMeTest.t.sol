// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract FundMeTest is StdCheats, Test {
    FundMe fundMe;

    address USER = makeAddr("OurFakeUserToSendTheTransactionWith");

    uint256 SendValue = 1 ether;

    uint256 constant GAS_PRICE = 1;

    // setUp function always runs first
    function setUp() external {
        // For our deployment of the contract we have to make it first
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // Who is the owner of this contract, us or the FundMeTest contract?
        // the owner is the contract itself because we have not called setUp
        // function, we have called test which then leads to the contract running
        // setUp function, so because of this, the owner is the contract itself

        DeployFundMe deploy = new DeployFundMe();
        vm.deal(USER, 1000 ether);
        fundMe = deploy.run();
    }

    // *** every time we run a function, the setUp() will run first and then the test will run ***

    function testAggregatorVersion() public {
        assertEq(fundMe.getVersion(), 4); // if we dont specify a chain, this will
        // revert because the address doesn't belongs to anvil simulated chain
    }

    function testFundFailWithoutEnoughETH() public {
        vm.expectRevert(); // this like tells solidity that we expect the next line to revert
        fundMe.fund(); // send the function without enough eth, we must send at least MINIMUM_USD/ETH
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // means the next TX is going to be send with USER address
        fundMe.fund{value: SendValue}(); // The USER must the value we are transacting with, see setUp().

        uint256 amountFunded = fundMe.getAddressToAmountArray(USER);
        assertEq(amountFunded, SendValue);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SendValue}();

        assertEq(fundMe.getFunders()[0], USER);
    }

    modifier sendFund() {
        vm.prank(USER);
        fundMe.fund{value: SendValue}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public sendFund {
        vm.expectRevert(); // We said this line look for a revert in the next line, vm.{anyting} does not count
        vm.prank(USER); // the order for these two does not matter, we could write prank first and then expectRevert
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public sendFund {
        uint256 startingOwnerBalance = fundMe.getOwnerAddress().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwnerAddress());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwnerAddress().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingContractBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingContractBalance
        );
    }

    function testWithdrawFromMultipleFunders() public sendFund {
        // vm.txGasPrice(GAS_PRICE); by doing this you can set a gas price to the rest of the transactions

        uint160 NumberOfFunders = 10; // if you want to make an address with a number, that number must be uint160
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < NumberOfFunders; i++) {
            address funderAddress = address(i);
            hoax(funderAddress, SendValue); // this will create that address and give it a balance
            // do the work for both prank and deal function, *#*# so the next line will be called using funderAddress *#*#
            fundMe.fund{value: SendValue}();
        }

        uint256 startingOwnerBalance = fundMe.getOwnerAddress().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwnerAddress());
        fundMe.withdraw(); // anything between of startPrank and stopPrank will be done using the given address
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            startingContractBalance + startingOwnerBalance ==
                fundMe.getOwnerAddress().balance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public sendFund {
        // vm.txGasPrice(GAS_PRICE); by doing this you can set a gas price to the rest of the transactions

        uint160 NumberOfFunders = 10; // if you want to make an address with a number, that number must be uint160
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < NumberOfFunders; i++) {
            address funderAddress = address(i);
            hoax(funderAddress, SendValue); // this will create that address and give it a balance
            // do the work for both prank and deal function, *#*# so the next line will be called using funderAddress *#*#
            fundMe.fund{value: SendValue}();
        }

        uint256 startingOwnerBalance = fundMe.getOwnerAddress().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwnerAddress());
        fundMe.CheaperWithdraw(); // anything between of startPrank and stopPrank will be done using the given address
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            startingContractBalance + startingOwnerBalance ==
                fundMe.getOwnerAddress().balance
        );
    }
}
