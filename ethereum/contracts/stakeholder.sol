// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Stakeholders {
    struct Stakeholder{
        uint id;
        string name;
        uint timestamp;
        uint [] involvedproducts;
        string description;
        address myself;
        address maker;
        bool active;

    }

    mapping(address => Stakeholder) private stakeholderAddrs;

    uint private productCount;
    uint private stakeholderCount;
    uint private processesCount;

    event updateEvent ( // triggers update complete
    );
    
    event changeStatusEvent ( // triggers status change
    );

    modifier ExistStakeholder(address _stake){
        require(exists(_stake)==true,"Error: Stakeholder does not exist");
        _;
    }

    constructor()  {
        
    }

    function addStakeholder(string memory _name, string memory _description, address _stake ) public {
        stakeholderCount++;

        stakeholderAddrs[_stake].id = stakeholderCount;
        stakeholderAddrs[_stake].name = _name;
        stakeholderAddrs[_stake].timestamp = block.timestamp;
        stakeholderAddrs[_stake].description = _description;
        stakeholderAddrs[_stake].myself = _stake;
        stakeholderAddrs[_stake].active = true; 
        stakeholderAddrs[_stake].maker = msg.sender;
        emit updateEvent();
    }

    function addStakeholderProduct(uint _id, address _stake) public {
        stakeholderAddrs[_stake].involvedproducts.push(_id);
        emit updateEvent();
    }

    function changeStatus(bool _active, address _stake) public ExistStakeholder(_stake){
        stakeholderAddrs[_stake].active = _active;
        emit changeStatusEvent();
    }

    function getStakeholdersProduct(address _stake) public view ExistStakeholder(_stake) returns (uint [] memory) {
        return stakeholderAddrs[_stake].involvedproducts;
    }

    function getNumberOfStakeholders() public view returns (uint) {
        return stakeholderCount;
    }

    function exists(address _stake) public view returns (bool) {
        if(stakeholderAddrs[_stake].active == true){
            return true;
        }
        return false;
    }
}