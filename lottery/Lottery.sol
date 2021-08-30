// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address public manager;
    
    constructor() {
        manager = msg.sender;
        players.push(payable(manager));
    }
    
    modifier onlyManager{
        require(msg.sender == manager);
        _;
    }
    
    receive() external payable {
        require(msg.value == 0.1 ether,'Only 0.1 can be sent');
        require(msg.sender != manager);
        players.push(payable(msg.sender));
    }
    
    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,players.length)));
    }
    
    function pickWinner() public onlyManager{
        require(players.length >= 3);
        
        uint r = random();
        address payable winner;
        
        uint index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance() * 90 / 100);
        payable(manager).transfer(getBalance());
        
        // players = new address payable[](0);
        delete players;
    }
    
}