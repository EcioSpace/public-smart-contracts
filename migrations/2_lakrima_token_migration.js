const LakrimaToken = artifacts.require("LakrimaToken");

module.exports = function (deployer) {
  deployer.deploy(LakrimaToken);
};
