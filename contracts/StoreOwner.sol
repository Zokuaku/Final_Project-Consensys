pragma solidity ^0.4.21;

import "../contracts/Administrator.sol";
import "../contracts/Store.sol";

contract StoreOwner {

    address storeOwner;
    address[] public stores; // public, list, get a list of store addresses
    event LogStoreCreated(address store); // maybe listen for events

    constructor () public{
        storeOwner = msg.sender;
    }

    function createStore() public {
        Store store = new Store();
        emit LogStoreCreated(store); // emit an event - another way to monitor this
        stores.push(store); // you can use the getter to fetch child addresses
    }
}
