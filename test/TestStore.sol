pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Store.sol";

contract TestStore{
  Store store = Store(DeployedAddresses.Store());

  //function testSettingAnOwnerDuringCreation() public {
  //  Assert.equal(store.owner(), this, "An owner is different than a deployer");
  //}

  function testInsertProd() public {
    store.insertProd("Red Shirt", 15, 5);
    store.insertProd("Blue Shirt", 25, 10);
    uint returnedIndex = store.insertProd("Orange Shirt", 15, 5);

    uint expected = 2;

    Assert.equal(returnedIndex, expected, "A New product has been added to store inventory");
  }

  function testIsProd() public {
    address prodAddress = store.getProdAtIndex(1);
    bool actual = store.isProd(prodAddress);
    bool expected = true;

    Assert.equal(actual, expected, "Value should return as true since a Blue Shirt is index 1");
  }

  function testGetProdAtIndex()public{
    address prodAddress = store.getProdAtIndex(1);
    address[]memory products = store.getProdIndex();

    Assert.equal(products[1], prodAddress, "The address for the Blue shirt matches the value in the index array");
  }

  function testGetProdDetail() public {
    string memory prodName;
    uint prodPrice;
    uint prodQty;
    uint prodIndex;

    address prodAddress = store.getProdAtIndex(1);
    (prodName, prodPrice, prodQty, prodIndex) = store.getProdDetail(prodAddress);

    string memory expProdName = "Blue Shirt";
    uint expProdPrice = 25;
    uint expProdQty = 10;
    uint expProdIndex = 1;

    Assert.equal(prodName, expProdName, "Expected value of Blue Shirt found");
    Assert.equal(prodPrice, expProdPrice, "Expected value of Product Price 25 found");
    Assert.equal(prodQty, expProdQty, "Expected value of Product Quantity 10 found");
    Assert.equal(prodIndex, expProdIndex, "Expected value of Index 1 found");
  }

  function testUpdateProdName() public {
    string memory prodName;

    address prodAddress = store.getProdAtIndex(2);
    bool actual = store.updateProdName(prodAddress,"Yellow Shirt");
    bool expected = true;

    (prodName, , , ) = store.getProdDetail(prodAddress);

    string memory expProdName = "Yellow Shirt";

    Assert.equal(actual, expected, "Value returned as true so the orange shirt is now a yellow shirt");
    Assert.equal(prodName, expProdName, "Validation that the Name is Yellow Shirt as desired");
  }

  function testUpdateProdPrice() public {
    uint prodPrice;

    address prodAddress = store.getProdAtIndex(2);
    bool actual = store.updateProdPrice(prodAddress,10);
    bool expected = true;

    ( , prodPrice, , ) = store.getProdDetail(prodAddress);

    uint expProdPrice = 10;

    Assert.equal(actual, expected, "Value returned as true so the Product Price changed from 15 to 10");
    Assert.equal(prodPrice, expProdPrice, "Validation that the Price has changed from 15 to 10 as desired");
  }

  function testUpdateProdQty() public {
    uint prodQty;

    address prodAddress = store.getProdAtIndex(2);
    bool actual = store.updateProdQty(prodAddress,3);
    bool expected = true;

    ( , , prodQty, ) = store.getProdDetail(prodAddress);

    uint expProdQty = 3;

    Assert.equal(actual, expected, "Value returned as true so the Product Quantity changed from 5 to 3");
    Assert.equal(prodQty, expProdQty, "Validation that the Quantity had changed from 5 to 3 as desired");
  }

  function testDeleteProd()public{
    address prodAddress = store.getProdAtIndex(1);
    uint prodCount = store.getProdCount();

    address deletedAddress = store.deleteProd(1);
    uint newProdCount = store.getProdCount();

    Assert.equal(prodAddress, deletedAddress, "The address deleted from the array matches the item previously in position 1");
    Assert.equal(prodCount, newProdCount + 1, "The total number of items in the store have been deprecated by 1");
  }
}
