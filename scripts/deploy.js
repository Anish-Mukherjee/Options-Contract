const hre = require("hardhat");

const main = async () => {
  const optionsFactory = await hre.ethers.getContractFactory("Options");
  const options = await optionsFactory.deploy();
  await options.deployed();

  console.log("Options contract deployed at : ", options.address);

  const ethPrice = await options.getEthPrice();
  console.log("The current eth price is : ", ethPrice.toNumber());

  await options.writeOption(
    800,
    80,
    hre.ethers.utils.parseEther("0.1"),
    1658292186,
    { value: hre.ethers.utils.parseEther("0.1"), gasLimit: 300000 }
  );

  let optionsArray = await options.getOptions();
  console.log(optionsArray);
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
