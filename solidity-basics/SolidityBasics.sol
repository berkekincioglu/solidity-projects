// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/PaymentSplitter.sol";

 contract Owned {
        address owner;
        
        constructor() {
            owner = msg.sender;
        }
        
        modifier onlyOwner() {
        require(msg.sender == owner,"Error message");
        _;
    }
}

contract MyContract   is Owned  {
    
//    Solidity basics

     using PaymentSplitter for uint;
    
     string public myString = "hello world";
     uint public myInt = 123 / uint(10) ;
     
     function getString() external view returns(string memory) {
         return  myString;
     }
     
     // Variables 
     
     uint256 public myUint; 
     
     function setMyUint(uint _myUint) public {
         myUint = _myUint;
     }
     
     bool public myBool;
     
     function setMyBool (bool _myBool) public {
         myBool = _myBool;
     }
     
     uint8 public myUint8;
     
     function incrementUint() public {
         myUint8++;
     }
     
     function decrementUint() public {
         myUint8--;
     }
     
     address public myAddress;
     
     function setAddress(address _myAddress) public {
         myAddress = _myAddress;
     }
     
     function getBalanceOfAddress() public view returns(uint) {
         return myAddress.balance;
     }
     
    function setMyString(string calldata _myString) public {
        myString = _myString;
    }
    
    //Address
    
    // uint public balanceRecieved;
    
    function receiveMoney() public payable {
         balanceRecieved[msg.sender].totalBalance += msg.value;
    }
    
    function getBalance() view public returns(uint){
         return address(this).balance;
     }
    
     function withDrawMoney() public {
         address payable to = payable(msg.sender);
         to.transfer(this.getBalance());
     }
    
      function withDrawMoneyTo(address payable _to) public {
         _to.transfer(this.getBalance());
     }
     
    //  Start, Stop, Pause, Delete Smart Contracts 
  
    address owner;
    bool public paused;
    
    constructor() {
        owner = msg.sender;
    }
    
    function sendMoney() public payable{
    
    }
    
    function setPaused(bool _paused) public {
        require(msg.sender == owner , "Error message");
        paused = _paused;
    }
    
    function withdrawAllMoney(address payable _to) public {
        require(msg.sender == owner,"Error message");
        require(!paused,"Error message");
        _to.transfer(address(this).balance);
    }
    
    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner,"Error message");
        selfdestruct(_to);
    }
    
    // Mapping 
    
    mapping(uint => bool) public myMapping;
    mapping(address => bool) public myAddressMapping;
    
    function setValue(uint _index) public {
        myMapping[_index] = true;
    }
    
     function setAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }
    
    //Mapping example
    
      //Struct
    
    
    
    struct Paymnet {
        uint amount;
        uint timestamps;
    }
    
    struct Balance {
        uint totalBalance;
        uint numPayments;
        mapping(uint => Paymnet) payments;
    }
    
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function sendMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;
        
        Paymnet memory payment = Paymnet(msg.value, block.timestamp);
        
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numPayments] = payment;
        balanceReceived[msg.sender].numPayments++;
    } 
    
    function withdrawMoney(address payable _to, uint _amount) public {
        require(balanceReceived[msg.sender].totalBalance >= _amount,"Not enough funds");
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
  
    function withdrawAllMoney(address payable _to) public  {
        uint balanceToSend = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(balanceToSend);
    }
    
    
    // assert(balanceReceived[msg.sender] + uint64(msg.value) >= balanceReceived[msg.sender]);
    
    // if(amount > msg.value / 2 ether) {
    //     revert("Error message");
    // }
    
    
    // require(amount <= msg.value / 2 ether, "Error message");
   
//    Constructor FallBack Function View/Pure Getter Functions
   
    fallback () external payable {
        receiveMoney();
    } 
  
   // Inheritance Modifier
    
    
        
    

    mapping(address => uint) public tokenBalance;
    address owner;
    uint tokenPrice = 1 ether;

    constructor()  {
        owner = msg.sender;
        tokenBalance[owner] = 100;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner,"Error message");
        _;
    }
    
    function createNewToken() public onlyOwner {
        
        tokenBalance[owner]++;
    }
    
    function burnToken() public onlyOwner {
        
        tokenBalance[owner]--;
    }
    
    function purchaseToken() public payable {
        require((tokenBalance[owner] * tokenPrice) / msg.value > 0,"Error message");
        tokenBalance[owner] -= msg.value / tokenPrice;
        tokenBalance[msg.sender] += msg.value / tokenPrice;
    }
    
    event sentTokens(address _to, uint _amount);
    
    function sendToken(address _to, uint _amount) public view {
        require(tokenBalance[msg.sender] >= _amount, "Error");
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
        
        emit sentTokens(_to,_amount);
    }
    
    
}