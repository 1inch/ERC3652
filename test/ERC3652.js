require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { contract } = require('hardhat');

const ERC3652Mock = artifacts.require('ERC3652Mock');
const TokenMock = artifacts.require('TokenMock');
const ImplMock = artifacts.require('ImplMock');

contract('ERC3652', async function ([_, w1, w2]) {
    beforeEach(async function () {
        this.nft = await ERC3652Mock.new('Token', 'TKN');
        this.dai = await TokenMock.new('DAI', 'DAI');
        this.impl = await ImplMock.new();
    });

    it('should be ok', async function () {
        await this.nft.mint(w1, 123);
        const nftProxy = await this.nft.addressOf(123);
        await this.dai.mint(nftProxy, 100);

        const args = {
            target: this.impl.address,
            data: this.impl.contract.methods.transferToken(this.dai.address, w1, 100).encodeABI(),
        };

        expect(await this.dai.balanceOf(nftProxy)).to.be.bignumber.equal('100');
        expect(await this.dai.balanceOf(w1)).to.be.bignumber.equal('0');
        await this.nft.callFor(123, args.target, args.data, { from: w1 });
        expect(await this.dai.balanceOf(nftProxy)).to.be.bignumber.equal('0');
        expect(await this.dai.balanceOf(w1)).to.be.bignumber.equal('100');
    });

    it('should be ok 2', async function () {
        await this.nft.mint(w1, 777);
        await this.nft.mint(w1, 888);
        await this.nft.mint(w1, 999);
    });
});
