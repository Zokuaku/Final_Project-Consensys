pragma solidity ^0.4.21;

contract Administrator {

    address administrator;
    address storeOwner;
    address[] public storeOwners; // public, list, get a list of store owners

    constructor () public {
        administrator = msg.sender;
    }

    /*
        This function sets the Store Owner the only person that can withdraw
        from a store. The "require" needs the administrator to the msg.sender in
        order to be the one assigning whom a store owner is and also prevents
        the administrator from assigning themselves as the store owner (We don't
        need the administrator making themselves an owner and withdrawing the
        stored funds)
    */
    function setStoreOwner(address _storeOwner) public{
        //require(msg.sender!=administrator, "You are not an Administrator");
        require(msg.sender == administrator && _storeOwner != administrator, "Administrator cannot be a Store Owner");
        storeOwner = _storeOwner;
        storeOwners.push(storeOwner);
    }
}
