pragma solidity ^0.5.0; // pragma solidity ^0.4.11;

/*
    Bancor Formula interface
*/
contract IBancorFormula {
    function calculatePurchaseReturn(
        uint256 _supply,
        uint256 _connectorBalance,
        uint32 _connectorWeight,
        uint256 _depositAmount)
        public
        view
        returns (uint256);

    function calculateSaleReturn(
        uint256 _supply,
        uint256 _connectorBalance,
        uint32 _connectorWeight,
        uint256 _sellAmount)
        public
        view
        returns (uint256);
}