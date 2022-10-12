pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "interfaces/IChainLinkAggregatorV3.sol";
import "interfaces/IDelegateApprovals.sol";
import {console} from "forge-std/console.sol";

interface IFund is ERC20, Ownable{

    function addToken(address token) external;

    function removeToken(address token) external;

    function modifyRegistry(address adapter, bool value) external;

    function modifyPriceFeeds(address token, address priceFeed) external;

    function estimate() view public returns (uint256){

    function pricePerShare() view external returns (uint);

    function deposit(uint amount) external;

    function withdraw(uint sharesAmount) external;

    function manage(address outToken, uint amount, address inToken, address target, bytes calldata data) external;

}

