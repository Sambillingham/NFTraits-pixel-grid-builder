// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const TraitsFactory = await hre.ethers.getContractFactory("Storage");
  const traits = await TraitsFactory.deploy();

  await traits.deployed();

  console.log("Traits -> deployed to:", traits.address);
  await traits.run()


  const svgF = await hre.ethers.getContractFactory("Svg");
  const s = await svgF.deploy();

  await s.deployed();

  console.log("S -> deployed to:", s.address);
  await s.run()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
