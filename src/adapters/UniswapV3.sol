pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../../interfaces/IUniswapV3SwapRouter.sol";
import {console} from "forge-std/console.sol";

contract UniswapV3Adapter{

    address private immutable UNISWAP_V3_ROUTER;

    constructor(address _router) public {
        UNISWAP_V3_ROUTER = _router;
    }


    function swap(
        address[] memory path,
        uint24[] memory fees,
        uint256 spentAmount,
        uint256 slippage
    ) external {
        ERC20 outgoingToken = ERC20(path[0]);
        ERC20 incomingToken = ERC20(path[path.length - 1]);
        outgoingToken.approve(UNISWAP_V3_ROUTER, spentAmount);

        bytes memory encodedPath;

        for (uint256 i; i < path.length; i++) {
            if (i != path.length - 1) {
                encodedPath = abi.encodePacked(encodedPath, path[i], fees[i]);
            } else {
                encodedPath = abi.encodePacked(encodedPath, path[i]);
            }
        }

        IUniswapV3SwapRouter.ExactInputParams memory input = IUniswapV3SwapRouter
            .ExactInputParams({
            path: encodedPath,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: spentAmount,
            amountOutMinimum: slippage
        });

        uint ret = IUniswapV3SwapRouter(UNISWAP_V3_ROUTER).exactInput(input);
    }

}
