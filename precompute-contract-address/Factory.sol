// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Factory {
    event Deployed(address addr , uint256 salt);

    function getByteCode(address _owner, uint _foo) public pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;
        return abi.encodePacked(bytecode,abi.encode(_owner,_foo));
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
         bytes32 hash  = keccak256(abi.encodePacked(bytes1(0xff),address(this),_salt,keccak256(bytecode)));

         return address(uint160(uint256(hash)));
    }

    function deploy(bytes memory bytecode, uint _salt) public payable {
        address addr;

        assembly {
            addr := create2(callvalue(),add(bytecode,0x20),mload(bytecode),_salt)

            if iszero(extcodesize(addr)) {
                revert(0,0)
            }
        }
        emit Deployed(addr, _salt);
    }
}

contract TestContract {
    address public owner;
    uint public foo;

    constructor(address _owner, uint _foo) payable {
        owner = _owner;
        foo = _foo;
    }
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}