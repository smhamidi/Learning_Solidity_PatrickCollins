// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* What is this contract all about:
    in this contract our objective is to make a contrat for people to
    to donate some money,
    then we want to have the ability to withdraw this money,
    the rules are that only the manager should be capable of
    withdrawing the money,
    the second rule is that there is a minimum required amount
    for sending money, and you have to at least send 50 USD
*/
/* transactions - fields
    1. Nonce: tx count for the account
    2. Gas price: price per unit of gas ( in Wei )
    3. Gas limit: max gas that this tx can use
    4. To : address that the tx is sent to
    5. Value: amount of wei to send
    6. Data: what to send to the To address, Zero in value transaction
    7. v, r, s: components of tx signature
*/

// in order to use the interface, we have to import that contract that allows us to work with the interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUSD = 5;// But we cant work with this number directly because blockchain has No idea about real world
    // and because of that, We use ChainLink, a decentralized oracle network.

    // The following function should be payable because we want to send native token value
    function fund() public payable {
        // you can access the value sent to this function using the global variable msg.value
        // msg.value is the number of wei send with the message
        // If we want at least 1 Eth to get sent we can use the following command
        // require (msg.value > 1e18, "Didn't send enough ETH :(");
        // After we implemented the two following function we can write our required line like this
        require(getConversionRate(msg.value) >= (minimumUSD * 1e18), "didn't send enough ETH");
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }
    /* what happens if the requirements of a function do not meet? it will revert
        What is revert:
        undo any actions that have been done, and send the remaining gas back.
    */

    function getPrice() public view returns(uint256) {
        // In order to get the price we need
        // First the address of the contract that store the value of ETH/USD in the chainlink oracle
        // Second we need the ABI ( application binary interface )
        address ETH_USD_SepoliaAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        AggregatorV3Interface priceFeed = AggregatorV3Interface(ETH_USD_SepoliaAddress);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ETH_amount) public view returns(uint256) {
        uint256 ETH_price = getPrice();
        uint256 ETH_AmountInUSD = (ETH_amount * ETH_price) / 1e18;
        return ETH_AmountInUSD;
    }

    // for the next part we want to have a list of all funders
    address[] public funders;

    // we could also make a mapping from the senders to they money they have funded
    // there is a new feature in solidity that you can put name in the mapping: funder and amoundFunded
    mapping(address funder => uint256 amountFunded) public fundersAmount;
    

    // Only the owner of this contract should be able to call this function
    function withdraw() public {}

}
