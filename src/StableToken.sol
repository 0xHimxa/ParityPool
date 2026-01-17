//SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract StableToken is ERC20 {


error StableToken__UserBuyingAddressCantBeZero();
error StableToken__EthAmountCantBeZero();




uint256 private constant PRICISSION = 1e10;
uint256 private constant PRICE_PRICISSION = 1e18;


    constructor() ERC20("FortuneFlip", "Flip") {}


modifier ethAmountAndAddressCheckes(address user,uint256 _ethAmount){
    if(user == address(0)){
        revert StableToken__UserBuyingAddressCantBeZero();
    
    }

    if(_ethAmount == 0){
        revert StableToken__EthAmountCantBeZero();
    }

    _;



}
    function buyToken(address user, uint256 ethAmount) external{
        uint256 _amountWorth = _getandConrvetEthPrice(ethAmount);

        super._mint(user,_amountWorth);



    }


    function sellToken() external payable{


    }



function _getandConrvetEthPrice(uint256 ethAmount) internal view returns (uint256 _amountWorth){

    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

    (, int256 price, , ,) = priceFeed.latestRoundData();

 _amountWorth = ((uint256(price) * PRICISSION) * ethAmount)/PRICE_PRICISSION;







}



}


