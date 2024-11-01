// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Funding {
    mapping(address => uint256) public balances;
    
    function fundProposal(uint256) external payable {
        require(msg.value > 0, "Must send ETH to fund");
        balances[msg.sender] += msg.value; // Update balance for the sender
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        
        emit Withdrawn(msg.sender, amount); // Emit event on withdrawal
    }
    
    event Withdrawn(address indexed projectOwner, uint256 amount);
}