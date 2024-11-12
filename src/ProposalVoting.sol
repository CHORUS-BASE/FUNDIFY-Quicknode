// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./GovernanceToken.sol";

contract ProposalVoting {
    GovernanceToken public governanceToken;

    // Events for tracking proposal activities
    event ProposalCreated(uint256 indexed proposalId, string title, string description, uint256 deadline, uint256 fundingTarget);
    event VotedOnProposal(uint256 indexed proposalId, address indexed voter);
    event ProposalFinalized(uint256 indexed proposalId, bool isSuccessful);
    event DelegateSet(address indexed delegator, address indexed delegatee);

    // Proposal Categories
    enum Category { Development, Marketing, Research }

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 voteCount;
        uint256 deadline;
        Category category;
        uint256 fundingTarget;
        bool exists;
        bool isActive;
        bool isSuccessful;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // Delegation system for voting power
    mapping(address => address) public delegates;

    // Proposal requirements
    uint256 public quorum;
    uint256 public voteThreshold;
    uint256 public gracePeriod = 1 weeks; // Example grace period duration
    uint256 public rewardPercentage = 10; // Percentage reward for successful proposal voters

    constructor(GovernanceToken _governanceToken, uint256 _quorum, uint256 _voteThreshold) {
        governanceToken = _governanceToken;
        quorum = _quorum;
        voteThreshold = _voteThreshold;
    }

    function createProposal(
        string memory title,
        string memory description,
        uint256 duration,
        Category category,
        uint256 fundingTarget
    ) public {
        proposalCount++;
        uint256 deadline = block.timestamp + duration;

        proposals[proposalCount] = Proposal({
            id: proposalCount,
            title: title,
            description: description,
            voteCount: 0,
            deadline: deadline,
            category: category,
            fundingTarget: fundingTarget,
            exists: true,
            isActive: true,
            isSuccessful: false
        });

        emit ProposalCreated(proposalCount, title, description, deadline, fundingTarget);
    }

    function getProposal(uint256 proposalId)
        public
        view
        returns (uint256, string memory, string memory, uint256, uint256, Category, uint256, bool, bool)
    {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        return (
            proposal.id,
            proposal.title,
            proposal.description,
            proposal.voteCount,
            proposal.deadline,
            proposal.category,
            proposal.fundingTarget,
            proposal.isActive,
            proposal.isSuccessful
        );
    }

    function delegateVote(address delegatee) public {
        require(delegatee != msg.sender, "Cannot delegate to yourself");
        delegates[msg.sender] = delegatee;
        emit DelegateSet(msg.sender, delegatee);
    }

    function voteOnProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        require(proposal.isActive, "Proposal is not active");

        address voter = msg.sender;
        if (delegates[msg.sender] != address(0)) {
            voter = delegates[msg.sender];
        }

        require(!hasVoted[proposalId][voter], "Already voted on this proposal");

        uint256 voterBalance = governanceToken.balanceOf(voter);
        require(voterBalance > 0, "No tokens to vote");

        // Add weighted votes based on the balance of the voter
        proposal.voteCount += voterBalance;
        hasVoted[proposalId][voter] = true;

        emit VotedOnProposal(proposalId, voter);
    }

    function finalizeProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        require(block.timestamp >= proposal.deadline, "Proposal is still active");

        proposal.isActive = false;

        // Check if proposal meets quorum and vote threshold
        if (proposal.voteCount >= quorum && proposal.voteCount >= (voteThreshold * governanceToken.totalSupply()) / 100) {
            proposal.isSuccessful = true;
        }

        emit ProposalFinalized(proposalId, proposal.isSuccessful);
    }

    function distributeRewards(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.isActive, "Proposal is still active");
        require(proposal.isSuccessful, "Proposal was not successful");

        // Example reward logic: distribute reward to each voter
        uint256 rewardAmount = (proposal.voteCount * rewardPercentage) / 100;
        governanceToken.mint(msg.sender, rewardAmount); // Minting rewards for each participant who voted
    }

    address public targetContract;

    function executeProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.isSuccessful, "Proposal not successful");

        // Placeholder for execution logic
        (bool success, ) = targetContract.call{value: proposal.fundingTarget}("");
        require(success, "Execution failed");
    }
}
