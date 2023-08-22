// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; // solidity version(hat means anything greater will also work)

// or we could write pragma solidity >=0.8.18 <0.9.0; to say greater than 8.18 and less than 9
// EACH LINE IN SOLIDITY ENDS WITH "  ;  "

contract SimpleStorage {
    // basic types : boolean, uint, int, address, bytes
    bool hasFavoriteNumber = true;

    // defining an storage variables
    uint256 myFavoriteNumber = 88; // without initialization the default value is set

    // the default state of a variable or a function is internal, if you want you have
    // to specify the state, if your variable is public, there is a default getter function
    // for that variable which you can use to see the variable value
    // States: public, private, internal, external
    // public: visible externally and internally
    // private: only visible in the current contract
    // external: only visible externally for function
    // internal: only visible internally

    function store(uint _favoriteNumber) public virtual {
        // virtual keyword is needed because we later want to override this function in Add5Storage.sol
        myFavoriteNumber = _favoriteNumber;
    }

    // there are four function state, view, payable and pure
    // pure: Pure functions promise not to read from or modify the state.
    // view: View functions promise not to modify the state.
    // payable: A special type of function that can receive Ether.
    // ** pure and view functions will cost gas if they get called in a gas consuming function **
    function getFavoriteNumber() public view returns (uint256) {
        return myFavoriteNumber;
    }

    // we could also set favoriteNumber as public as it makes its own getter function
    // view function is going to only read from the state of the blockchain

    // We can also define an array in solidity, e.g. an array of favorite numbers
    // This is a dynamic array
    uint256[] listOfFavoriteNumbers;

    // We can also define an struct in solidity to make our own type.
    struct Person {
        uint256 age;
        string name;
        bool isCool;
    }

    // one way to use this struct:
    Person public Ali = Person(22, "Ali", true);
    // another way to use this struct:
    Person public Anahita = Person({age: 27, name: "Anahita", isCool: true});

    // We can also make a list of our structed variable
    Person[] public myFriends;
    // if we want to make an array with preset number of item we can use static arrays
    Person[3] public staticMyFriends;

    /* three data locations
    Solidity has three data location, memory, calldata and storage

    1: storage: This is where all the contract state variables reside.
        Every contract has its own storage and it is persistent between 
        function calls and transactions. Changes to storage are expensive in terms of gas.

    2: memory: This is a temporary place to store data. It is erased between (external) function calls and is cheaper to use.

    3: calldata: This is a special data location that contains the function arguments
        , only available for external function call parameters. It is similar to memory,
        but it is read-only. Since the introduction of the EVM upgrade known as "Istanbul", calldata is cheaper than memory. */
    /* why we need memory
    In Solidity, complex types like arrays, structs, and strings need to have a data location explicitly specified
     because they are passed by reference, not by value. This means that when you pass a string (or an array or struct)
      to a function, you're actually passing a pointer to the data, not the data itself.
    The data location (storage, memory, or calldata) tells Solidity where that data is stored.
     If you don't specify a data location for a string parameter in a function, the compiler
     doesn't know where to look for the data and you'll get a compile error.
    */

    // if you put calldata, you can not change it within the function
    // but with memory keyword you can change the function input within the funciton code
    function add_friend(
        uint256 _age,
        string memory _name,
        bool _isCool
    ) public returns (bool) {
        // in two ways we can make this function to add a Person to our array
        // first to make a new Person and then push it to our array
        // second is to directly push with a new Person inside the function of the push
        myFriends.push(Person({age: _age, name: _name, isCool: _isCool}));
        // 2. Person memory newPerson = Person(_age, _name, _isCool)
        //    myFriend.push(newPerson)

        // we can also add this friend to our mapping
        personToNumber[_name] = _age;
        _name = "ALI"; // this is only possible because _name is located in memory and not in calldata
        return true;
    }

    // if you want something dictionary in python, you can use mapping in solidity
    mapping(string => uint256) public personToNumber; // the default value for every key is zero
}

// To create this contract in foundry we can use the following command
// forge create SimpleStorage --rpc-url http://127.0.0.1:8545 --interactive
// after running this code it will prompt us to put the private key
