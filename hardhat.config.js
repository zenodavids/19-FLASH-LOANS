require('@nomicfoundation/hardhat-toolbox')

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.10',
  networks: {
    hardhat: {
      forking: {
        url: 'https://polygon-bor.publicnode.com',
      },
    },
  },
}
