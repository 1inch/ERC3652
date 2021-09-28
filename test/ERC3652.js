require('@openzeppelin/test-helpers');
const { expect } = require('chai');

const ERC3652Mock = artifacts.require('ERC3652Mock');
const ERC3652Deployer = artifacts.require('ERC3652Deployer');
const ERC3652Proxy = artifacts.require('ERC3652Proxy');
const TokenMock = artifacts.require('TokenMock');
const ImplMock = artifacts.require('ImplMock');

describe('ERC3652', async function () {
    let w1;

    before(async function () {
        [w1] = await web3.eth.getAccounts();
    });

    beforeEach(async function () {
        this.deployer = await ERC3652Deployer.new();
        this.dai = await TokenMock.new('DAI', 'DAI');
        this.nft = await ERC3652Mock.new('Token', 'TKN', this.deployer.address);
        this.impl = await ImplMock.new();
    });

    it('should be ok', async function () {
        await this.nft.mint(w1, 123);
        const proxy = await ERC3652Proxy.at(await this.nft.addressOf(123));
        expect(await proxy.owner()).to.be.equal(w1);

        await this.nft.contract.methods.addressOf(123).send({ from: w1 });
    });

    it('should be ok 2', async function () {
        await this.nft.mint(w1, 777);
        await this.nft.mint(w1, 888);
        await this.nft.mint(w1, 999);
    });

    it('should be ok 3', async function () {
        await this.nft.mint(w1, 123);
        const proxy = await ERC3652Proxy.at(await this.nft.addressOf(123));
        await this.dai.mint(proxy.address, 100);

        const args = {
            target: this.impl.address,
            data: this.impl.contract.methods.transferToken(this.dai.address, w1, 100).encodeABI(),
        };

        expect(await this.dai.balanceOf(proxy.address)).to.be.bignumber.equal('100');
        expect(await this.dai.balanceOf(w1)).to.be.bignumber.equal('0');
        const receipt = await proxy.execute(args.target, args.data, { from: w1 });
        console.log('Gas Used:', receipt.receipt.gasUsed);
        expect(await this.dai.balanceOf(proxy.address)).to.be.bignumber.equal('0');
        expect(await this.dai.balanceOf(w1)).to.be.bignumber.equal('100');
    });
});
