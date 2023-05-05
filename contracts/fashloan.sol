// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    event log(address assest, uint256 val);

    constructor(IPoolAddressesProvider provider)
        FlashLoanSimpleReceiverBase(provider)
        {}

    function createFlashLoan(address asset, uint256 amount) external {
        address reciever = address(this);
        bytes memory params = ""; // use this to pass arbitray data to executeOperation
        uint16 referalCode = 0;

        POOL.flashLoanSimple(reciever, asset, amount, params, referalCode);

    } 

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator, 
        bytes calldata params
    ) external returns(bool) {
        uint256 amountOwing = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwing);
        emit log(asset, amountOwing);
        return true;
    }
}