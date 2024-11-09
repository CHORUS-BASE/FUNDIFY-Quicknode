// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./GovernanceToken.sol";

contract ProposalVoting {
    GovernanceToken public governanceToken;

    event VotedOnProposal(uint256 proposalId, address voter);

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
    }

    function getProposal(uint256 proposalId) public view returns (uint256 id, string memory title, string memory description, uint256 voteCount, bool exists) {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        return (proposal.id, proposal.title, proposal.description, proposal.voteCount, proposal.exists);
    }

   function voteOnProposal(uint256 proposalId) public {
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(!hasVoted[proposalId][msg.sender], "Already voted on this proposal"); // Prevent double voting

        uint256 voterBalance = governanceToken.balanceOf(msg.sender);
        require(voterBalance > 0, "No tokens to vote");

        proposals[proposalId].voteCount += 1; // Increment by 1 for each address
        hasVoted[proposalId][msg.sender] = true; // Mark as voted for this proposal

        emit VotedOnProposal(proposalId, msg.sender); // Emit event for voting
    }
}

