// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "interfaces/IWETH.sol";
import "src/Fund.sol";
import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";


// A simple fuzzing test to detect non-zero deposit fee
contract HelloForkTest is Test {

    address VITALIK = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;

    function testFork() public {
        console.log(VITALIK.balance);
    }
}
