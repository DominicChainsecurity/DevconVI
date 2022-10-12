pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

interface IUniswapV3SwapRouter {
    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    function exactInput(ExactInputParams calldata) external payable returns (uint256);
}
