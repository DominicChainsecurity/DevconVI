pragma solidity 0.8.13;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
    function balanceOf(address who) external view  returns (uint256);
    function approve(address _spender, uint256 _value) external returns (bool success);
}
