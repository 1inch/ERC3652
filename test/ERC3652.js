require('@openzeppelin/test-helpers');
const { expectRevert } = require('@openzeppelin/test-helpers');
const { web3 } = require('@openzeppelin/test-helpers/src/setup');
const { expect } = require('chai');

const { gasspectEVM } = require('./helpers/profileEVM');

const ERC3652 = artifacts.require('ERC3652');
const ERC3652Proxy = artifacts.require('IERC3652Proxy');
const TokenMock = artifacts.require('TokenMock');
const NFTMock = artifacts.require('NFTMock');
const TokenTransferDelegatee = artifacts.require('TokenTransferDelegatee');

describe('ERC3652', async function () {
    let w1, w2;

    before(async function () {
        [w1, w2] = await web3.eth.getAccounts();
    });

    beforeEach(async function () {
        this.nft = await NFTMock.new('Game of NTF', 'GONFT');
        this.dai = await TokenMock.new('DAI', 'DAI');
        this.factory = await ERC3652.new();
        this.tokenTransferDelegatee = await TokenTransferDelegatee.new();

        console.log('Proxy bytecode =', await this.factory.createProxyCode(this.nft.address, 123));
        console.log('Proxy bytecode length =', (await this.factory.createProxyCode(this.nft.address, 123)).length);
    });

    it.only('should work properly', async function () {
        await this.nft.mint(w1, 123);
        const proxyAddress = await this.factory.addressOf(this.nft.address, 123);
        await this.dai.mint(proxyAddress, 100);

        await this.factory.deploy(this.nft.address, 123);
        const nftProxy = await ERC3652Proxy.at(proxyAddress);

        await expectRevert.unspecified(
            nftProxy.call(this.dai.address, this.dai.contract.methods.transfer(w1, 50).encodeABI(), { from: w2 }),
        );

        // await nftProxy.call(this.dai.address, this.dai.contract.methods.transfer(w1, 50).encodeABI(), { from: w1 });

        await nftProxy.call(
            this.tokenTransferDelegatee.address,
            this.tokenTransferDelegatee.contract.methods.tokenTransfer(this.dai.address, w1, 50).encodeABI(),
            { from: w1 },
        );

        expect(await this.dai.balanceOf(nftProxy.address)).to.be.bignumber.equal('50');
        expect(await this.dai.balanceOf(w1)).to.be.bignumber.equal('50');
    });
});
