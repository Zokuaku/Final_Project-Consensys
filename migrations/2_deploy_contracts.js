var Store = artifacts.require("./Store.sol");
var NewProduct = artifacts.require("./NewProduct.sol");
var TotalMarketplace = artifacts.require("./TotalMarketplace.sol");

module.exports = function(deployer) {
  deployer.deploy(Store);
  deployer.deploy(NewProduct);
  deployer.deploy(TotalMarketplace);
}
