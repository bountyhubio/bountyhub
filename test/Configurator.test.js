const Configurator = artifacts.require("Configurator");
const BountyHUBToken = artifacts.require("BountyHUBToken");

const {
  BOUNTYHUB_PLATFORM_LAUNCH_FUND,
  BOUNTYHUB_MARKETING_AND_AIRDROPS_FUND,
  BOUNTYHUB_TEAM_FUND,
  BOUNTYHUB_FOUNDATION_FUND,
  BOUNTYHUB_LAUNCHPAD_SALE_FUND,
  BOUNTYHUB_ECOSYSTEM_FUND,
  BOUNTYHUB_PLATFORM_REWARDS_FUND,

  BOUNTYHUB_MANAGER,

  PLATFORM_LAUNCH_PERCENTAGE,
  MARKETING_AND_AIRDROPS_PERCENTAGE,
  TEAM_PERCENTAGE,
  FOUNDATION_PERCENTAGE,
  LAUNCHPAD_SALE_PERCENTAGE,
  ECOSYSTEM_PERCENTAGE,
  PLATFORM_REWARDS_PERCENTAGE,

  PLATFORM_LAUNCH_ALLOCATION,
  MARKETING_AND_AIRDROPS_ALLOCATION,
  TEAM_ALLOCATION,
  FOUNDATION_ALLOCATION,
  LAUNCHPAD_SALE_ALLOCATION,
  ECOSYSTEM_ALLOCATION,
  PLATFORM_REWARDS_ALLOCATION
} = process.env;

contract('Configurator', function(accounts) {
  it("should be a valid manager", async function() {
    await Configurator.deployed();
		assert.equal(BOUNTYHUB_MANAGER, await Configurator.manager(), "Wrong manager address");
  });

  it("should be a valid funds", async function() {
    await Configurator.deployed();

    assert.equal(BOUNTYHUB_PLATFORM_LAUNCH_FUND,        await Configurator.platformLaunchFund(),       "Wrong platform launch fund address");
    assert.equal(BOUNTYHUB_MARKETING_AND_AIRDROPS_FUND, await Configurator.marketingAndAirdropsFund(), "Wrong marketing & airdrops fund address");
    assert.equal(BOUNTYHUB_TEAM_FUND,                   await Configurator.teamFund(),                 "Wrong team fund address");
    assert.equal(BOUNTYHUB_FOUNDATION_FUND,             await Configurator.foundationFund(),           "Wrong foundation fund address");
    assert.equal(BOUNTYHUB_LAUNCHPAD_SALE_FUND,         await Configurator.launchpadSaleFund(),        "Wrong launchpad sale fund address");
    assert.equal(BOUNTYHUB_ECOSYSTEM_FUND,              await Configurator.ecosystemFund(),            "Wrong ecosystem fund address");
    assert.equal(BOUNTYHUB_PLATFORM_REWARDS_FUND,       await Configurator.platformRewardsFund(),      "Wrong platform rewards fund address");
  });

  it("should be a valid percentages", async function() {
    await Configurator.deployed();

		assert.equal(PLATFORM_LAUNCH_PERCENTAGE,        await Configurator.platformLaunchPercentage(),       "Wrong platform launch percentage");
		assert.equal(MARKETING_AND_AIRDROPS_PERCENTAGE, await Configurator.marketingAndAirdropsPercentage(), "Wrong marketing & airdrops percentage");
		assert.equal(TEAM_PERCENTAGE,                   await Configurator.teamPercentage(),                 "Wrong team percentage");
		assert.equal(FOUNDATION_PERCENTAGE,             await Configurator.foundationPercentage(),           "Wrong foundation percentage");
		assert.equal(LAUNCHPAD_SALE_PERCENTAGE,         await Configurator.launchpadSalePercentage(),        "Wrong launchpad sale percentage");
		assert.equal(ECOSYSTEM_PERCENTAGE,              await Configurator.ecosystemPercentage(),            "Wrong ecosystem percentage");
		assert.equal(PLATFORM_REWARDS_PERCENTAGE,       await Configurator.platformRewardsPercentage(),      "Wrong platform rewards percentage");
  });

  it("should be the token totally supplied", async function() {
    await BountyHUBToken.deployed();
    
    assert.equal((await BountyHUBToken.totalSupply()).toString(), (await BountyHUBToken.cap()).toString(), "Wrong supply");
  });

  it("should be the token allocated", async function() {
    await BountyHUBToken.deployed();
    await Configurator.deployed();

    let teamTimelockAddress = await Configurator.teamTimelock();
    let foundationTimelockAddress = await Configurator.foundationTimelock();

    let unit = 10 ** await BountyHUBToken.decimals();

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_PLATFORM_LAUNCH_FUND) / unit).toString(),
      PLATFORM_LAUNCH_ALLOCATION.toString(), "Wrong platform lounch allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_MARKETING_AND_AIRDROPS_FUND) / unit).toString(),
      MARKETING_AND_AIRDROPS_ALLOCATION.toString(), "Wrong marketing & airdrops allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_TEAM_FUND) / unit).toString(),
      "0", "Wrong team allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(teamTimelockAddress) / unit).toString(),
      TEAM_ALLOCATION.toString(), "Wrong team allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_FOUNDATION_FUND) / unit).toString(),
      "0", "Wrong foundation allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(foundationTimelockAddress) / unit).toString(),
      FOUNDATION_ALLOCATION.toString(), "Wrong foundation allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_LAUNCHPAD_SALE_FUND) / unit).toString(),
      LAUNCHPAD_SALE_ALLOCATION.toString(), "Wrong launchpad sale allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_ECOSYSTEM_FUND) / unit).toString(),
      ECOSYSTEM_ALLOCATION.toString(), "Wrong ecosystem allocation"
    );

    assert.equal(
      (await BountyHUBToken.balanceOf(BOUNTYHUB_PLATFORM_REWARDS_FUND) / unit).toString(),
      PLATFORM_REWARDS_ALLOCATION.toString(), "Wrong platform rewards allocation"
    );
  });
});
