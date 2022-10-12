pragma solidity 0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../../interfaces/IAaveV2LendingPoolAddressProvider.sol";
import "../../interfaces/IAaveV2LendingPool.sol";
import {console} from "forge-std/console.sol";

contract AaveV2Adapter{

    address private constant AAVE_LENDING_POOL_ADDRESS_PROVIDER = 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5;

    //Maybe these are useless
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant AETH = 0x3a3A65aAb0dd2A17E3F1947bA16138cd37d08c04;

    function lend(address lentAsset, uint256 lentAmount) external {

        address lendingPoolAddress = IAaveV2LendingPoolAddressProvider(
            AAVE_LENDING_POOL_ADDRESS_PROVIDER
        )
            .getLendingPool();

        ERC20(lentAsset).approve(lendingPoolAddress, lentAmount);

        IAaveV2LendingPool(lendingPoolAddress).deposit(
            lentAsset,
            lentAmount,
            address(this), //recipient
            0
        );

    }

    function withdraw(address aToken, uint aTokenAmount, address lentAsset) external {
        address lendingPoolAddress = IAaveV2LendingPoolAddressProvider(
            AAVE_LENDING_POOL_ADDRESS_PROVIDER
        )
            .getLendingPool();

        ERC20(aToken).approve(lendingPoolAddress, aTokenAmount);

        IAaveV2LendingPool(lendingPoolAddress).withdraw(
            lentAsset,
            aTokenAmount,
            address(this) //recipient
        );
    }

}
