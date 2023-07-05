// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* purpose of this file:
    we want to make a library using the function in FundMe.sol to
    convert the units we want to wei.
*/

// in order to use the interface, we have to import that contract that allows us to work with the interface
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {

    function getPrice() internal view returns(uint256) {
        // In order to get the price we need
        // First the address of the contract that store the value of ETH/USD in the chainlink oracle
        // Second we need the ABI ( application binary interface )
        address ETH_USD_SepoliaAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        AggregatorV3Interface priceFeed = AggregatorV3Interface(ETH_USD_SepoliaAddress);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ETH_amount) internal view returns(uint256) {
        uint256 ETH_price = getPrice();
        uint256 ETH_AmountInUSD = (ETH_amount * ETH_price) / 1e18;
        return ETH_AmountInUSD;
    }

    function getVersion() internal view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}