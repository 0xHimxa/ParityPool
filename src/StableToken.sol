//SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract StableToken is ERC20 {
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    error StableToken__UserBuyingAddressCantBeZero();
    error StableToken__EthAmountCantBeZero();
    error StableToken__BalanceIsZero();
    error StableToken__InsufficientBalance();

    /*//////////////////////////////////////////////////////////////
                           CONSTANT VARIABLES
    //////////////////////////////////////////////////////////////*/
    // Used to scale Chainlink ETH price (price feed decimals adjustment)
    uint256 private constant PRICISSION = 1e10;

    // Used to normalize ETH amount to 18 decimals
    uint256 private constant PRICE_PRICISSION = 1e18;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() ERC20("FortuneFlip", "Flip") {}

    /*//////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    // Ensures user address is valid and provided amount is not zero
    modifier ethAmountAndAddressCheckes(address user, uint256 _ethAmount) {
        if (user == address(0)) {
            revert StableToken__UserBuyingAddressCantBeZero();
        }

        if (_ethAmount == 0) {
            revert StableToken__EthAmountCantBeZero();
        }

        _;
    }

    // Ensures the user has enough token balance
    modifier checkBalanceOfUser(address user, uint256 _amount) {
        if (balanceOf(user) == 0) {
            revert StableToken__BalanceIsZero();
        }

        if (balanceOf(user) < _amount) {
            revert StableToken__InsufficientBalance();
        }

        _;
    }

    /*//////////////////////////////////////////////////////////////
                          EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // Mints tokens to the user based on ETH amount value
    function buyToken(address user, uint256 ethAmount) external ethAmountAndAddressCheckes(user, ethAmount) {
        uint256 _amountWorth = _getandConrvetEthPrice(ethAmount);

        super._mint(user, _amountWorth);
    }

    /**
     * @dev Caller must:
     * - own the tokens
     * - have approved this contract to spend them
     */
    function sellToken(address caller, uint256 amount)
        external
        ethAmountAndAddressCheckes(caller, amount)
        checkBalanceOfUser(caller, amount)
        returns (bool)
    {
        // Burns the specified amount of tokens
        _burn(caller, amount);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                         INTERNAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    // Converts ETH amount to token amount using Chainlink ETH/USD price feed
    function _getandConrvetEthPrice(uint256 ethAmount) internal view returns (uint256 _amountWorth) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        (, int256 price,,,) = priceFeed.latestRoundData();

        _amountWorth = ((uint256(price) * PRICISSION) * ethAmount) / PRICE_PRICISSION;
    }
}
