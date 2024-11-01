// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./GovernanceToken.sol";

contract ProposalVoting {
    GovernanceToken public governanceToken;

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 voteCount;
        bool exists;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

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
    uint256 voterBalance = governanceToken.balanceOf(msg.sender);
    require(voterBalance > 0, "No tokens to vote");

    proposals[proposalId].voteCount += voterBalance; // Increment votes by voter's balance
}
}

