// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Processes {
    struct process {
        uint256 Id; //id of the product
        uint256 timestamp; // registered time
        string name; //name of the product
        string description;
        bool active;
        uint256[] involvedProducts;
        uint256 localProducts;
    }
    uint256 private processCount;
    uint256 private productsCount;
    mapping(uint256 => process) private processAdd;

    modifier productExist(uint256 _id) {
        require(productsCount >= _id);
        _;
    }
    modifier isValid(uint256 _id) {
        require(_id > 0 && _id <= processCount);
        _;
    }

    // add process
    function addProcess(string memory _name, string memory _description)
        public
    {
        processCount++;
        processAdd[processCount].Id = processCount;
        processAdd[processCount].name = _name;
        processAdd[processCount].timestamp = block.timestamp;
        processAdd[processCount].description = _description;
        processAdd[processCount].active = true;
        processAdd[processCount].localProducts = 0;
    }

    function addProcessProduct(uint256 _id) public productExist(_id) {
        processAdd[processCount].involvedProducts.push(_id);
    }

    function getNumberofProductsProcess(uint256 _id)
        public
        view
        isValid(_id)
        returns (uint256)
    {
        return processAdd[_id].localProducts;
    }

    function getNumberOfProcesses() public view returns (uint256) {
        return processCount;
    }

    function getProcess(uint256 _processId)
        public
        view
        returns (
            uint256,
            uint256,
            string memory,
            string memory,
            bool,
            uint256[] memory,
            uint256
        )
    {
        require(_processId > 0 && _processId <= processCount);
        process storage existingProcess = processAdd[_processId];
        return (
            existingProcess.Id,
            existingProcess.timestamp,
            existingProcess.name,
            existingProcess.description,
            existingProcess.active,
            existingProcess.involvedProducts,
            existingProcess.localProducts
        );
    }

    function getProcessProduct(uint256 _id)
        public
        view
        isValid(_id)
        returns (uint256[] memory)
    {
        return processAdd[_id].involvedProducts;
    }

    function changeStatus(uint256 _id, bool _active) public {
        require(_id > 0 && _id <= processCount);
        processAdd[processCount].active = _active;
    }
}
