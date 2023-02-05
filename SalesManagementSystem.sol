//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract SalesManagementSystem{

    struct itemDesc{
        uint id;
        string name;
        uint price;
    }

    mapping(uint => itemDesc) public items;
    //For mapping Product Id with its description
    mapping(uint => uint) internal sales;
    //For mapping Product Id with the numbers of times this product has been sold


    uint internal revenue; //Amount in the smart-contract
    uint internal collection; //Total amount withdrawn

    address payable public  owner;
    address payable public  employee;

    constructor( address _employee){
        owner = payable(msg.sender);
        employee = payable(_employee);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function addItem(uint _id, string memory _name, uint _price) onlyOwner public{
        require(_id != items[_id].id, "Product with this ID Alredy Exist" );
        items[_id] = itemDesc(_id,_name,_price);
    }
    //To add a new product for the employees to sell

    function makeSales(uint _id) public payable{
        require(msg.sender == employee, "You are not the employee!");
        require(items[_id].id !=0, "Item is not in the inventory!");
        require(msg.value == items[_id].price, "Pay the correct Amount");
        sales[_id]++;
        revenue += items[_id].price;
    }
    //If employee wants to sell any product

    function withdrawRevenue() public onlyOwner {
        collection += revenue;
        owner.transfer(revenue);
        revenue = 0;
    }
    //Withdraw Earned amount in the smart contract

    function getTotalCollection() public  view onlyOwner returns(uint){
        return collection;
    }
    //Total amount earned and withdrawn

    function getTotalRevenue() public  view onlyOwner returns(uint){
        return revenue;
    }
    //Earned amount in the smart contract

    function SaleOfTheProduct(uint _id) public view onlyOwner returns(uint){
        return sales[_id];
    }
    //How many of this product has been sold
}