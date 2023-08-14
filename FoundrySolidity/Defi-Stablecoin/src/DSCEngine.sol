// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title DSCengine
 * @author Smhamidi
 *
 * the system is designed in a minimal manner and the objective is that each token hold a value of 1 dollar peged.
 * the properties of this stablecoin is :
 * 1. Exogenous collateral
 * 2. Algorithmic
 * 3. Pegged to 1$
 *
 * it is similar to dai if dai has no governenced
 */
contract DSCEngine is ReentrancyGuard {
    /** Errors **/
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__TokenIsNotAllowed();

    /** StateVariables **/
    mapping(address token => address pricefeed) private s_priceFeeds;

    DecentralizedStableCoin public immutable i_DSC;

    /** Modifiers **/
    modifier moreThanZero(uint256 amount) {
        if (amount <= 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__TokenIsNotAllowed();
        }
        _;
    }

    /** Functions **/
    constructor(
        address[] memory tokenAddresses,
        address[] memory priceFeedAddresses,
        address dscAddress
    ) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_DSC = DecentralizedStableCoin(dscAddress);
    }

    /** External Functions **/

    function depositCollateralAndMintDSC() external {}

    function depositCollateral(
        address tokenCollateralAddress,
        uint256 collateralAmount
    )
        external
        moreThanZero(collateralAmount)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {}

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
