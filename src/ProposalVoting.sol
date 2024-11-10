// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./GovernanceToken.sol";

contract ProposalVoting {
    GovernanceToken public governanceToken;

    // Events with indexed parameters for better indexing and tracking by Hemera
    event ProposalCreated(uint256 indexed proposalId, string title, string description);
    event VotedOnProposal(uint256 indexed proposalId, address indexed voter);

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 voteCount;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    constructor(GovernanceToken _governanceToken) {
        governanceToken = _governanceToken;
    }

    function createProposal(string memory title, string memory description) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, title, description, 0, true);
        
        // Emit an indexed event for proposal creation to facilitate tracking
        emit ProposalCreated(proposalCount, title, description);
    }

    function getProposal(uint256 proposalId) public view returns (uint256, string memory, string memory, uint256, bool) {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        return (proposal.id, proposal.title, proposal.description, proposal.voteCount, proposal.exists);
    }

    function voteOnProposal(uint256 proposalId) public {
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(!hasVoted[proposalId][msg.sender], "Already voted on this proposal");

        uint256 voterBalance = governanceToken.balanceOf(msg.sender);
        require(voterBalance > 0, "No tokens to vote");

        proposals[proposalId].voteCount += 1;
        hasVoted[proposalId][msg.sender] = true;

        // Emit an indexed event for voting to facilitate tracking
        emit VotedOnProposal(proposalId, msg.sender);
    }
}
