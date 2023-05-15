require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-truffle5');
require('dotenv').config();
require('hardhat-deploy');
require('hardhat-gas-reporter');
require('solidity-coverage');
require("hardhat-tracer");

const networks = require('./hardhat.networks');

module.exports = {
    etherscan: {
        apiKey: process.env.ETHERSCAN_KEY,
    },
    gasReporter: {
        enable: true,
        currency: 'USD',
    },
    solidity: {
        version: '0.8.20',
        settings: {
            optimizer: {
                enabled: true,
                runs: 1000000,
            },
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
    tracer: {
        enableAllOpcodes: true,
    },
    networks,
};
