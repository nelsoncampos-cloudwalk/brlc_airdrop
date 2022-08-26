import * as dotenv from "dotenv";
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@nomiclabs/hardhat-ethers";
import "@ericxstone/hardhat-blockscout-verify";
import { EVM_VERSION, SOLIDITY_VERSION } from "@ericxstone/hardhat-blockscout-verify";


dotenv.config();




const config: HardhatUserConfig = {
  solidity: "0.8.9",
  defaultNetwork: "cloudwalk",
  networks: {
    cloudwalk: {
      url: "https://rpc.testnet.cloudwalk.io",
      accounts: ['c8a6445ebdef4942d1acdbb1a5d549d3ab829456a1e465fa5fcab3d298977c2d']
    },
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/p3NikSpPe9tU-yfTzTc7e19fgNbx_F-y",
      accounts: ['c8a6445ebdef4942d1acdbb1a5d549d3ab829456a1e465fa5fcab3d298977c2d']
    }
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: "Y4NUXWDQNNZHESFEU7X4VC6KK3IHZBMG3Z",
  },
  blockscoutVerify: {
    blockscoutURL: "https://explorer.testnet.cloudwalk.io",
    contracts: {
      "BrlcRewarder": {
        compilerVersion: SOLIDITY_VERSION.SOLIDITY_V_8_9, // checkout enum SOLIDITY_VERSION
        optimization: true,
        evmVersion: EVM_VERSION.EVM_LONDON, // checkout enum SOLIDITY_VERSION
        optimizationRuns: 999999,
      },
    },
  },
};



export default config;
