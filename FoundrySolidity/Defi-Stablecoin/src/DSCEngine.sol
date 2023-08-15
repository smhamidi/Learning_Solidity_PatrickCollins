// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

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
    /**
     * Errors *
     */
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__TokenIsNotAllowed();
    error DSCEngine__TransferFailed();
    error DSCEngine__UserViolatesHealthFactor(uint256 healthFactor);

    /**
     * StateVariables *
     */
    uint256 private constant ADDITIONAL_FEED_PRECITION = 1e10;
    uint256 private constant PRECISION = 1e18;
    uint256 private constant LIQUIDATION_THRESHOLD = 50;
    uint256 private constant LIQUIDATION_PRECISION = 50;
    uint256 private constant MIN_HEALTH_FACTOR = 1;

    mapping(address token => address pricefeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 collateralAmount)) private s_userToCollateralDeposited;
    mapping(address user => uint256 amountDSCMinted) private s_DSCMinted;
    address[] private s_collateralTokens;

    DecentralizedStableCoin public immutable i_DSC;

    /**
     * Events *
     */
    event collateralDeposited(address indexed sender, address indexed token, uint256 indexed amount);

    /**
     * Modifiers *
     */

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

    /**
     * Functions *
     */
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
            s_collateralTokens.push(tokenAddresses[i]);
        }

        i_DSC = DecentralizedStableCoin(dscAddress);
    }

    /**
     * External Functions *
     */

    function depositCollateralAndMintDSC() external {}

    function depositCollateral(address tokenCollateralAddress, uint256 collateralAmount)
        external
        moreThanZero(collateralAmount)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_userToCollateralDeposited[msg.sender][tokenCollateralAddress] += collateralAmount;
        emit collateralDeposited(msg.sender, tokenCollateralAddress, collateralAmount);

        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), collateralAmount);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDSC() external {}

    function redeemCollateral() external {}

    function mintDSC(uint256 amountDSCToMint) external moreThanZero(amountDSCToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDSCToMint;
        _revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnDSC() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    /**
     * Internal & private Functions *
     */
    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDSCMinted, uint256 totalCollateralInUSD)
    {
        totalDSCMinted = s_DSCMinted[user];
        totalCollateralInUSD = getAccountCollateralValue(user);

        return (totalDSCMinted, totalCollateralInUSD);
    }

    function _calcHealthFactor(address user) private view returns (uint256) {
        // We need the total DSC minted for this user
        // We also need total Collateral ***VALUE*** deposited

        (uint256 totalDSCMinted, uint256 totalCollateralInUSD) = _getAccountInformation(user);
        uint256 collateralAdjustedForThreshold = (totalCollateralInUSD * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION;

        return (collateralAdjustedForThreshold / totalDSCMinted);
    }

    function _revertIfHealthFactorIsBroken(address user) internal view {
        // We want to do a healthFactorCheck(if they have enough collateral)
        // Revert if they dont have a good healthfactor
        uint256 userHealthFactor = _calcHealthFactor(user);
        if (userHealthFactor < MIN_HEALTH_FACTOR) {
            revert DSCEngine__UserViolatesHealthFactor(userHealthFactor);
        }
    }

    function getAccountCollateralValue(address user) public view returns (uint256 totalValue) {
        // loop through each collateral token and get the equvalent USD value

        for (uint256 i = 0; i < s_collateralTokens.length; i++) {
            address token = s_collateralTokens[i];
            uint256 amount = s_userToCollateralDeposited[user][token];
            totalValue += getUSDValue(token, amount);
        }

        return totalValue;
    }

    function getUSDValue(address token, uint256 amount) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeeds[token]);
        (, int256 price,,,) = priceFeed.latestRoundData();

        return ((uint256(price) * ADDITIONAL_FEED_PRECITION) * amount) / PRECISION;
    }
}
