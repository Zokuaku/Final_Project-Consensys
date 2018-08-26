pragma solidity ^0.4.21;

import "../contracts/Product.sol";

contract Store {

    address public owner;

    constructor () public {
        owner = msg.sender;
    }

    struct StoreStruct {
        string prodName;
        uint prodPrice;
        uint prodQty;
        uint index;
    }

    mapping(address => StoreStruct) private StoreStructs;
    address[] private prodIndex;

    event LogNewProd(address indexed productAddress, uint index, string prodName, uint prodPrice, uint prodQty);
    event LogUpdateProd(address indexed productAddress, uint index, string prodName, uint prodPrice, uint prodQty);
    event LogDeleteProd(address indexed productAddress, uint index);
    event LogProductCreated(address product);

    function isProd(address productAddress)
    public
    constant
    returns(bool isIndeed){
        if(prodIndex.length == 0) return false;
        return (prodIndex[StoreStructs[productAddress].index] == productAddress);
    }

   /*
    function prodIndCount (address product) public constant returns(uint count){
        return StoreStructs[product].prodInd.length;
    }

    function prodIndAtIndex (address product, uint index) public constant returns (address productAddress){
        return StoreStructs[product].prodInd[index];
    }
    */

    function insertProd(
    string prodName,
    uint prodPrice,
    uint prodQty)
    public
    returns(uint index){
        Product product = new Product();
        require(!isProd(product),"Product already exists");
        StoreStructs[product].prodName = prodName;
        StoreStructs[product].prodPrice = prodPrice;
        StoreStructs[product].prodQty = prodQty;
        StoreStructs[product].index = prodIndex.push(product)-1;
        emit LogNewProd(
            product,
            StoreStructs[product].index,
            prodName,
            prodPrice,
            prodQty);
        return prodIndex.length-1;
    }

    function getProdAtIndex(uint index)
    public
    constant
    returns(address storeAddress){
        return prodIndex[index];
    }

    function deleteProd(uint index)
    public
    returns(address productAddress){
        require(index <= prodIndex.length && index >= 0, "Can't delete no Product found.");
        uint rowToDelete = index;
        address keyToDel = prodIndex[index];
        address keyToMove = prodIndex[prodIndex.length-1];
        prodIndex[rowToDelete] = keyToMove;
        StoreStructs[keyToMove].index = rowToDelete;
        prodIndex.length--;
        emit LogDeleteProd(
            keyToDel,
            rowToDelete);
        emit LogUpdateProd(
            keyToMove,
            rowToDelete,
            StoreStructs[keyToMove].prodName,
            StoreStructs[keyToMove].prodPrice,
            StoreStructs[keyToMove].prodQty);
        return keyToDel;
    }

    function getProdDetail(address productAddress)
    public
    constant
    returns(string prodName, uint prodPrice, uint prodQty, uint index){
        require(isProd(productAddress),"No Details, Product does not exist.");
        return(
            StoreStructs[productAddress].prodName,
            StoreStructs[productAddress].prodPrice,
            StoreStructs[productAddress].prodQty,
            StoreStructs[productAddress].index);
    }

    function updateProdName(address storeAddress, string prodName)
    public
    returns(bool success){
        require(isProd(storeAddress),"Can't update Name, Product does not exist");
        StoreStructs[storeAddress].prodName = prodName;
        emit LogUpdateProd(
            storeAddress,
            StoreStructs[storeAddress].index,
            prodName,
            StoreStructs[storeAddress].prodPrice,
            StoreStructs[storeAddress].prodQty);
        return true;
    }

    function updateProdPrice(address storeAddress, uint prodPrice)
    public
    returns(bool success){
        require(isProd(storeAddress), "Can't update Price, Product does not exist.");
        StoreStructs[storeAddress].prodPrice = prodPrice;
        emit LogUpdateProd(
            storeAddress,
            StoreStructs[storeAddress].index,
            StoreStructs[storeAddress].prodName,
            prodPrice,
            StoreStructs[storeAddress].prodQty);
        return true;
    }

    function updateProdQty(address storeAddress, uint prodQty)
    public
    returns(bool success){
        require(isProd(storeAddress), "Can't update Quantity, Product does not exist.");
        StoreStructs[storeAddress].prodQty = prodQty;
        emit LogUpdateProd(
            storeAddress,
            StoreStructs[storeAddress].index,
            StoreStructs[storeAddress].prodName,
            StoreStructs[storeAddress].prodPrice,
            prodQty);
        return true;
    }

    function getProdCount()
    public
    constant
    returns(uint count){
        return prodIndex.length;
    }

    function getProdIndex() public view returns(address[]){
      return prodIndex;
    }

    function withdraw(uint amount) private{
        require(msg.sender == owner);
        msg.sender.transfer(amount);
    }

    function getBalance() private view returns (uint){
        require(msg.sender == owner);
        return address(this).balance;
    }
}
