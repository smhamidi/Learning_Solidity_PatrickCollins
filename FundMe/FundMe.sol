// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// Before solidity version 8, the number operations was unchecked
// from solidity 8, the number operations are checked and for example
// if your number exceed the upper limit, you get an error for raising the nubmer.
// *# We can go to unchecked version using the unchecked keyword. #*
// e.g. unchecked {number = number + 1;}
// *## this unckecked keyword will make your contract more gas efficient, if you are certain about your code, use it ##*

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

/* gas efficiency ( constant and/vs immutable )
   in order to be more efficient with your gas, you can use the two keyword solidity has provided you, constant, immutable
   constant: In Solidity, constant is a keyword that can be used to define a variable that cannot be modified after it has been initialized.
   immutable: It is used to declare state variables that can be assigned only once during contract creation and cannot be changed afterwards.
   their differences:
    1. constant variables are assigned at compile time, while immutable variables are assigned at runtime during contract creation.

    2. constant variables can only hold simple datatypes and cannot hold complex datatypes like arrays and structs.
     On the other hand, immutable can hold both simple and complex datatypes.

    3. constant variables can be used in expressions and will be replaced by their value directly where they are used.
     immutable variables are stored in contract bytecode and are read from there when accessed.

    4. constant variables do not occupy storage slots, while immutable variables do, but only until the contract is constructed.

    5. constant variables can be declared and initialized in any part of the contract, while immutable variables
     can only be initialized in the constructor.

    6. constant variables can only be initialized with constant expressions, while immutable variables can be initialized
     with non-constant expressions as long as those expressions are evaluated at construction time.
*/

// in order to use the interface, we have to import that contract that allows us to work with the interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import {PriceConvertor} from "../PriceConvertor/PriceConvertor.sol";

error NotOwner(); // see the use in onlyOwner modifier

contract FundMe {
    // To use PriceConvertor Function in PriceConvertor.sol for uint256 types we can do as follows
    using PriceConvertor for uint256;
    // Now we can use the function in the PriceConvertor.sol for all uint256 types,
    
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
        // We can also use the following code
        // require(msg.value.getConversionRate() >= (minimumUSD * 1e18), "didn't send enough ETH");
        // the first value is the type that we have defined for the using of the library

        // msg.senders refers to who ever that has called this function
        funders.push(msg.sender);
        fundersAmount[msg.sender] += msg.value;
    }
    /* What happens if someone send this contract ETH without calling fund() function because anybody has the address of the contract
        we can use two special function in solidity, one is receive() and the other is fallback
        
    */
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
    function withdraw() public onlyOwner { // This function can only execute if its pass the modifier part onlyOwner
        // This function should be only callable by the owner of the contract, we can use require or modifiers
        // We have the owner address from the constructor, so we could do as above for require
        // require(msg.sender == owner, "You are not the owner");
        // but we prefer to use modifiers because they can be defined once and used many time

        // we could build a require for this function to be called only by the owner of the contract
        // BUT is not the best way, anyway, the code is as follows
        // require(msg.sender == owner, "You are not the owner");
        

        // we want to send all our balance to an account and then reset the fundersAmount
        // Structure of the foor loop is as follows
        // for( initialization, condition, update term) {} exactly like c++
        // while and do_while structure are valid in solidity but we often dont use unbound loops because of the gas usage
        for (uint256 i=0; i < funders.length; i++){
            fundersAmount[funders[i]] = 0;
        }
        // but we are not done, we still have to withdraw the funds and reset the funders array
        funders = new address[](0); // this will reset the array

        // there are three different ways you can withdraw

        // 1. transfer
        //payable(msg.sender).transfer(address(this).balance); // msg.sender is from the type of address,
                                                             // but we want to change it to payable address type
        // in solidity in order to send native blockchain tokens, your address needs to be payable
        // but there is problem with this method such as, it will revert transaction if gets any error like gas limit or ...


        // 2. send ( this function will now throw an error but it will give you a boolean
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed");

        // 3. call
        // call is the more advance way that is used in many other things, we can use it to transfer value using the following procedure
        (bool paySuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(paySuccess, "send failed");
    }

    address public owner;
    constructor() {// this is the constructor of our contract and it will be called at the first of deploying our contract

        owner = msg.sender;
    }

    modifier onlyOwner(){ // Now that we have defined this modifier we can use it in any function we want
        require(msg.sender == owner, "You are Not the owner, Sorry!"); // this line is not that efficient in terms of
                                                                       // gas because we have to store the error string which is a bytes array
                                                                       // What we can do is to use our custom errors
                                                                       // if(msg.sender != owner) { revert NotOwner();}
        _; // this means continue with the rest of the code
           // the order of the underscore matters, you could add it at the beginning, which would mean, first execute the function itself
           // then execute the code for the modifiers  
    }

}
