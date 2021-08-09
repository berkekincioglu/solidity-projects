// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './Allowance.sol';

contract SimpleWallet is Allowance {
    
    // address owner;
    
    // constructor() {
    //     owner = msg.sender;
    // }
    
    // modifier onlyOwner() {
    //     require(msg.sender == owner,"You are not authorized");
    //     _;
    // }
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    
    //Withdraw function
    
    function withdrawMoney(address payable _to , uint _amount ) public  ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance,"Contract does not have enough money");
        if(!isOwner()) {
            reduceAllowance(msg.sender,_amount);
        }
        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }

    //fallback func
    
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
    
    //Learn total balance in contract
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function renounceOwnership() public view override onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }
}