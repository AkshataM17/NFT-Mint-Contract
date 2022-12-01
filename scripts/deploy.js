const {ethers} = require("hardhat");
const {WHITELIST_CONTRACT_ADDRESS, METADATA_URL} = require("../constants");

async function main(){

  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  const metadataURL = METADATA_URL

  const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");
  const cryptoDevsContractDeploy = await cryptoDevsContract.deploy(metadataURL, whitelistContract);

  await cryptoDevsContractDeploy.deployed();

  console.log("CryptoDev contract address is:", cryptoDevsContractDeploy.address);

}

main()
.then(() => {
  console.log("Contract successfully deployed")
  process.exit(0);
})
.catch((err) => {
  console.log(err)
  process.exit(1)
})