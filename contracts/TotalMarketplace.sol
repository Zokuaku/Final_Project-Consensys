pragma solidity ^0.4.21;

// Imported Contract to create new Product Address
import "../contracts/NewProduct.sol";

// Imported Contract to create new Store Address
import "../contracts/Store.sol";

/*
TotalMarketplace Contract is designed for the creation of an Online Marketplace.
The intended smart contract functionality defines the Administrator, Store Owner,
Client, Stores and Products. The intent is to be able to trace market transactions,
inventory, Owners and Stores on the Blockchain. This contract is built to the
Story from the Consensys Online Marketplace outlined in the Final Project Document.
User Stories where used to the best of my experience to create specific user
functionality based on the content I learned from the course.
*/
contract TotalMarketplace {

    /*
    Administrator is the only user that can define Store Owners and is set as the
    Contract instantiator by default.
    */
    address administrator;

    /*
    storeOwner is the Owner, Creator and updater of Stores and Products
    */
    address storeOwner;

    /*
    Client is an enduser that wishes to interact with the Marketplace
    */
    address client;

    // Public list of all the Available stores presently created.
    address[] public stores;

    // Event to emit the creation of a store to the console.
    event LogStoreCreated(address store);

    // Event to emit the creation of a new product to the console as well as the details of the product.
    event LogNewProd(address indexed productAddress, uint index, address storeAddress, uint indexStore, string prodName, uint prodPrice, uint prodQty);

    // Event to emit the modification of an existing product to the console including change details and product details
    event LogUpdateProd(address indexed productAddress, uint index, string prodName, uint prodPrice, uint prodQty);

    // Event to emit the deletion of a Product Address and Product Index to the console.
    event LogDeleteProd(address indexed productAddress, uint index);

    /*
    OwnerStruct is intended to define the details of a Store OwnerStruct
    Functionally only the address ownerAddress is presently required or
    in use. Additional properties are for future identifiers and growth.
    */
    struct OwnerStruct {
        address ownerAddress;
        string ownerName;
        string ownerEmail;
        uint index;
    }

    // Index point for the OwnerStructs, for retrieving defined data.
    mapping(address => OwnerStruct) private OwnerStructs;

    /*
    Private list of the Store Owners intended to limit calls outside of this
    contract to manipulate adding undesired storeOwners to the list. Or changing
    existing storeOwners to a different address to perform a withdrawl.
    */
    address[] private storeOwners;

    /*
    StoreStruct is intended to define the details of a Product StoreStruct
    Properties detail the traits of a product including Product Name,
    Product Price, Product Quantity, Store Index for storing Product Address,
    Index for storing Product Address in prodIndex Array and finally balance
    for any balance transfers that may occur.
    */
    struct StoreStruct {
        string prodName;
        uint prodPrice;
        uint prodQty;
        uint storeIndex;
        uint index;
        uint balance;
    }

    // Index point for the StoreStruct, for retrieving defined data.
    mapping(address => StoreStruct) private StoreStructs;

    // Product Index array for iterating over the StoreStruct for specific values
    address[] private prodIndex;

    // Index for retrieving UserBalance
    mapping (address => uint) public UserBalance;

    // Index for retrieving StoreBalance
    mapping (address => uint) private StoreBalance;

    // Index for retrieving OwnerBalance
    mapping (address => uint) private OwnerBalance;

    // Contract constructor
    constructor () public {
        // Sets initial contract creator to administrator
        administrator = msg.sender;

        /*
        check to see if the msg.sender isn't administrator and isOwner returns
        true then the msg.sender is a storeowner. Otherwise msg.sender is a
        client.
        */
        if(msg.sender != administrator && isOwner(msg.sender) == true){
            storeOwner = msg.sender;
        } else {
            client = msg.sender;
        }

    }

    /*
    Circuit Breaker boolean that can be set to true if there is a bug
    discovered in the code. Default's to false and is set to true by
    the Administrator only.
    */
    bool private stopped = false; // circuit breaker bool

    /*
    If a function has this modifier in a not stopped state it can prohibit an
    action from taking place. Have implemented this on purchaseProduct function.
    */
    modifier stopInEmergency {
        if (!stopped)
        _;
    }

    /*
    If a function has this modifier in a stopped state it will prohibit an
    action from taking place. Have implemented this on withdraw function.
    */
    modifier onlyInEmergency {
        if (stopped)
        _;
    }

    /*
    Modifier OnlyAdmin restrict access to certain function if this modifier is present
    requires that the msg.sender be equal to the Administrator in order to call the
    desired function.
    */
    modifier OnlyAdmin {
        require(administrator == msg.sender, "End user is an Administrator");
        _;
    }

    /*
    Modifier OnlyStoreOwner restrict access to certain function if this modifier
    is present requires that the msg.sender be equal to a Store Owner to call the
    desired function.
    */
    modifier OnlyStoreOwner {
        require(storeOwner == msg.sender, "End user is a Store Owner");
        _;
    }

    /*
    Function to toggle whether or not the Contract is active and receptive or
    if the contract needs to be stopped because a bug is found. This will presently
    only implement the Purchase Product and Withdraw Functions in this smartContract.
    */
    function toggleContractActive() OnlyAdmin public returns (bool){
        stopped = !stopped;
        return (stopped);
    }

    /*
    Boolean function to check if a passed address is an Owner
    */
    function isOwner(address ownerAddress)
    public
    constant
    returns(bool isIndeed){
        if(storeOwners.length == 0) return false;
        return (storeOwners[OwnerStructs[ownerAddress].index] == ownerAddress);
    }

    // Function to get the Address of the Administrator for the Contract.
    function getAdministrator ()
    public
    view
    returns(address){
        return(administrator);
    }

    /*
        This function sets the Store Owner the only person that can withdraw
        from a store. The "require" needs the administrator to the msg.sender in
        order to be the one assigning whom a store owner is and also prevents
        the administrator from assigning themselves as the store owner (We don't
        need the administrator making themselves an owner and withdrawing the
        stored funds)
    */
    function setStoreOwner(
        address ownerAddress,
        string ownerName,
        string ownerEmail)
        //OnlyAdmin
        public
        returns(uint index){
        // Must be an Administrator to Set the Store Owner
        //require(msg.sender == administrator, "You are not an Administrator");

        /*
        Prohibit the Administrator from being a Store Owner to prohibit setting themselves
        as a StoreOwner or changing the array so that they are the Store Owner for all
        Stores.
        */
        //require(ownerAddress != administrator, "Administrator cannot be a Store Owner");

        // Store Owner is the provided ownerAddress from the Administrator
        storeOwner = ownerAddress;

        // Checks to make sure that the new Store Owner doesn't already exist
        require(!isOwner(storeOwner),"Store Owner already exists");

        // Sets the OwnerStructs property for Owner Name to ownerName
        OwnerStructs[storeOwner].ownerName = ownerName;

        // Sets the OwnerStructs property for Owner Email to ownerEmail
        OwnerStructs[storeOwner].ownerEmail = ownerEmail;

        // Pushes storeOwner index property to the StoreOwners Array
        OwnerStructs[storeOwner].index = storeOwners.push(storeOwner)-1;

        // returns the updated lenght of the Store Owners array.
        return storeOwners.length-1;
    }

    // Function to output all of the Store Owners in the Store Owners Array
    function getOwnersIndex() public view returns(address[]){
      return storeOwners;
    }

    /*
    Function to Create Store calls store contract to make a new store address
    and then pushes the new Store address to the Stores Array.
    */
    function createStore() OnlyStoreOwner payable public {
        // Checks that the requestor of Create Store is a Store Owner.
        require(msg.sender==storeOwner, "You are not a Store Owner");

        // Calls Store contract to Create new Store address.
        Store store = new Store();

        // Outputs the Address of the Store Created
        emit LogStoreCreated(store);

        // Pushes the new Store Address to the Stores Array
        stores.push(store);

        /*
        Set the new Store's Balance to 0, intended to prevent outside manipulation
        of the contract to set a negative value or send an amount of Ether that could
        potentially end up lost.
        */
        StoreBalance[store] = 0;
    }

    /*
    Function to check if the ProductAddress exists in the prodIndex array. If the
    product index array is length 0 then it returns false meaning the product does
    note exist. If however the check passes it compares the Product Address in
    StoreStructs to the provided product address to validate it exists returning
    true.
    */
    function isProd(address productAddress)
    public
    constant
    returns(bool isIndeed){
        if(prodIndex.length == 0) return false;
        return (prodIndex[StoreStructs[productAddress].index] == productAddress);
    }

    /*
    Function that creates a new Product with the Passed values from the Store Owner
    and generates a new Product Address. Store Index is intended to track which
    Products are associated with the Store.
    */
    function insertProd(
    address storeAddress,
    string prodName,
    uint prodPrice,
    uint prodQty)
    //OnlyStoreOwner
    public
    returns(uint index){
        // Only a Store Owner can Create new Products
        //require(msg.sender==storeOwner,"You are not a Store Owner");

        // Call NewProduct contract to create new Product Address
        NewProduct product = new NewProduct();

        // Check to make sure that the product does not currently exist
        require(!isProd(product),"Product already exists");

        // Set StoreStructs Property Product Name to the passed prodName
        StoreStructs[product].prodName = prodName;

        // Set StoreStructs Property Product Price to the passed prodPrice
        StoreStructs[product].prodPrice = prodPrice;

        // Set StoreStructs Property Product Quantity to the passed prodQty
        StoreStructs[product].prodQty = prodQty;

        // Set StoreStructs Store Index to track product to the Store Address
        StoreStructs[product].storeIndex = stores.push(storeAddress)-1;

        // Set StoreStructs Product Index to track the number of Products presently
        StoreStructs[product].index = prodIndex.push(product)-1;

        /*
        Logs the Product Address, Product Index, Store Address, Store Index,
        Product Name, Product price and product quantity in a human readable
        log.
        */
        emit LogNewProd(
            product,
            StoreStructs[product].index,
            stores[StoreStructs[product].storeIndex],
            StoreStructs[product].storeIndex,
            prodName,
            prodPrice,
            prodQty);
        return prodIndex.length-1;
    }

    /*
    Function to get the Product Address from a specific index in the
    Product Index Array.
    */
    function getProdAtIndex(uint index)
    public
    constant
    returns(address prodAddress){
        return prodIndex[index];
    }

    /*
    Function to Delete Product via a passed Index value. Delete works by
    effectively copying the last value over the desired value to delete
    and depracting the prodIndex array length by -1.
    */
    function deleteProd(uint index)
    //OnlyStoreOwner
    public
    returns(address productAddress){
        // Ensure requested modifier is being done by Store Owner
        //require(msg.sender==storeOwner,"You are not a Store Owner");

        // Ensure the index is a value within the bounds of the array otherwise terminate
        require(index <= prodIndex.length && index >= 0, "Can't delete no Product found.");

        // Array value you wish to delete
        uint rowToDelete = index;

        // Product Address Key you wish to delete
        address keyToDel = prodIndex[index];


        // Final Product Address in the Array to move to replace key you wish to delete
        address keyToMove = prodIndex[prodIndex.length-1];

        // Sets Key to Move to desired delete location
        prodIndex[rowToDelete] = keyToMove;

        // Deletes all the values from struct that match the row to delete
        StoreStructs[keyToMove].index = rowToDelete;

        // Deprecates Product Index Array by length of -1
        prodIndex.length--;

        /*
        Outputs value of Key to be Deleted and the Index of the Row Deleted to
        the Console.
        */
        emit LogDeleteProd(
            keyToDel,
            rowToDelete);

        /*
        Outputs value of Key to be Deleted and the Index of the Row Deleted to
        the Console as well as the values that were moved from the end of the
        array to the index of the row deleted.
        */
        emit LogUpdateProd(
            keyToMove,
            rowToDelete,
            StoreStructs[keyToMove].prodName,
            StoreStructs[keyToMove].prodPrice,
            StoreStructs[keyToMove].prodQty);
        return keyToDel;
    }

    /*
    Function to get the Product Details for a specified Product address.
    Should output Product Name, Product Price, Product Quantity and Index.
    */
    function getProdDetail(address productAddress)
    public
    constant
    returns(string prodName, uint prodPrice, uint prodQty, uint index){
        /*
        Checks to see if product exists if nothing is found there is no reason to proceed
        */
        require(isProd(productAddress),"No Details, Product does not exist.");

        // Return of above listed values.
        return(
            StoreStructs[productAddress].prodName,
            StoreStructs[productAddress].prodPrice,
            StoreStructs[productAddress].prodQty,
            StoreStructs[productAddress].index);
    }

    /*
    Function that Updates the Product Name by providing the Product address
    and new Product Name, returning True if successful.
    */
    function updateProdName(address prodAddress, string prodName)
    //OnlyStoreOwner
    public
    returns(bool success){
        // Validate that the requestor of the change is the Store Owner
        //require(msg.sender==storeOwner,"You are not a Store Owner");

        // Validate that there is even a product with prodAddress to update, if not break
        require(isProd(prodAddress),"Can't update Name, Product does not exist");

        // Update the Product Address property Product Name with new Desired Name
        StoreStructs[prodAddress].prodName = prodName;

        /*
        Output Product Update information to view transactional update is on correct
        Product Address and that Product Name has changed.
        */
        emit LogUpdateProd(
            prodAddress,
            StoreStructs[prodAddress].index,
            prodName,
            StoreStructs[prodAddress].prodPrice,
            StoreStructs[prodAddress].prodQty);
        return true;
    }

     /*
    Function that Updates the Product Price by providing the Product address
    and new Product Price, returning True if successful.
    */
    function updateProdPrice(address prodAddress, uint prodPrice)
    //OnlyStoreOwner
    public
    returns(bool success){
        // Validate that the requestor of the change is the Store Owner
        //require(msg.sender==storeOwner,"You are not a Store Owner");

        // Validate that there is even a product with prodAddress to update, if not break
        require(isProd(prodAddress), "Can't update Price, Product does not exist.");

        // Update the Product Address property Product Price with new Desired Price
        StoreStructs[prodAddress].prodPrice = prodPrice;

        /*
        Output Product Update information to view transactional update is on correct
        Product Address and that Product Price has changed.
        */
        emit LogUpdateProd(
            prodAddress,
            StoreStructs[prodAddress].index,
            StoreStructs[prodAddress].prodName,
            prodPrice,
            StoreStructs[prodAddress].prodQty);
        return true;
    }

    /*
    Function that Updates the Product Quantity by providing the Product address
    and new Product Quantity, returning True if successful.
    */
    function updateProdQty(address prodAddress, uint prodQty)
    //OnlyStoreOwner
    public
    returns(bool success){
        // Validate that the requestor of the change is the Store Owner
        //require(msg.sender==storeOwner,"You are not a Store Owner");

        // Validate that there is even a product with prodAddress to update, if not break
        require(isProd(prodAddress), "Can't update Quantity, Product does not exist.");

        // Update the Product Address property Product Quantity with new Desired Quantity
        StoreStructs[prodAddress].prodQty = prodQty;

        /*
        Output Product Update information to view transactional update is on correct
        Product Address and that Product Quantity has changed.
        */
        emit LogUpdateProd(
            prodAddress,
            StoreStructs[prodAddress].index,
            StoreStructs[prodAddress].prodName,
            StoreStructs[prodAddress].prodPrice,
            prodQty);
        return true;
    }

    /*
    Function that gets a count of the total number of products in the prodIndex
    Array. Used for determing array length for the delete function.
    */
    function getProdCount()
    public
    constant
    returns(uint count){
        return prodIndex.length;
    }

    /*
    Function that outputs all the listed Product Addresses in the
    prodIndex Array.
    */
    function getProdIndex() public view returns(address[]){
      return prodIndex;
    }

    /*
    Function used to Check the Balance of any Address sent to it and returns
    the listed balance.
    */
    function getUserBalance(address clientAddress) public view returns(uint balance){
        return clientAddress.balance;
    }

    /*
    Provide Store Address and Product Address to charge to client. Value will decrement
    Clients wallet by the respective amount and decrease the quantity of the product
    as well.
    */
    function purchaseProduct(address storeAddress, address prodAddress)
    public
    payable stopInEmergency
    returns (bool success) {
        // Check the store still has some Products in stock
        require(StoreStructs[prodAddress].prodQty != 0);

        // Check if sender has balance
        require(getUserBalance(msg.sender)>= StoreStructs[prodAddress].prodPrice);

        // Check for overflows
        require(StoreBalance[stores[StoreStructs[prodAddress].index]] + StoreStructs[prodAddress].prodPrice >= StoreBalance[stores[StoreStructs[prodAddress].index]]);

        // Check for underflows, ensure that User Balance minus product price won't go below zero.
        require(getUserBalance(msg.sender) - StoreStructs[prodAddress].prodPrice <= getUserBalance(msg.sender));

        // Deprecate Store Product Quantity by 1
        StoreStructs[prodAddress].prodQty -= 1;

        //UserBalance[msg.sender] -= StoreStructs[prodAddress].prodPrice;

        // Add the value of the Product Price to the Store Address for future withdraw
        StoreBalance[stores[StoreStructs[storeAddress].index]] += StoreStructs[prodAddress].prodPrice;

        // Return Status true to signify successful purchase
        return true;
    }

    /*
    Function call to Withdraw funds from the Store Address and send them to the
    Store Owner Address.
    */
    function withdraw(address storeAddress) OnlyStoreOwner public onlyInEmergency returns (bool) {
        // Checks to make sure the requestor is the Store Owner.
        require(msg.sender==storeOwner, "You are not a Store Owner");

        // Amount is equal to the Balance returned for Store Address
        uint amount = getUserBalance(storeAddress);

        /*
        If amount is greater than zero send the balance to the Store Owner and
        set the balance to 0. This is intended to prevent a re-entry attack.
        */
        if (amount > 0) {
            /*
            It is important to set this to zero because the recipient
            can call this function again as part of the receiving call
            before `send` returns.
            */
            StoreBalance[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                StoreBalance[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
}
