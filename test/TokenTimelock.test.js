const TokenTimelock = artifacts.require("TokenTimelock");

const {
  BOUNTYHUB_TIMELOCK_START_DATE,
  BOUNTYHUB_FOUNDATION_TIMELOCK_COUNT,

  BOUNTYHUB_FOUNDATION_FUND,
  BOUNTYHUB_MANAGER,
  BOUNTYHUB_MANAGER_BASE58
} = process.env;

contract('TokenTimelock', function(accounts) {
  it("should be a valid beneficiary", async function() {
    await TokenTimelock.deployed();
    assert.equal(BOUNTYHUB_FOUNDATION_FUND, await TokenTimelock.beneficiary(), "Wrong beneficiary address");
  });

  it("should be a valid start time", async function() {
    await TokenTimelock.deployed();
    let startTime = await TokenTimelock.startTime();
    assert.equal(startTime, 0, "Wrong start time");
  });

  it("should be a valid calendar", async function() {
    await TokenTimelock.deployed();
    let calendar = await TokenTimelock.calendar();
    assert.equal(calendar.length, 0, "Wrong calendar length");
  });

  it("should be a valid start time init", async function() {
    await TokenTimelock.deployed();
    await TokenTimelock.startOn(BOUNTYHUB_TIMELOCK_START_DATE, {from: BOUNTYHUB_MANAGER_BASE58});
    await delay(2);
    let startTime = await TokenTimelock.startTime();
    assert.equal(BOUNTYHUB_TIMELOCK_START_DATE, startTime, "Wrong start time");
  });

  it("should be a valid calendar init", async function() {
    await TokenTimelock.deployed();
    let calendar = await TokenTimelock.calendar();
    assert.equal(BOUNTYHUB_FOUNDATION_TIMELOCK_COUNT, calendar.length, "Wrong calendar length");
  });

  it("should be a valid owner", async function() {
    await TokenTimelock.deployed();
    assert.equal(BOUNTYHUB_MANAGER, await TokenTimelock.owner(), "Wrong owner address");
  });
});

function delay(_delay) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(`Time is up`);
    }, _delay * 1000);
  })
}
