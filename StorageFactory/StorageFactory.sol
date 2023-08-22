// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

// to import we use the below structor
// import "../SimpleStorage/SimpleStorage.sol";
/* the more advanced way is to import only what we want,
   this is extremly important because we pay gas for every line
   and we DO NOT want anything extra on our contract dyployment
   */
import {SimpleStorage} from "../SimpleStorage/SimpleStorage.sol";

// in this contract we want a factory of SimpleStorage Contract
// we want a contract that makes an instance of SimpleStorage and save it.
contract StorageFactory{

    // Type, Visibility, Name
    SimpleStorage[] public FactoryOutput;

    function createSimpleStorageContract() public{
        FactoryOutput.push(new SimpleStorage());
        // we could also make the new contract first and then push it
    }

    // This is how we can interact with another contract within our contract
    function sfStore(uint256 _storageIndex, uint256 _storageFavoriteNumber) public {
        FactoryOutput[_storageIndex].store(_storageFavoriteNumber);
    }

    // Using this function we are getting the favorite nubmer out of one of our contract
    function sfGet(uint256 _storageIndex) public view returns (uint256) {
        return FactoryOutput[_storageIndex].getFavoriteNumber();
    }

}