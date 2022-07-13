const hre = require("hardhat");

const main = async () => {
  const optionsFactory = await hre.ethers.getContractFactory("Options");
  const options = await optionsFactory.deploy();
  await options.deployed();

  console.log("Options contract deployed at : ", options.address);

  const price = await options.getLatestPrice();
  console.log("The latest Eth price in USD is :", price.toNumber());
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

runMain();
