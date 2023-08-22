// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract TestBasicNFT is Test {
    DeployBasicNFT public deployer;
    BasicNFT public ourNFT;

    address public USER1 = makeAddr("USER1");
    address public USER2 = makeAddr("USER2");

    string public TOKEN_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

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

    function testCanMingAndHasBalance() public {
        vm.prank(USER1);
        ourNFT.mintNft(TOKEN_URI);

        assert(ourNFT.balanceOf(USER1) == 1);
        assert(
            keccak256(abi.encodePacked(TOKEN_URI)) ==
                keccak256(abi.encodePacked(ourNFT.tokenURI(0)))
        );
    }
}
