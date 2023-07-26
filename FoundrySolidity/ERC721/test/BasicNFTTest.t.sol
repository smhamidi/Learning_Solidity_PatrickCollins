// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract TestBasicNFT is Test {
    DeployBasicNFT public deployer;
    BasicNFT public ourNFT;

    function setUp() external {
        deployer = new DeployBasicNFT();
        ourNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Cutie";
        string memory expectedSymbol = "CAT";

        string memory actualName = ourNFT.name();
        string memory actualSymbol = ourNFT.symbol();

        /** Why we can not compare two string directly
         * Strings are an special type, they are array of bytes
         * you can not compare them directly because an string does not
         * have the information of the whole array, it just contains the
         * address of the first cell
         */
        // We can loop through loops to compare the two array but that is not IDEAL
        // We can pack them in bytes and get the hash of the two packbytes object
        assert(
            keccak256(abi.encodePacked(actualName)) ==
                keccak256(abi.encodePacked(expectedName))
        );
        assert(
            keccak256(abi.encodePacked(actualSymbol)) ==
                keccak256(abi.encodePacked(expectedSymbol))
        );
    }
}
