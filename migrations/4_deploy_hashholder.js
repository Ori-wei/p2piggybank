const HashHolder = artifacts.require("HashHolder");

module.exports = function (deployer) {
  deployer.deploy(HashHolder);
};
