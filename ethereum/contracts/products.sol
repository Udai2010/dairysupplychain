// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Stakeholders {
    struct StakeholderDetails{
        uint id;
        string name;
        uint timestamp;
        uint quantitySupply;
        string location;
        uint temperature;
    }

    mapping(uint => StakeholderDetails) private stakeholder_details;

    uint private stakeholderCount;

    function addStakeholder(string memory _name, uint supply, string memory _location, uint _temperature) internal {
        StakeholderDetails storage newStakeholder = stakeholder_details[++stakeholderCount];
        newStakeholder.id = stakeholderCount;
        newStakeholder.name = _name;
        newStakeholder.timestamp = block.timestamp;
        newStakeholder.quantitySupply = supply;
        newStakeholder.location = _location;
        newStakeholder.temperature = _temperature;
    }

    function getStakeholderDetails(uint stakeholderID) internal view returns (StakeholderDetails memory) {
        return stakeholder_details[stakeholderID];
    }

    function getNumberOfStakeholders() internal view returns (uint) {
        return stakeholderCount;
    }
    
}

contract Processes{
    struct Process{
        uint ID;
        string description;
        bool active;
    }

    mapping(uint => Process) process_details;

    constructor(){
        process_details[1]=Process(1,"Raw Material",false);
        process_details[2]=Process(2,"Pasteurization",false);
        process_details[3]=Process(3,"Out of Delivery",false);
    }

    modifier isValidProcessID(uint _id){
        require(_id > 0);
        _;
    }

    function isActive(uint _id) internal view isValidProcessID(_id) returns(bool) {
        return process_details[_id].active;
    }

    function changeState(uint _id) internal isValidProcessID(_id) {
        process_details[_id].active = true;
    }
}

contract Product is Stakeholders,Processes {
    struct ProductDetails{
        uint ID;
        string name;
        uint quantity;
        string globalID;
        uint[] traceProducts;
        uint[] temperatureProducts;
        uint traceCount;
        uint temperatureCount;
        uint stakeholderCount;
        StakeholderDetails[] stakeholderList;    
        mapping(uint => Process) processList;    
        uint currStatus;
    }

    // mapping the struct w.r.t productID
    mapping(uint => ProductDetails) private product_details; 

    // It is necessary to have the count since we cannot loop the mapped elements
    uint productCount;

    address stakeholder;
    address admin;

    // while deploying the contract the admin must specify who is the stakeholder
    constructor(address _stakeholder) {
        admin = msg.sender;
        stakeholder = _stakeholder;
    }

    // Modifiers required for our contract

    // To ensure whether the user is an admin
    modifier isAdmin {
        require(msg.sender == admin);
        _;
    }

    // To ensure whether the user is a stakeholder
    modifier isStakeholder {
        require(msg.sender == stakeholder);
        _;
    }

    // Either admin or stakeholder
    modifier isAdminOrStakeholder {
        require(msg.sender == admin || msg.sender == stakeholder);
        _;
    }

    // To ensure the given product is valid
    modifier isValidProductID(uint _productID) {
        require(_productID > 0 && _productID <= productCount);
        _;
    }

    modifier isSupplyAcceptable(uint productID, uint supply){
        require(supply <= product_details[productID].quantity);
        _;
    }
    
    // functions required for our contract
    // product
    function addProduct(string memory _name, uint _quantity, string memory _globalID) public isAdminOrStakeholder {
        ProductDetails storage newProduct = product_details[++productCount];
        newProduct.ID = productCount;
        newProduct.name = _name;
        newProduct.quantity = _quantity;
        newProduct.globalID = _globalID;
        newProduct.stakeholderCount = 0;
        
        // To add the process to each new products
        for(uint id=1; id<=3; id++){
            newProduct.processList[id] = process_details[id];
        }

        newProduct.currStatus = 1;
        newProduct.processList[newProduct.currStatus].active = true;
        
    }


    function addStakeholderToProduct(uint productID,string memory _name, uint supply, string memory _location, uint _temperature) public isAdminOrStakeholder isValidProductID(productID) isSupplyAcceptable(productID,supply){
        addStakeholder(_name,supply,_location,_temperature);
        uint stakeholderId = getNumberOfStakeholders();
        ProductDetails storage existingProduct = product_details[productID];
        existingProduct.stakeholderList.push(getStakeholderDetails(stakeholderId));
        existingProduct.quantity -= supply;

        if(existingProduct.quantity == 0){
            existingProduct.currStatus++;
            existingProduct.processList[existingProduct.currStatus].active = true;
        }

    }

    function getProductStakeholder(uint productID) private view isAdminOrStakeholder isValidProductID(productID) returns (StakeholderDetails[] memory){
        ProductDetails storage existingProduct = product_details[productID];
        return existingProduct.stakeholderList;
    }

    function getProductQuantity(uint productID) public view isAdminOrStakeholder isValidProductID(productID) returns(uint){
        return product_details[productID].quantity;
    }

    function getProduct(uint productID) public view isAdminOrStakeholder isValidProductID(productID) returns(uint, string memory,  uint, string memory, StakeholderDetails[] memory){
        ProductDetails storage existingProduct = product_details[productID];
        return (existingProduct.ID, existingProduct.name, existingProduct.quantity, existingProduct.globalID,getProductStakeholder(productID));
    }

    function getNumberOfProducts() private view returns(uint) {
        return productCount;
    }

    function getCurrStatus(uint productID) public view isValidProductID(productID) returns(uint) {
        ProductDetails storage existingProduct = product_details[productID];
        return existingProduct.currStatus;
    }

    function finishPasteurization(uint productID) public isAdminOrStakeholder isValidProductID(productID) {
        ProductDetails storage existingProduct = product_details[productID];
        existingProduct.currStatus++;
        existingProduct.processList[existingProduct.currStatus].active = true;
    }
    
}