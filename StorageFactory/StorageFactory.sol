// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import "../SimpleStorage/SimpleStorage.sol";

// in this contract we want a factory of SimpleStorage Contract
// we want a contract that makes an instance of SimpleStorage and save it.
contract StorageFactory{

    // Type, Visibility, Name
    SimpleStorage[] public FactoryOutput;

    function createSimpleStorageContract() public{
        FactoryOutput.push(new SimpleStorage());
    }

}