// SPDX-License-Identifier: MIT

// This line is a compiler version requirement, it specifies that the code should be compiled with a version of solidity compiler greater than or equal to 0.8.10
pragma solidity ^0.8.10;

// This line imports the SafeMath library from OpenZeppelin, which provides a set of functions for safe arithmetic operations in Solidity
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// This line imports the FlashLoanSimpleReceiverBase contract from Aave v3, which provides an implementation of the flash loan pattern
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";

// This line imports the IERC20 interface from OpenZeppelin, which defines the standard functions for an ERC20 token
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//  our contract is named FlashLoanExample and it is inheriting a contract named FlashLoanSimpleReceiverBase which is a contract from Aave which you use to setup your contract as the receiver for the flash loan
contract FlashLoanExample is FlashLoanSimpleReceiverBase {

// This line enables the use of the functions from the imported SafeMath library for the uint data type in this contract
using SafeMath for uint;

// This line defines a new event called Log with two parameters: address 'asset' and uint 'val'
event Log(address asset, uint val);

// This line defines a constructor which takes an IPoolAddressesProvider as an input parameter.
//It calls the constructor of the imported FlashLoanSimpleReceiverBase contract with the provider as the argument
constructor(IPoolAddressesProvider provider)
FlashLoanSimpleReceiverBase(provider)
{}

//This function allows the user to create a flash loan for the provided asset and amount
//It takes in the address of the asset and the amount as its input parameters
//It sets the receiver address to the current contract's address and an empty bytes memory variable 'params' to pass arbitrary data to executeOperation function
//It sets the referralCode to zero
//It calls the flashLoanSimple function of the POOL contract with the receiver, asset, amount, params and referralCode as its input parameters
function createFlashLoan(address asset, uint amount) external {
address receiver = address(this);
// use this to pass arbitrary data to executeOperation
bytes memory params = "";
uint16 referralCode = 0;
 POOL.flashLoanSimple(
   receiver,
   asset,
   amount,
   params,
   referralCode
  );
}

//This function executes the operation of the flash loan
//It takes in five input parameters: address 'asset', uint256 'amount', uint256 'premium', address 'initiator' and bytes calldata '
function executeOperation(
address asset,
uint256 amount,
uint256 premium,
address initiator,
bytes calldata params
) external returns (bool){
// do things like arbitrage here
// abi.decode(params) to decode params
uint amountOwing = amount.add(premium);
// give approval to the Pool Contract to withdraw the amount that we owe along with some premium
IERC20(asset).approve(address(POOL), amountOwing);
emit Log(asset, amountOwing);
return true;
}
}