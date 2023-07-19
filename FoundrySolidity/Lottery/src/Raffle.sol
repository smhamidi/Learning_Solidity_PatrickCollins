// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/// @title A Sample Raffle contract
/// @author Seyyed Mohammad Hamidi
/// @notice this is a sample Raffle contract
/// @dev implementing chainlik VRFv2
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {}

    function pickWinner() public {}

    /** Getter function to get our private variables starts here */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
