const { expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const { contract } = require('hardhat');

const ERC3652Mock = artifacts.require('ERC3652Mock');
const ERC3652Proxy = artifacts.require('ERC3652Proxy');

contract('ERC3652', async function ([_, w1, w2]) {
    beforeEach(async function () {
        this.contract = await ERC3652Mock.new("Token", "TKN");
    });

    it('should be ok', async function () {
        await this.contract.mint(w1, 123);
        const proxy = await ERC3652Proxy.at(await this.contract.addressOf(123));
        expect(await proxy.owner()).to.be.equal(w1);
    });
});
