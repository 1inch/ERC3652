const { expect } = require('chai');

const ERC3652Mock = artifacts.require('ERC3652Mock');
const ERC3652Deployer = artifacts.require('ERC3652Deployer');
const ERC3652Proxy = artifacts.require('ERC3652Proxy');

describe('ERC3652', async function () {
    let w1;

    before(async function () {
        [w1] = await web3.eth.getAccounts();
    });

    beforeEach(async function () {
        this.deployer = await ERC3652Deployer.new();
        this.nft = await ERC3652Mock.new('Token', 'TKN', this.deployer.address);
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
});
