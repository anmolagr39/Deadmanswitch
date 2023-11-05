// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadMansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCalledBlock;

    constructor(address _beneficiary) payable {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastCalledBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function still_alive() external onlyOwner {
        lastCalledBlock = block.number;
    }

    function check() payable public {
        require(block.number - lastCalledBlock > 10, "Owner has not called still_alive in the last 10 blocks");
        payable(beneficiary).transfer(address(this).balance);    
    }

    function withdraw(uint value) payable external onlyOwner {
        payable (owner).transfer(value);
    }
    function send(uint value) payable external onlyOwner {
        payable (address(this)).transfer(value);
    }
    receive() external payable { 
        // revert();
    }
    fallback() external payable { }
}
