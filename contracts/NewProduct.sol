pragma solidity ^0.4.21;

// NewProduct contract is for creating a new Product Address on Call.
contract NewProduct {

	// Public view so you can see the contract Owner
    address public owner;
	
	/*
	Constructor sets msg.sender that calls the contract to the
	Owner of the subsequent address/contract
	*/
    constructor () public {
        owner = msg.sender;
    }
}