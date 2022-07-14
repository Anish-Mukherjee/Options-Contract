//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.13;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Options{
    using SafeMath for uint; 
    AggregatorV3Interface internal ethFeed;
    uint ethPrice;
    address payable contractAddress;

    struct Option{
        uint id;
        uint strike; //strike price
        uint premium;//premium charged by option writer
        uint amount; //amount of tokens
        uint expiry;//UNIX timestamp
        bool excercised;
        bool cancelled;
        uint latestCost;
        address payable writer;
        address payable buyer;
    }

    Option[] public ethOptions;

    constructor(){
        ethFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        contractAddress = payable(address(this));
    }

    function getEthPrice() public view returns(uint){
        (,int price,,,) = ethFeed.latestRoundData();
        return uint(price);
    }

    function updatePrice() internal{
        ethPrice = getEthPrice();
    }

    function writeOption(uint strike,uint premium,uint amount,uint expiry) public payable{
        require(msg.value == amount,"Incorrect amount of ETH supplied! PLease supply same amount of eth");
        uint latestCost = strike.mul(amount).div(ethPrice.mul(10**10));
        ethOptions.push(Option(ethOptions.length,strike,premium,amount,expiry,false,false,latestCost,payable(msg.sender),payable(address(0))));
    }

    function getOptions() public view returns(Option[] memory){
        return ethOptions;
    }


}