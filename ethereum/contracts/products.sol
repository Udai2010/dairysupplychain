// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Product {
    struct ProductDetails {
        uint256 ID;
        string name;
        uint256 quantity;
        string description;
        string globalID;
        uint256[] traceProducts;
        uint256[] temperatureProducts;
        uint256 traceCount;
        uint256 temperatureCount;
    }

    // mapping the struct w.r.t productID
    mapping(uint256 => ProductDetails) private product_details;

    struct Trace {
        uint256 traceID;
        uint256 productID;
        string location;
        uint256 timestamp;
        address maker; // who is updating the location
    }

    mapping(uint256 => Trace) private traces;

    struct Temperature {
        uint256 temperatureID;
        uint256 productID;
        uint256 celsius;
        string temp_owner;
        uint256 timestamp;
        address maker; // who is updating the location
    }

    mapping(uint256 => Temperature) private temperatures;

    // It is necessary to have the count since we cannot loop the mapped elements
    uint256 productCount;
    uint256 traceCount;
    uint256 temperatureCount;

    address stakeholder;
    address admin;

    // events (i.e. to notify the stakeholder)
    bool trigger;
    bool delivery;
    bool recieved;

    // while deploying the contract the admin must specify who is the stakeholder
    constructor(address stakeholder_address) {
        admin = msg.sender;
        stakeholder = stakeholder_address;
        trigger = false;
        delivery = false;
        recieved = false;
    }

    // Modifiers required for our contract

    // To ensure whether the user is an admin
    modifier isAdmin() {
        require(msg.sender == admin);
        _;
    }

    // To ensure whether the user is a stakeholder
    modifier isStakeholder() {
        require(msg.sender == stakeholder);
        _;
    }

    // Either admin or stakeholder
    modifier isAdminOrStakeholder() {
        require(msg.sender == admin || msg.sender == stakeholder);
        _;
    }

    // To ensure the given product is valid
    modifier isValidProductID(uint256 _productID) {
        require(_productID > 0 && _productID <= productCount);
        _;
    }

    modifier isValidTraceID(uint256 _traceID) {
        require(_traceID > 0 && _traceID <= traceCount);
        _;
    }

    modifier isValidTemperatureID(uint256 _temperatureID) {
        require(_temperatureID > 0 && _temperatureID <= temperatureCount);
        _;
    }

    // events
    event triggeredEvent();

    event updatedEvent();

    event reqEvent(uint256 indexed productID);

    // functions required for our contract
    // product
    function addProduct(
        string memory _name,
        uint256 _quantity,
        string memory _description,
        string memory _globalID
    ) public isAdminOrStakeholder {
        ProductDetails storage newProduct = product_details[++productCount];
        newProduct.ID = productCount;
        newProduct.name = _name;
        newProduct.quantity = _quantity;
        newProduct.description = _description;
        newProduct.globalID = _globalID;
    }

    function getProduct(uint256 productID)
        public
        isAdminOrStakeholder
        isValidProductID(productID)
        returns (
            uint256,
            string memory,
            uint256,
            string memory,
            string memory
        )
    {
        ProductDetails storage existingProduct = product_details[productID];
        emit reqEvent(productID);
        return (
            existingProduct.ID,
            existingProduct.name,
            existingProduct.quantity,
            existingProduct.description,
            existingProduct.globalID
        );
    }

    function updateProductDescription(
        uint256 productID,
        string memory newDescription
    ) public isAdminOrStakeholder isValidProductID(productID) {
        ProductDetails storage existingProduct = product_details[productID];
        existingProduct.description = newDescription;
        emit updatedEvent();
    }

    function getNumberOfProducts() public view returns (uint256) {
        return productCount;
    }

    function getProductGlobalID(uint256 productID)
        public
        view
        isValidProductID(productID)
        returns (string memory)
    {
        return product_details[productID].globalID;
    }

    // Trace
    function addTrace(uint256 _productID, string memory _location)
        public
        isAdminOrStakeholder
        isValidProductID(_productID)
    {
        Trace storage newTraceProduct = traces[++traceCount];
        newTraceProduct.traceID = traceCount;
        newTraceProduct.productID = _productID;
        newTraceProduct.location = _location;
        newTraceProduct.timestamp = block.timestamp;
        newTraceProduct.maker = msg.sender;
        product_details[_productID].traceProducts.push(traceCount);
        product_details[_productID].traceCount++;

        emit updatedEvent();
    }

    function getNumberOfTraces() public view returns (uint256) {
        return traceCount;
    }

    function getTrace(uint256 traceID)
        public
        view
        isAdminOrStakeholder
        isValidTraceID(traceID)
        returns (
            uint256,
            uint256,
            string memory,
            uint256,
            address
        )
    {
        Trace storage existingTrace = traces[traceID];
        return (
            existingTrace.traceID,
            existingTrace.productID,
            existingTrace.location,
            existingTrace.timestamp,
            existingTrace.maker
        );
    }

    function getNumberOfTracesProduct(uint256 productID)
        public
        view
        isAdminOrStakeholder
        isValidProductID(productID)
        returns (uint256)
    {
        return product_details[productID].traceCount;
    }

    function getTracesProduct(uint256 productID)
        public
        view
        isAdminOrStakeholder
        isValidProductID(productID)
        returns (uint256[] memory)
    {
        return product_details[productID].traceProducts;
    }

    // Temperature
    function addTemperature(uint256 _productID, uint256 _celsius)
        public
        isAdminOrStakeholder
        isValidProductID(_productID)
    {
        Temperature storage newTemperature = temperatures[++temperatureCount];
        newTemperature.temperatureID = temperatureCount;
        newTemperature.productID = _productID;
        newTemperature.celsius = _celsius;
        newTemperature.timestamp = block.timestamp;
        newTemperature.maker = msg.sender;

        emit updatedEvent();
    }

    function getNumberOfTemperatures() public view returns (uint256) {
        return temperatureCount;
    }

    function getTemperature(uint256 temperatureID)
        public
        view
        isAdminOrStakeholder
        isValidTemperatureID(temperatureID)
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        Temperature storage existingTemperature = temperatures[temperatureID];
        return (
            existingTemperature.temperatureID,
            existingTemperature.productID,
            existingTemperature.celsius,
            existingTemperature.timestamp,
            existingTemperature.maker
        );
    }

    function getNumberOfTemperaturesProduct(uint256 productID)
        public
        view
        isAdminOrStakeholder
        isValidProductID(productID)
        returns (uint256)
    {
        return product_details[productID].temperatureCount;
    }

    function getTemperaturesProduct(uint256 productID)
        public
        view
        isAdminOrStakeholder
        isValidProductID(productID)
        returns (uint256[] memory)
    {
        return product_details[productID].temperatureProducts;
    }

    function triggerContract() public {
        trigger = true;
        emit triggeredEvent();
    }
}
