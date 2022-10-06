const hre = require('hardhat')
const fs = require('fs-extra')

module.exports = async ({getNamedAccounts, deployments}) => {
  const {deploy} = deployments;
  const { account0 } = await getNamedAccounts();

  console.log('Deploying contracts with the account:', account0)

  console.log('------')
  console.log('network name: ', hre.network.name)
  console.log('Deployer: ' + account0)
  console.log('------')

  const token = await deploy('FamilySystemContract', {
    from: account0,
    args: [],
    log: true,
  });

  fs.mkdirSync('./export/contracts', {recursive: true})

  const deployData = {
    contractAddress: token.address,
    deployer: account0
  }
  fs.writeFileSync('./export/contracts/config.json', JSON.stringify(deployData, null, 2))

  const contractJson = require('../artifacts/contracts/FamilySystemContract.sol/FamilySystemContract.json')
  fs.writeFileSync('./export/contracts/FamilySystemContract.json', JSON.stringify(contractJson.abi, null, 2))

  console.log('deployData:', deployData)
}

module.exports.tags = ['FamilySystemContract'];
