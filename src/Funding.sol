// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Funding {
    // Mapping of proposalId to balances for each proposal
    mapping(uint256 => uint256) public proposalBalances;

    // Mapping of user contributions to each proposal
    mapping(uint256 => mapping(address => uint256)) public userContributions;

    // Events to log funding and withdrawal actions
    event ProposalFunded(uint256 indexed proposalId, address indexed contributor, uint256 amount);
    event Withdrawn(uint256 indexed proposalId, address indexed projectOwner, uint256 amount);

    // Function to fund a specific proposal
    function fundProposal(uint256 proposalId) external payable {
        require(msg.value > 0, "Must send ETH to fund");

        // Update the proposal's balance and the user's contribution for that proposal
        proposalBalances[proposalId] += msg.value;
        userContributions[proposalId][msg.sender] += msg.value;

        // Emit an event to log the funding action
        emit ProposalFunded(proposalId, msg.sender, msg.value);
    }

    // Function for the project owner to withdraw funds from a specific proposal
    function withdraw(uint256 proposalId, uint256 amount) external {
        require(proposalBalances[proposalId] >= amount, "Insufficient balance for proposal");

        // Update the proposal balance before transferring to prevent re-entrancy attacks
        proposalBalances[proposalId] -= amount;

        // Transfer the specified amount to the caller
        payable(msg.sender).transfer(amount);

        // Emit an event to log the withdrawal
        emit Withdrawn(proposalId, msg.sender, amount);
    }
}
