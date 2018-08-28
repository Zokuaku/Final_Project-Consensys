# Final_Project-Consensys

Final Project for Consensys - Project chosen was the Online Marketplace

## Author: John Kennedy

## 1 Prerequisites:
- You will require truffle and ganache gui present. Truffle.js file is defined with host being 127.0.0.1 for localhost
	and port 8545 as defined by the course rubric. You may also want to use the following Mnemonic for testing but it
	isn't required:
	
	Ganache Mnemonic Test Keys: "ritual soon settle frame one fever stool winter jazz require cable speed"
	
- For testing with my contract I have had to comment out the "OnlyAdmin" modifier on line 208 the require on line 212
	for the setStoreOwner function. I also had to do it again for the insertProd function on lines 295 and 299
	respectively. Again for deleteProd on lines 355 and 359 as well as for Function updateProdName on lines 431 and
	435 as well as updateProdPrice on line 461, 465 for updateProdQty 491 and 495 and that should be it.

## 2 Project Outline:
- This Smart Contract is my rendition of the Online Marketplace final project from the Consensys training course.
	The Smart Contracts implemented in this project are designed to create a collective online marketplace (like
	ebay or amazon). The intent is that the administrator (the original address that published the contract) would
	be able to allocate an Address to a Store Owners list that would open the end-users accessibility up to Create
	a Store and then add/change/remove products from it. The Store Owner would also be able to via Store Balances
	and withdraw the funds respectively. The Marketplace would then provide end-user filtering to determine accessiblity
	based on functional role (e.g. Administrator, Store Owner or Client). Clients would be able to see the available
	list of stores, select a store and then requisition a product from the store which would initiate a financial
	transfer from the client to the respective store.

## 3 Key Modules:

  ### TotalMarketplace Contract
  Marketplace Contract is the main contract that interacts with all the end users and validates there roles to determine there 
  appropriate level of access and available function calls. It is also used to call a view only list of all the available stores
  on the Marketplace to show to either the Store Owner or End User(client). The Administrator functions maintains a dynamic array
  of all the presently listed Store Owners as well as the ability to add new Store Owners to the list. It also offers a function
  to call a list of all the Addresses presently listed in the array to appropriately call available Store Contracts listed under 
  the StoreOwner Contract dynamic array. It also allows you to create Stores via calling the Store Contract. This contract also
  extends accessibility of the Store Contract functionality via import (like a library) to call the Add, Modify, Delete functionality
  presently expressed in the with the TotalMarketplace Contract. The intent of this design philosophy is that all Store Contracts 
  are effectively child contracts of the Store Owner Address allowing the opportunity to restrict contract visibility to the intend
  owner with the desired limited functionality.
  
  ### Store Contract
  Store Contract Each store contract is intended to have independance for storing value and maintaining store balances from sales.
  This should allow for a restriction of Store Ownership and visibility for certain desired functions.
  
  ### NewProduct Contract
  NewProduct Contract Each Product is defined by its own onchain contract address to add product
  visibility and for the potential of future cross-chain accessibility for supply management design (e.g. product drops below
  Qty. 3 new shipment can be enrouted to fulfill supply demands to ensure optimal consumer delivery).