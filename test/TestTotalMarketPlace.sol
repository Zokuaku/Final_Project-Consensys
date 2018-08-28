pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Store.sol";
import "../contracts/NewProduct.sol";
import "../contracts/TotalMarketplace.sol";

contract TestTotalMarketPlace{
  TotalMarketplace market = TotalMarketplace(DeployedAddresses.TotalMarketplace());

  constructor()public{
   address StoreOwner = msg.sender;
   market.setStoreOwner(StoreOwner,"","");
  }

  Store store = new Store();

  /*
  Function testIsOwner is to check if the constructor has appropriately set
  the msg.sender to owner via the call to the setStoreOwner function. This
  is done by setting return value from isOwner with the msg.sender as the
  argument set to bool actual. Bool expected is the expected outcome the
  assert then checks if the values are equal, if true then this address is
  a store owner and passes.
  */
  function testisOwner()public{
    bool actual = market.isOwner(msg.sender);
    bool expected = true;

    Assert.equal(actual, expected, "This address is a Store Owner");
  }

  /*
  Function testInsertProd tests inserting a few values into the prodIndex
  array in TotalMarketplace it first sets a Red Shirt, Blue shirt and finally
  an Orange shirt. For the Orange shirt we define the returnedIndex value uint
  that is expected as a return from the function. Expected index outcome is 2
  as 2 prior values have been entered taking up positions 0 & 1 in the array.
  If the assert returnedIndex and expected match then the 3 new products have
  been properly added to the array and the array has grown accordingly.
  */
  function testInsertProd() public {
    //market.setStoreOwner(msg.sender,"","");
    market.insertProd(store, "Red Shirt", 15, 5);
    market.insertProd(store, "Blue Shirt", 25, 10);
    uint returnedIndex = market.insertProd(store, "Orange Shirt", 15, 5);

    uint expected = 2;

    Assert.equal(returnedIndex, expected, "A New product has been added to store inventory");
  }

  /*
  Function testIsProd is meant to check if the returned address for Index 1 in the
  prodIndex array comes up true. We get teh address calling the getProdAtIndex function
  feeding 1 as the argument and storing the returned value as an address to productAddress
  when then feed the acquired address into the isProd function to see if the argument
  returns true and set the value to actual. We set expected to true as we know there
  is a blue shirt at index 1 form the testInsertProd function earlier. If the assert
  comes up true for both then we know that the product is in the array.
  */
  function testIsProd() public {
    address prodAddress = market.getProdAtIndex(1);
    bool actual = market.isProd(prodAddress);
    bool expected = true;

    Assert.equal(actual, expected, "Value should return as true since a Blue Shirt is index 1");
  }

  /*
  Function testGetProdAtIndex is designed to check if the value returned from testGetProdAtIndex
  is indeed in the products array at the same position. We call the getProdAtIndex with argument
  1 and set the return to address prodAddress. Next we call getProdIndex and set the values to a
  temporary memory array called products. For the Assert.equal we call the products array with
  index 1 and the returned prodAddress if the values are equal that indicates that the Product
  At Index 1 has been properly retrieved from it's position in the array.
  */
  function testGetProdAtIndex()public{
    address prodAddress = market.getProdAtIndex(1);
    address[]memory products = market.getProdIndex();

    Assert.equal(products[1], prodAddress, "The address for the Blue shirt matches the value in the index array");
  }

  /*
  Function testGetProdDetail is designed to pass a product address and get the
  details of the product. To do this we have to define a set of variables that
  match the properties of the StoreStruct next we call the function getProdAtIndex
  and pass it the argument 1 (As we know this is the blue shirt) and store it to
  prodAddress. Next we call the getProdDetail passing it the stored prodAddress
  and write each of the respective return values to their associated property/variables.
  For the next set of variables we define our expected results (As we know this is the
  blue shirt from testInsertProd we can use it as reference to define our expected returns).
  We then check each return property against its expected property over 4 separate asserts
  to ensure that all Product Details match.
  */
  function testGetProdDetail() public {
    string memory prodName;
    uint prodPrice;
    uint prodQty;
    uint prodIndex;

    address prodAddress = market.getProdAtIndex(1);
    (prodName, prodPrice, prodQty, prodIndex) = market.getProdDetail(prodAddress);

    string memory expProdName = "Blue Shirt";
    uint expProdPrice = 25;
    uint expProdQty = 10;
    uint expProdIndex = 1;

    Assert.equal(prodName, expProdName, "Expected value of Blue Shirt found");
    Assert.equal(prodPrice, expProdPrice, "Expected value of Product Price 25 found");
    Assert.equal(prodQty, expProdQty, "Expected value of Product Quantity 10 found");
    Assert.equal(prodIndex, expProdIndex, "Expected value of Index 1 found");
  }

  /*
  Function testUpdateProdName is designed to verify that the product name gets
  updated and matches appropriately when complete. We declare a temporary string
  value named prodName to return on the Product Name detail. We call the getProdAtIndex
  with an argument of 2 to get the Orange Shirt and store it as prodAddress. Next
  we call the updateProdName with the previously listed address and the new parameter
  "Yellow Shirt" setting the bool value to actual (this should return true to indicate
  success). We define expected to true as that is the expected result. We then call
  the getProdDetail with the prodAddress argument to return the prodName detail. We
  set expProdName to "Yellow Shirt" as that is what we changed it to. And then do
  two Assert verifications one on the boolean return and one on the ProdName And
  expProdName to validate the argument is correct and the strings match.
  */
  function testUpdateProdName() public {
    string memory prodName;

    address prodAddress = market.getProdAtIndex(2);
    bool actual = market.updateProdName(prodAddress,"Yellow Shirt");
    bool expected = true;

    (prodName, , , ) = market.getProdDetail(prodAddress);

    string memory expProdName = "Yellow Shirt";

    Assert.equal(actual, expected, "Value returned as true so the orange shirt is now a yellow shirt");
    Assert.equal(prodName, expProdName, "Validation that the Name is Yellow Shirt as desired");
  }

  /*
  Function testUpdateProdPrice works on the same principal as testUpdateProdName
  we declare a temporary uint prodPrice, get the Address for the item at index 2
  of prodIndex via the getProdAtIndex function. Next we call the result of the UpdateProdPrice
  and store it as bool actual we set bool expected to true as we expect the update
  was a success. We use the functioon getProdDetail with the prodAddress argument
  to get the new prodPrice value we set the expProdPrice to match the previous
  updateProdPrice that we passed of 10 as that is expected. We run two asserts
  the first it to validate that the operation returned true as expected meaning
  it successfully updated the value. The second assert is to make sure the updated
  value matches the expected value as a secondary validation.
  */
  function testUpdateProdPrice() public {
    uint prodPrice;

    address prodAddress = market.getProdAtIndex(2);
    bool actual = market.updateProdPrice(prodAddress,10);
    bool expected = true;

    ( , prodPrice, , ) = market.getProdDetail(prodAddress);

    uint expProdPrice = 10;

    Assert.equal(actual, expected, "Value returned as true so the Product Price changed from 15 to 10");
    Assert.equal(prodPrice, expProdPrice, "Validation that the Price has changed from 15 to 10 as desired");
  }

  /*
  Function testUpdateProdQty is leveraged to validate testing the final updateProdQty
  function. It does it by declaring a uint for storing the prodQty variable returned
  from getProdDetail. We set the returned value of getProdAtIndex with an argument 2
  to the prodAddress (These are the details for the Yellow shirt formerly the Orange
  shirt). When then use the updateProdQty to change the Quantity form 5 to 3 with
  a bool return set to actual. The expected return is true as defined and the new
  expected quantity should be 3 as we pushed it in updateProdQty. We run two asserts
  to validate it the first to compare the bools match with the expected value of true
  letting us know the operation succeeded. The second assert compares the values
  match validating that the new updated quantity is indeed 3 as desired.
  */
  function testUpdateProdQty() public {
    uint prodQty;

    address prodAddress = market.getProdAtIndex(2);
    bool actual = market.updateProdQty(prodAddress,3);
    bool expected = true;

    ( , , prodQty, ) = market.getProdDetail(prodAddress);

    uint expProdQty = 3;

    Assert.equal(actual, expected, "Value returned as true so the Product Quantity changed from 5 to 3");
    Assert.equal(prodQty, expProdQty, "Validation that the Quantity had changed from 5 to 3 as desired");
  }

  /*
  Function TestDeleteProd gets the prodAddress for the product at Index 1 (Blue Shirt)
  next it gets a count of the array length via getProdCount and stores it to prodCount.
  next it calls the deleteProd on index 1 and stores the deleted address. It now gets
  the new array length and stores it to newProdCount for comparison. Next we get the
  ProdName and define the expProdName as "Yellow Shirt" as this should be the items
  in index 1 now. Assert 1 verifies the prodAddress matches the returned deletedAddress
  from the deleteProd function. Assert 2 compares previous length plus new length+1
  if they are equal then the array is smaller by one item as expected. Assert 3 goes
  through and validates that the expected value should now be Yellow Shirt for index 1.
  */
  function testDeleteProd()public{
    string memory prodName;

    address prodAddress = market.getProdAtIndex(1);
    uint prodCount = market.getProdCount();

    address deletedAddress = market.deleteProd(1);
    uint newProdCount = market.getProdCount();

    address prdAddress = market.getProdAtIndex(1);

    (prodName, , , ) = market.getProdDetail(prdAddress);

    string memory expProdName = "Yellow Shirt";

    Assert.equal(prodAddress, deletedAddress, "The address deleted from the array matches the item previously in position 1");
    Assert.equal(prodCount, newProdCount + 1, "The total number of items in the store have been deprecated by 1");
    Assert.equal(prodName, expProdName, "Validation that the Name is Yellow Shirt as desired");
  }
}
