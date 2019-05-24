const BountyHUBToken = artifacts.require("BountyHUBToken");
const TokenTimelock = artifacts.require("TokenTimelock");

const Configurator = artifacts.require("Configurator");

const {
  BOUNTYHUB_TOKEN_NAME,
  BOUNTYHUB_TOKEN_SYMBOL,
  BOUNTYHUB_TOKEN_DECIMALS,
  BOUNTYHUB_TOKEN_CAP,

  // BOUNTYHUB_TIMELOCK_START_DATE,
  BOUNTYHUB_TIMELOCK_PERIOD,
  BOUNTYHUB_TEAM_TIMELOCK_COUNT,
  BOUNTYHUB_FOUNDATION_TIMELOCK_COUNT,

  BOUNTYHUB_PLATFORM_LAUNCH_FUND,
  BOUNTYHUB_MARKETING_AND_AIRDROPS_FUND,
  BOUNTYHUB_TEAM_FUND,
  BOUNTYHUB_FOUNDATION_FUND,
  BOUNTYHUB_LAUNCHPAD_SALE_FUND,
  BOUNTYHUB_ECOSYSTEM_FUND,
  BOUNTYHUB_PLATFORM_REWARDS_FUND,
  BOUNTYHUB_MANAGER
} = process.env;

const GAP = ` `.repeat(4);
const DELAY = 5;

let teamTimelockAddress;
let foundationTimelockAddress;

let teamTimelockOwnerAddress;
let foundationTimelockOwnerAddress;

let teamTimelockFundAddress;
let foundationTimelockFundAddress;

let teamTimelockTokenAddress;
let foundationTimelockTokenAddress;

let teamCalendar;
let foundationCalendar;

let deployTx;
module.exports = function(deployer) {
  deployer.then(async () => {
    try {
      let result/* = await deployer*/;

      result = await deployer.deploy(BountyHUBToken,
        BOUNTYHUB_TOKEN_NAME,
        BOUNTYHUB_TOKEN_SYMBOL,
        BOUNTYHUB_TOKEN_DECIMALS,
        BOUNTYHUB_TOKEN_CAP
        /*, {overwrite: false}*/
      );

      result = await delay();
      result = await BountyHUBToken.deployed();
      result = await BountyHUBToken.transferOwnership(BOUNTYHUB_MANAGER);
      console.log(`${GAP}| BountyHUBToken transfer ownership tx: ${result}\n`);

      console.log(`${GAP}| Create Team TimeLock`);
      result = await deployer.deploy(TokenTimelock,
        BountyHUBToken.address,
        BOUNTYHUB_TEAM_FUND,
        BOUNTYHUB_TIMELOCK_PERIOD,
        BOUNTYHUB_TEAM_TIMELOCK_COUNT
      );
      result = await delay();
      result = await TokenTimelock.deployed();

      report(`| New team 'TokenTimelock'`, TokenTimelock);

      result = await TokenTimelock.transferOwnership(BOUNTYHUB_MANAGER);
      console.log(`${GAP}| Team TokenTimelock transfer ownership tx: ${result}\n`);

      teamCalendar = await TokenTimelock.calendar();
      teamTimelockAddress = TokenTimelock.address;
      teamTimelockOwnerAddress = await TokenTimelock.owner.call();
      teamTimelockFundAddress = await TokenTimelock.beneficiary.call();
      teamTimelockTokenAddress = await TokenTimelock.token.call();

      console.log(`${GAP}| Create Foundation TimeLock`);
      result = await deployer.deploy(TokenTimelock,
        BountyHUBToken.address,
        BOUNTYHUB_FOUNDATION_FUND,
        BOUNTYHUB_TIMELOCK_PERIOD,
        BOUNTYHUB_FOUNDATION_TIMELOCK_COUNT
      );
      result = await delay();
      result = await TokenTimelock.deployed();

      report(`| New foundation 'TokenTimelock'`, TokenTimelock);

      result = await TokenTimelock.transferOwnership(BOUNTYHUB_MANAGER);
      console.log(`${GAP}| Foundation TokenTimelock transfer ownership tx: ${result}\n`);

      foundationCalendar = await TokenTimelock.calendar();
      foundationTimelockAddress = TokenTimelock.address;
      foundationTimelockOwnerAddress = await TokenTimelock.owner.call();
      foundationTimelockFundAddress = await TokenTimelock.beneficiary.call();
      foundationTimelockTokenAddress = await TokenTimelock.token.call();

      result = await deployer.deploy(Configurator,
        BountyHUBToken.address,
        teamTimelockAddress,
        foundationTimelockAddress,
        BOUNTYHUB_PLATFORM_LAUNCH_FUND,
        BOUNTYHUB_MARKETING_AND_AIRDROPS_FUND,
        BOUNTYHUB_TEAM_FUND,
        BOUNTYHUB_FOUNDATION_FUND,
        BOUNTYHUB_LAUNCHPAD_SALE_FUND,
        BOUNTYHUB_ECOSYSTEM_FUND,
        BOUNTYHUB_PLATFORM_REWARDS_FUND,
        BOUNTYHUB_MANAGER
      );
      deployTx = result;
      result = await delay();

      result = await Configurator.deployed();
      result = await BountyHUBToken.addMinter(Configurator.address);

      console.log(`${GAP}| Call Configurator deploy...`);
      result = await Configurator.deploy();
      result = await delay();

      let teamPeriods = ``;
      for (var i = teamCalendar.length - 1; i >= 0; i--) {
        teamPeriods += `| ${new Date(teamCalendar[i].toNumber() * 1000).toISOString()}\n          `;
      }

      let foundationPeriods = ``;
      for (var i = foundationCalendar.length - 1; i >= 0; i--) {
        foundationPeriods += `| ${new Date(foundationCalendar[i].toNumber() * 1000).toISOString()}\n          `;
      }

      let platformLaunchFund = await Configurator.platformLaunchFund.call();
      let marketingAndAirdropsFund = await Configurator.marketingAndAirdropsFund.call();
      let teamFund = await Configurator.teamFund.call();
      let foundationFund = await Configurator.foundationFund.call();
      let launchpadSaleFund = await Configurator.launchpadSaleFund.call();
      let ecosystemFund = await Configurator.ecosystemFund.call();
      let platformRewardsFund = await Configurator.platformRewardsFund.call();

      let symbol = await BountyHUBToken.symbol.call();
      let unit = 10 ** await BountyHUBToken.decimals.call();
      let summury = `
        ==================================================================================
        Deployment summary:
        ==================================================================================

        Team:
        --------------------------------------------------------------
          Timelock address: ${teamTimelockAddress} (${await BountyHUBToken.balanceOf(teamTimelockAddress) / unit} ${symbol})
             Token address: ${teamTimelockTokenAddress}
             Owner address: ${teamTimelockOwnerAddress}
              Fund address: ${teamTimelockFundAddress}
          Vesting period [ISO 8601]: ${teamCalendar.length === 0 ? 'not started yet' : ''}
          --------------------------
          ${teamPeriods}

        Foundation:
        --------------------------------------------------------------
          Timelock address: ${foundationTimelockAddress} (${await BountyHUBToken.balanceOf.call(foundationTimelockAddress) / unit} ${symbol})
             Token address: ${foundationTimelockTokenAddress}
             Owner address: ${foundationTimelockOwnerAddress}
              Fund address: ${foundationTimelockFundAddress}
          Vesting period [ISO 8601]: ${foundationCalendar.length === 0 ? 'not started yet' : ''}
          --------------------------
          ${foundationPeriods}

        Funds/Pools:
        ------------------------------------------------------------------
          Platform Launch:      ${platformLaunchFund} (${await BountyHUBToken.balanceOf.call(platformLaunchFund) / unit} ${symbol})
          Marketing & Airdrops: ${marketingAndAirdropsFund} (${await BountyHUBToken.balanceOf.call(marketingAndAirdropsFund) / unit} ${symbol})
          Team:                 ${teamFund} (${await BountyHUBToken.balanceOf.call(teamFund) / unit} ${symbol})
          Foundation:           ${foundationFund} (${await BountyHUBToken.balanceOf.call(foundationFund) / unit} ${symbol})
          Launchpad Sale:       ${launchpadSaleFund} (${await BountyHUBToken.balanceOf.call(launchpadSaleFund) / unit} ${symbol})
          Ecosystem:            ${ecosystemFund} (${await BountyHUBToken.balanceOf.call(ecosystemFund) / unit} ${symbol})
          Platform Rewards:     ${platformRewardsFund} (${await BountyHUBToken.balanceOf.call(platformRewardsFund) / unit} ${symbol})


        Token:
        -----------------------------------------------------
          Address: ${BountyHUBToken.address}
            Owner: ${await BountyHUBToken.owner.call()}
           Supply: ${await BountyHUBToken.totalSupply.call() / unit} ${symbol}
              Cap: ${await BountyHUBToken.cap.call() / unit} ${symbol}

        Manager:
        -------------------------------------------------------
          Address: : ${ await Configurator.manager.call()}

        ==================================================================================`;

      console.log(summury);
    } catch (error) {
      console.log(error);
    }
  })
  .catch((error) => {
    console.log(error);
  });
};

function report(message, data) {
  let output = "";

  output +=
    `    ${message}\n` +
    `    ${`-`.repeat(message.length)}\n` +
    `    > ${"contract address:".padEnd(20)} ${data.address}\n`/* +
    `    > ${"transaction hash:".padEnd(20)} ${data.transactionHash}\n`*/;

  console.log(output);
}

function delay() {
  return new Promise((resolve, reject) => {
    console.log(`    | Waiting for ${DELAY} sec...\n`);
    setTimeout(() => {
      resolve(`Time is up`);
    }, DELAY * 1000);
  })
}
