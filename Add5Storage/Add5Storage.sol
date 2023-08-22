// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "../SimpleStorage/SimpleStorage.sol";

// This contract will inherit everything from SimpleStorage contract
// and we can modify any part of it if we want
contract Add5Storage is SimpleStorage {
    // in this contract we want to override a function in SimpleStorage.sol
    // Two keyword is vital for this task, virtual and override
    /*  Virtual:
    The virtual keyword in Solidity is used to mark a function or a state variable
     in a base contract as being overridable. This means that any contract that 
     inherits from this base contract can change the behavior of this function
     or state variable.
    */
    /*  Override:
    The override keyword is used in a derived contract to indicate that a function 
    or state variable is meant to override a function or state variable from a base 
    contract. The function or state variable that it overrides must be marked as virtual.
    */
    function store(uint256 _favoriteNumber) public override{
        myFavoriteNumber = _favoriteNumber + 5;
    }
}