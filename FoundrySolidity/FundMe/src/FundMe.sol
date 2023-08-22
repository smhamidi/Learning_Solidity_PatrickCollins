// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// We HAVE to install this package from a source because unlike
// remix that does this for us we have to do it manually using the following command in bash

// forge install smartcontractkit/chainlink-brownie-contracts --no-comit

// Then and only then we can do some aliasing in the foundry.toml like this
// remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/"]

import {PriceConverter} from "./PriceConverter.sol";

// Its better to name you error with this convection: contractName__ErrorName
error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] public s_funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner; // these are in storage, reading and writing from storage is incredably expensive
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;

    AggregatorV3Interface private s_priceFeed;
    
    constructor(address priceFeedAddress) {
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256){
        return s_priceFeed.version();
    }
    
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // But there is better way for us to write the withdraw function to be more gas efficient
    function CheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
    }
    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }


    // Now we make our getter function because we made our storage variables private (better for gas)
    // and now the only way to have access to those variables is with their own getter function
    function getFunders() external view returns(address[] memory) {
        return s_funders;
    }

    function getAddressToAmountArray(address _address) external view returns(uint256){
        return s_addressToAmountFunded[_address];
    }

    function getOwnerAddress () external view returns (address){
        return i_owner;
    }
}

