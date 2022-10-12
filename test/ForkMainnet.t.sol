// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "interfaces/IWETH.sol";
import "src/Fund.sol";
import "forge-std/Test.sol";
import "src/adapters/Synthetix.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract ForkMainnetTests is Test {

    using SafeERC20 for ERC20;

    Fund fund;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint UNIT = 10**18;

    address USDT_OWNER = address(0x5041ed759Dd4aFc3a72b8192C143F72f4724081A); 
    address USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    
    address USDETH_PRICEFEED = address(0x614715d2Af89E6EC99A233818275142cE88d1Cfd);

    address deployer = address(2);
    address alice = address(3);
    address bob = address(4);
    address weth;


    function setUp() public {
        weth = WETH;

        vm.deal(deployer, UNIT);

        vm.startPrank(deployer);

        //Deploy fund
        fund = new Fund("TestFund", "TST", WETH);
        fund.modifyPriceFeeds(USDT, USDETH_PRICEFEED);
        fund.addToken(USDT);

        IWETH(weth).deposit{value: UNIT}();
        IWETH(weth).approve(address(fund), UNIT);
        fund.deposit(UNIT);

        vm.stopPrank();

        // alice deposit and approve 1 eth to weth
        vm.startPrank(alice);
        IWETH(weth).deposit{value: UNIT}();
        IWETH(weth).approve(address(fund), UNIT);
        vm.stopPrank();

        // bob deposit and approve 1 eth to weth
        vm.startPrank(bob);
        IWETH(weth).deposit{value: UNIT}();
        IWETH(weth).approve(address(fund), UNIT);   
        vm.stopPrank();

        vm.prank(USDT_OWNER);
        ERC20(USDT).safeTransfer(address(fund), UNIT/10**12);
    }

    function testUSDT() public {
        // Your code goes here
    }

    function testWithdrawal() public {
        //prepare call
        string memory sUSD = "sUSD";
        string memory sETH = "sETH";
        bytes memory data = abi.encodeWithSelector(SynthetixAdapter.exchange.selector, sUSD, UNIT, sETH);

        //Your code goes here...
    }
}
