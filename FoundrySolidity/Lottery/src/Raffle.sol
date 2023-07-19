// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

/// @title A Sample Raffle contract
/// @author Seyyed Mohammad Hamidi
/// @notice this is a sample Raffle contract
/// @dev implementing chainlik VRFv2
contract Raffle {
    uint256 private immutable i_entranceFee;

    address payable[] private s_players; // It should be and array because there is more than one players,
    // it should be private because it does not create a getter function,
    // it should also be payable because we need to send them money if they won

    /// @dev duration of the pickWinner interval in seconds
    uint256 private immutable s_timeInterval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionID;
    uint32 private immutable i_callBackGasLimit;

    bytes32 private immutable i_gasLane;
    uint16 private constant REQUEST_CONFIMATIONS = 3;
    uint32 private constant NUM_WORD = 1;
    // We have to compare this variable with some initialTimeInterval
    uint256 private s_lastTimeStamp; // the first time stamp should be set in the constructor

    error Raffle__NotEnoughETHSent();

    event EnteredRaffle(address indexed enteredPlayer);

    /** Starting Events */

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionID,
        uint32 callBackGasLimit
    ) {
        i_entranceFee = entranceFee;
        s_timeInterval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionID = subscriptionID;
        i_callBackGasLimit = callBackGasLimit;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughETHSent();
        }

        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);
    }

    // Get a random number
    // Pick a winner with the help of that random number
    // We want this function to called automatically
    function pickWinner() public {
        if ((block.timestamp - s_lastTimeStamp) < s_timeInterval) {
            revert();
        }

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, // gas lane
            i_subscriptionID, // the chain link id that you funded with LINK
            REQUEST_CONFIMATIONS, // number of block confirmation you need
            i_callBackGasLimit, // to make sure we dont overspend on this call
            NUM_WORD // the number of random number we need
        );
    }

    /** Getter function to get our private variables starts here */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
