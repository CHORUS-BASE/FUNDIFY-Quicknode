// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./GovernanceToken.sol";

contract Funding is Ownable, ReentrancyGuard {
    // Mapping to track user contributions for each proposal
    mapping(uint256 => mapping(address => uint256)) public userContributions;
    // Mapping to track total balance of each proposal
    mapping(uint256 => uint256) public proposalBalances;
    // Total GT rewards per proposal
    mapping(uint256 => uint256) public proposalGTRewards;
    
    // Funding cap per proposal (optional)
    uint256 public constant FUNDING_CAP = 10 ether;

    // IERC20 instance of Governance Token (GT)
    GovernanceToken public governanceToken;

    // Proposal counter for generating unique proposal IDs
    uint256 public proposalCounter;

    // Event for withdrawal
    event Withdrawn(uint256 indexed proposalId, address indexed contributor, uint256 amount);

    // Event for GT reward issuance
    event GTRewardIssued(uint256 indexed proposalId, address indexed contributor, uint256 amount);

    // Event for proposal creation
    event ProposalCreated(uint256 indexed proposalId);

    // Constructor to set the address of the GT contract
    constructor(address _governanceToken) Ownable(msg.sender) {
        governanceToken = GovernanceToken(_governanceToken);
    }

    // Function to create a new proposal
    function createProposal() external onlyOwner {
        proposalCounter++;  // Increment the proposal ID for each new proposal
        uint256 newProposalId = proposalCounter;

        // Emit the ProposalCreated event
        emit ProposalCreated(newProposalId);

        // Further logic for storing proposal metadata can be added here
    }

    // Function for funding proposals
    function fundProposal(uint256 proposalId) external payable nonReentrant {
        require(msg.value > 0, "Must send ETH to fund");
        
        // Ensure the total balance doesn't exceed the funding cap
        require(proposalBalances[proposalId] + msg.value <= FUNDING_CAP, "Funding cap exceeded");
        
        userContributions[proposalId][msg.sender] += msg.value;
        proposalBalances[proposalId] += msg.value;

        // Issue GTs based on the contribution
        uint256 rewardAmount = calculateGTReward(proposalId, msg.value);
        proposalGTRewards[proposalId] += rewardAmount;
        
        // Mint the GT tokens for the user
        governanceToken.mint(msg.sender, rewardAmount);

        emit GTRewardIssued(proposalId, msg.sender, rewardAmount);
    }

    // Function to calculate GT reward based on contribution
    function calculateGTReward(uint256 proposalId, uint256 contributionAmount) public view returns (uint256) {
        uint256 totalFunding = proposalBalances[proposalId];
        uint256 totalRewardPool = proposalGTRewards[proposalId]; // GTs allocated for this proposal

        if (totalFunding == 0) {
            return 0;
        }

        // Simple reward calculation: proportional to the user's contribution
        return (contributionAmount * totalRewardPool) / totalFunding;
    }

    // Function for withdrawing funds by the contributor
    function withdraw(uint256 proposalId, uint256 amount) external nonReentrant {
        require(userContributions[proposalId][msg.sender] >= amount, "Insufficient funds to withdraw");

        userContributions[proposalId][msg.sender] -= amount;
        proposalBalances[proposalId] -= amount;
        payable(msg.sender).transfer(amount);

        // Emit the Withdrawn event
        emit Withdrawn(proposalId, msg.sender, amount);
    }
}
