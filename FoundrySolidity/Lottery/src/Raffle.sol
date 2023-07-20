// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/// @title A Sample Raffle contract
/// @author Seyyed Mohammad Hamidi
/// @notice this is a sample Raffle contract
/// @dev implementing chainlik VRFv2
contract Raffle is VRFConsumerBaseV2 {
    error Raffle__NotEnoughETHSent();
    error Raffle__TransferFailedForWinner();
    error Raffle__CalculationTime();

    /** Declaring the enums */
    // the first enum that we make is the state enum which represent the state of the contract
    enum RaffleState {
        OPEN,
        CALCULATING
    }
    uint256 private immutable i_entranceFee;

    address payable[] private s_players; // It should be and array because there is more than one players,
    // it should be private because it does not create a getter function,
    // it should also be payable because we need to send them money if they won

    /// @dev duration of the pickWinner interval in seconds
    uint256 private immutable s_timeInterval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionID;
    uint32 private immutable i_callBackGasLimit;
    address private recentWinner;

    bytes32 private immutable i_gasLane;
    uint16 private constant REQUEST_CONFIMATIONS = 3;
    uint32 private constant NUM_WORD = 1;
    // We have to compare this variable with some initialTimeInterval
    uint256 private s_lastTimeStamp; // the first time stamp should be set in the constructor
    RaffleState private s_raffleState;

    /** Starting Events */
    event EnteredRaffle(address indexed enteredPlayer);

    event WinnerPicked(address payable indexed Winner);

    constructor(
        // when ever we inherit from a contract, we have to deal with the constructor of the inheritited contract
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionID,
        uint32 callBackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        s_timeInterval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionID = subscriptionID;
        i_callBackGasLimit = callBackGasLimit;
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() public payable {
        // It is better to go through these 3 step for every function in the exact same order
        // Checkings (check for every condition first, this way it will be more gas efficient)
        // Effects (We effect our own contract)
        // Interactions (interaction with other contract)
        // This order is so important because many attack can be prevented with this order
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughETHSent();
        }

        if (s_raffleState == RaffleState.CALCULATING) {
            revert Raffle__CalculationTime();
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
        s_raffleState = RaffleState.CALCULATING;

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, // gas lane
            i_subscriptionID, // the chain link id that you funded with LINK
            REQUEST_CONFIMATIONS, // number of block confirmation you need
            i_callBackGasLimit, // to make sure we dont overspend on this call
            NUM_WORD // the number of random number we need
        );
    }

    function fulfillRandomWords(
        uint256 requestID,
        uint256[] memory randomWords
    ) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        recentWinner = winner;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;

        (bool success, ) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailedForWinner();
        }

        emit WinnerPicked(winner);
    } // An important issue to consider is that we dont want any newcommer when we are giving the prise

    // check the enums

    /** Getter function to get our private variables starts here */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
