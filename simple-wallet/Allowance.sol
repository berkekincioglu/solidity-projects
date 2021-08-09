// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    
      // Adding allowance 
      
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);

    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount,"You are not allowed!");
        _;
    }
    
    mapping(address => uint) public allowance;
    
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        emit AllowanceChanged(_who,msg.sender, allowance[_who],allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
    
    function setAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender,allowance[_who],_amount);
        allowance[_who] = _amount;
    }
    
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
}