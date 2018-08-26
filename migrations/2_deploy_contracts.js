var Adoption = artifacts.require("./Adoption.sol");
var Store = artifacts.require("./Store.sol");
var StoreOwner = artifacts.require("./StoreOwner.sol");
var Administrator = artifacts.require("./Administrator.sol");
var Product = artifacts.require("./Product.sol");

module.exports = function(deployer) {
  deployer.deploy(Adoption);
  deployer.deploy(Store);
  deployer.deploy(StoreOwner);
  deployer.deploy(Administrator);
  deployer.deploy(Product);
}
