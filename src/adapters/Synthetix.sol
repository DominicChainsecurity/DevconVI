pragma solidity 0.8.13;


import "../../interfaces/ISynthetix.sol";

interface ISynthetixAdapter {
    function exchange(
        string memory sourceCurrency, 
        uint sourceAmount,
        string memory destinationCurrency
    ) external returns (uint amountReceived);

    function stringToBytes32(string memory source) external pure returns (bytes32 result);
}

contract SynthetixAdapter is ISynthetixAdapter {

    ISynthetix private immutable synthetix;
    //mapping(string => bool) tokenExist;
    address constant SYNTHETIX = 0x08F30Ecf2C15A783083ab9D5b9211c22388d0564;
    error NonExistingToken();

    constructor() public {
        synthetix = ISynthetix(SYNTHETIX);
    }

    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function exchange(
        string memory sourceCurrency, 
        uint sourceAmount,
        string memory destinationCurrency
    ) external returns (uint amountReceived) {
        
        bytes32 sourceCurrencyKey = stringToBytes32(sourceCurrency);
        bytes32 destinationCurrencyKey = stringToBytes32(destinationCurrency);

        return synthetix.exchange(sourceCurrencyKey, sourceAmount, destinationCurrencyKey);
    }

}
