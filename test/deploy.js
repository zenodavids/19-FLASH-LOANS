// import chai and its properties expect and assert.
const { expect, assert } = require('chai')

// import BigNumber from the ethers package.
const { BigNumber } = require('ethers')

// import ethers, waffle and artifacts from the hardhat package.
const { ethers, waffle, artifacts } = require('hardhat')

// import hardhat package
const hre = require('hardhat')

// import constants DAI, DAI_WHALE, POOL_ADDRESS_PROVIDER from the config file.
const { DAI, DAI_WHALE, POOL_ADDRESS_PROVIDER } = require('../config')

// describe block to group related tests.
describe('Deploy a Flash Loan', function () {
  // it block defines a test case with a string describing the test.
  it('Should take a flash loan and be able to return it', async function () {
    // get the contract factory of the contract named FlashLoanExample.
    const flashLoanExample = await ethers.getContractFactory('FlashLoanExample')

    // deploy the contract by passing the address of the PoolAddressProvider
    const _flashLoanExample = await flashLoanExample.deploy(
      POOL_ADDRESS_PROVIDER
    )
    // wait for the contract to be deployed
    await _flashLoanExample.deployed()

    // get the contract instance of DAI token.
    const token = await ethers.getContractAt('IERC20', DAI)

    // parse 2000 ether to wei.
    const BALANCE_AMOUNT_DAI = ethers.utils.parseEther('2000')

    // impersonates the DAI_WHALE account
    await hre.network.provider.request({
      method: 'hardhat_impersonateAccount',
      params: [DAI_WHALE],
    })
    // get the signer for the DAI_WHALE account
    const signer = await ethers.getSigner(DAI_WHALE)

    await token

      // connect to the token contract with the DAI_WHALE signer
      .connect(signer)

      // transfer 2000 DAI to the FlashLoanExample contract.
      .transfer(_flashLoanExample.address, BALANCE_AMOUNT_DAI)

    // call createFlashLoan function on the FlashLoanExample contract and borrow 1000 DAI
    const tx = await _flashLoanExample.createFlashLoan(DAI, 1000)

    // wait for the transaction to complete
    await tx.wait()

    // get the remaining balance of DAI in the FlashLoanExample contract.
    const remainingBalance = await token.balanceOf(_flashLoanExample.address)

    // check if remaining balance is less than 2000 DAI.
    expect(remainingBalance.lt(BALANCE_AMOUNT_DAI)).to.be.true
  })
})
