// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine{
    address public  owner;
    mapping (address=>uint) public  donuntBalances;
    constructor(){
        owner = msg.sender;
        donuntBalances[address(this)] = 100;
    }
    function getVendingMachineBalance() public  view returns (uint){
        return donuntBalances[address(this)];
    }
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner can restock this machine");
        donuntBalances[address(this)] += amount;
    }
    function purchase(uint amount) public  payable {
        require(msg.value >= amount* 2 ether, "You enought donut to fullfill purchase request");
        donuntBalances[address(this)] -= amount;
        donuntBalances[msg.sender] += amount;
    }
}