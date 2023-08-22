// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; // The caret (^) symbol is used to indicate that
                         // the code is compatible with Solidity version 0.8.18 and any newer
                         // **MINOR** version up to but not including 0.9.0

/* What is this contract all about
    in this contract we are going to discuss two SPECIAL function, receive and fallback.
    these two function helps us to have more control in our contract

    1. receive() external payable: This function is executed on a call to the contract if none
     of the other functions match the given function signature, and if the call data is empty.
     If this function is not present and no data was sent along with the call, the contract will
     not be able to receive Ether through regular transactions and will throw an exception.

    2. fallback() external payable: This function is executed if a non-existent function is called
     or if no function has been called at all (i.e., there's no function signature, but there is call data).
     If the fallback function is not present, the contract will not be able to receive Ether
     through regular transactions and will throw an exception.

    ** these function will be called outside of our contract, so they should be external
    ** they also need to be payable because by their nature they are designed to handle incomming ETH
*/
contract FallbackExample {
    uint256 public result;

    // we can send this contract ETH directly and by doing that, this function will trigger
    // The value does NOT matter, if we transact to the contract without specifying a function, this function will trigger
    // in other word, receive is called only if Calldata is blank
    receive() external payable {
        result = 1;
    } // if there is no receive function in your contract, solidity will call fallback function.

    // In other hand if we put data in fallback specifying a function, solidity will look for that function,
    // if solidity is able to find the function then the function get trigger, but if such a function does
    // not exist, then fallback function will be called
    fallback() external payable {
        result = 2;
    }
}