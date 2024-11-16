// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./GovernanceToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ProposalVoting {
    GovernanceToken public governanceToken;
    IERC20 public taikoToken; // Taiko token address for dual-token voting

    // Events for tracking proposal activities
    event ProposalCreated(uint256 indexed proposalId, string title, string description, uint256 deadline, uint256 fundingTarget);
    event VotedOnProposal(uint256 indexed proposalId, address indexed voter);
    event ProposalFinalized(uint256 indexed proposalId, bool isSuccessful);
    event DelegateSet(address indexed delegator, address indexed delegatee);

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
    mapping(address => address) public delegates;

    uint256 public quorum;
    uint256 public voteThreshold;
    uint256 public gracePeriod = 1 weeks;
    uint256 public rewardPercentage = 10;

    address public targetContract;

    constructor(GovernanceToken _governanceToken, IERC20 _taikoToken, uint256 _quorum, uint256 _voteThreshold) {
        governanceToken = _governanceToken;
        taikoToken = _taikoToken;
        quorum = _quorum;
        voteThreshold = _voteThreshold;
    }

    // Create a proposal with a funding target
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

    // Get the details of a proposal
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

    // Delegate votes to another address
    function delegateVote(address delegatee) public {
        require(delegatee != msg.sender, "Cannot delegate to yourself");
        delegates[msg.sender] = delegatee;
        emit DelegateSet(msg.sender, delegatee);
    }

    // Vote on a proposal
    function voteOnProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        require(proposal.isActive, "Proposal is not active");

        address voter = msg.sender;
        if (delegates[msg.sender] != address(0)) {
            voter = delegates[msg.sender];
        }

        require(!hasVoted[proposalId][voter], "Already voted on this proposal");

        uint256 governanceBalance = governanceToken.balanceOf(voter);
        uint256 taikoBalance = taikoToken.balanceOf(voter);
        uint256 totalVotingPower = governanceBalance + taikoBalance;

        require(totalVotingPower > 0, "No tokens to vote");

        proposal.voteCount += totalVotingPower;
        hasVoted[proposalId][voter] = true;

        emit VotedOnProposal(proposalId, voter);
    }

    // Finalize a proposal after the deadline
    function finalizeProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.exists, "Proposal does not exist");
        require(block.timestamp >= proposal.deadline, "Proposal is still active");

        proposal.isActive = false;

        if (proposal.voteCount >= quorum && proposal.voteCount >= (voteThreshold * (governanceToken.totalSupply() + taikoToken.totalSupply())) / 100) {
            proposal.isSuccessful = true;
        }

        emit ProposalFinalized(proposalId, proposal.isSuccessful);
    }

    // Distribute rewards to participants who voted on a successful proposal
    function distributeRewards(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.isActive, "Proposal is still active");
        require(proposal.isSuccessful, "Proposal was not successful");

        uint256 rewardAmount = (proposal.voteCount * rewardPercentage) / 100;

        // Distribute rewards to all voters
        for (uint256 i = 0; i < proposalCount; i++) {
            address voter = address(0); // You'll need a list of voters to distribute rewards to
            governanceToken.mint(voter, rewardAmount);
        }
    }

    // Set the target contract for proposal execution
    function setTargetContract(address _targetContract) external {
        targetContract = _targetContract;
    }

    // Execute a successful proposal
    function executeProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.isSuccessful, "Proposal not successful");

        (bool success, ) = targetContract.call{value: proposal.fundingTarget}("");
        require(success, "Execution failed");
    }
}
