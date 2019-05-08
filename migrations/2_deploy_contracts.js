const BountyHUBToken = artifacts.require("BountyHUBToken");
const TokenTimelock = artifacts.require("TokenTimelock");

module.exports = async function(deployer) {
  deployer.deploy(BountyHUBToken);
  deployer.deploy(TokenTimelock,
    `${process.env.TRONBOX_MIGRATION_TIMELOCK_TOKEN}`,
    `${process.env.TRONBOX_MIGRATION_TIMELOCK_BENEFICIARY}`,
    `${process.env.TRONBOX_MIGRATION_TIMELOCK_START_DATE}`,
    `${process.env.TRONBOX_MIGRATION_TIMELOCK_PERIOD}`,
    `${process.env.TRONBOX_MIGRATION_TIMELOCK_COUNT}`
  );
};
