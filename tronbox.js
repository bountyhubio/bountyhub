module.exports = {
  networks: {
    development: {
      from: `${process.env.TRONBOX_FROM}`,
      privateKey: `${process.env.TRONBOX_PRIVATE_KEY}`,
      consume_user_resource_percent: 30,
      fee_limit: 100000000,
      fullNode: "https://api.shasta.trongrid.io",
      solidityNode: "https://api.shasta.trongrid.io",
      eventServer: "https://api.shasta.trongrid.io",
      network_id: "*" // Match any network id
    }
  }
};
