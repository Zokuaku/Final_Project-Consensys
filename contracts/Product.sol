pragma solidity ^0.4.21;

contract Product {

    address public owner; // public, so you can see it when you find the child

    constructor () public {
        owner = msg.sender;
    }
}
