const BountyHUBToken = artifacts.require("BountyHUBToken");

const {
  BOUNTYHUB_TOKEN_NAME,
  BOUNTYHUB_TOKEN_SYMBOL,
  BOUNTYHUB_TOKEN_DECIMALS,
  BOUNTYHUB_TOKEN_CAP,
  BOUNTYHUB_MANAGER
} = process.env;

contract('BountyHUBToken', function(accounts) {

  // Tronbox name bug
  /*it("should be a valid name", async function() {
    await BountyHUBToken.deployed();
		assert.equal(BOUNTYHUB_TOKEN_NAME, await BountyHUBToken.name(), "Wrong token name");
  });*/

  it("should be a valid symbol", async function() {
    await BountyHUBToken.deployed();
		assert.equal(BOUNTYHUB_TOKEN_SYMBOL, await BountyHUBToken.symbol(), "Wrong token symbol");
  });

  it("should be a valid decimals", async function() {
    await BountyHUBToken.deployed();
		assert.equal(BOUNTYHUB_TOKEN_DECIMALS, await BountyHUBToken.decimals(), "Wrong token decimals");
  });

  it("should be a valid cap", async function() {
    await BountyHUBToken.deployed();
		assert.equal(BOUNTYHUB_TOKEN_CAP * (10 ** BOUNTYHUB_TOKEN_DECIMALS), await BountyHUBToken.cap(), "Wrong token cap");
  });

  it("should be a valid owner", async function() {
    await BountyHUBToken.deployed();
		assert.equal(BOUNTYHUB_MANAGER, await BountyHUBToken.owner(), "Wrong owner address");
  });
});
