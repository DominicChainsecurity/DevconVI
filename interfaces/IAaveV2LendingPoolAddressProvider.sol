pragma solidity 0.8.13;

interface IAaveV2LendingPoolAddressProvider {

  function getLendingPool() external view returns (address);

}
