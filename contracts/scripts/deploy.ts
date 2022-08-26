import { ethers } from "hardhat";

async function main() {
  const BrlcRewarder = await ethers.getContractFactory("BrlcRewarder");
  const brlcRewarder = await BrlcRewarder.deploy();

  await brlcRewarder.deployed();

  console.log(`BRLC Rewarder deployed to ${brlcRewarder.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
