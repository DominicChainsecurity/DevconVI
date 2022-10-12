pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "interfaces/IChainLinkAggregatorV3.sol";
import {console} from "forge-std/console.sol";

contract Fund is ERC20, Ownable{

    mapping(address=>bool) isToken;
    address[] tokens;

    mapping(address=>address) priceFeeds;

    uint256 constant UNIT = 10**18;

    uint constant public FEE = 300;
    uint constant public BPS = 10000;

    address immutable denominationAsset;

    constructor(string memory _name, string memory _symbol, address _denominationAsset) ERC20(_name, _symbol){
        denominationAsset = _denominationAsset;
        _addToken(address(denominationAsset));
    }


    /// @notice Adds a token to be tracked by the fund
    /// @param _token The token's address
    function addToken(address _token) external onlyOwner{
            _addToken(_token);
    }

    function _addToken(address _token) internal{
        isToken[_token] = true;
        tokens.push(_token);
    }

    /// @notice Removes a tracked token
    /// @param _token The token's address
    function removeToken(address _token) external onlyOwner{
        isToken[_token] = false;
        for(uint i=0; i<tokens.length; i++){
            if (tokens[i] == _token){
                if(i != (tokens.length - 1)) {
                    tokens[i] = tokens[tokens.length - 1];
                }
                tokens.pop();
                break;
            }
        }
    }


    function modifyPriceFeeds(address _token, address _priceFeed) external onlyOwner{
        priceFeeds[_token] = _priceFeed;
    }

    /// @notice Mints funds shares for a user, proportional to their contribution to the fund
    /// @param _amount The amount of the denominationAsset to contribute
    function deposit(uint _amount) external{
        ERC20(denominationAsset).transferFrom(msg.sender, address(this), _amount);
        uint totalValue = estimate();

        if (totalSupply() == 0){
            _mint(msg.sender, UNIT);
            _mint(owner(), UNIT / 10);
        } else {
            uint amountToMint = totalSupply() * _amount / totalValue;
            uint fees = amountToMint * FEE / BPS;
            _mint(msg.sender, amountToMint-fees);
            _mint(owner(), fees);
        }
    }

    /// @notice Burns the shares of a user and transfers back to them a portion of all the tokens the fund holds
    /// @param _sharesAmount The amount of the shares to burn
    function withdraw(uint _sharesAmount) external{
       uint proportion = _sharesAmount * UNIT / totalSupply();
       for(uint i = 0; i< tokens.length; i++){
           console.log("Transfering", tokens[i]);
           address token = tokens[i];
           uint amountToWithdraw = ERC20(token).balanceOf(address(this)) * proportion / UNIT;
           ERC20(tokens[i]).transfer(msg.sender, amountToWithdraw);
       }
       _burn(msg.sender, _sharesAmount);
    }

    /// @notice Allows the manager to interact with an external protocol through an adapter
    /// @param _outToken the token to spend
    /// @param _amount the amount of outToken to spend
    /// @param _inToken the token to receive
    /// @param _target the address of the adapter. Must be whitelisted
    /// @param _data the data for the call to the adapter
    function manage(address _outToken, uint _amount, address _inToken, address _target, bytes calldata _data) external onlyOwner {

        uint valueBefore = estimate();

        (bool success, bytes memory data) = address(_target).delegatecall(_data);
        require(success);

        isToken[_inToken] = true;
        require(_inToken == denominationAsset || priceFeeds[_inToken] != address(0), "No price feed");

        tokens.push(_inToken);

        uint valueAfter = estimate();

        require(10000*valueAfter >= 9000*valueBefore , "Value changed");
    }


    /// @notice Estimates the total value of the fund in the denominationAsset
    function estimate() view public returns (uint256){
        uint totalValue = 0;
        for(uint i = 0; i< tokens.length; i++){
            uint tokenBalance = ERC20(tokens[i]).balanceOf(address(this));
            uint value = _estimate(tokens[i], tokenBalance);
            totalValue += value;
        }
        return totalValue;
    }

    function _estimate(address _token, uint _amount) view internal returns (uint256){
        if(_token == address(denominationAsset)){
            return _amount;
        }

        int256 rate;
        uint256 rateUpdatedAt;

        IChainLinkAggregatorV3 aggregator = IChainLinkAggregatorV3(priceFeeds[_token]);

        (, rate, , , ) = IChainLinkAggregatorV3(aggregator).latestRoundData();

        //Decimals 
        require(rate >= 0, "0 rate");
        return uint(rate)*_amount;
    }

    /// @notice Estimates the value per share of the fund
    function pricePerShare() view external returns (uint){
        uint totalValue = estimate();
        return totalValue / totalSupply();
    }


}

