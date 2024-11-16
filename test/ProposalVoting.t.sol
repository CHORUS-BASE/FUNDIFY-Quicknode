// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "../src/Funding.sol";
import "../src/ProposalVoting.sol";
import "../src/GovernanceToken.sol";

contract FundingTest is Test {
    Funding private funding;
    ProposalVoting private proposalVoting;
    GovernanceToken private governanceToken;
    IERC20 private taikoToken;
    address payable private funder = payable(address(0x123));
    address payable private projectOwner = payable(address(this));
    address private user1 = address(0x1);
    address private user2 = address(0x2);

    event Withdrawn(uint256 indexed proposalId, address indexed projectOwner, uint256 amount);

    function setUp() public {
        // Deploy GovernanceToken
        governanceToken = new GovernanceToken();

        // Mock Taiko token for dual-token functionality
        taikoToken = IERC20(address(new GovernanceToken())); // Replace with actual TaikoToken if available

        // Define the quorum and voteThreshold values for ProposalVoting
        uint256 quorum = 50000;         
        uint256 voteThreshold = 25000; 

        // Deploy ProposalVoting with the expected arguments, including Taiko token address
        proposalVoting = new ProposalVoting(governanceToken, taikoToken, quorum, voteThreshold);

        // Deploy Funding contract, passing the GovernanceToken address
        funding = new Funding(address(governanceToken));
    }

    function testProjectOwnerDeposit() public {
        uint256 proposalId = 1;
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId);
        assertEq(funding.userContributions(proposalId, projectOwner), 1 ether);
    }

    function testWithdraw() public {
        uint256 proposalId = 1;
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId);
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(proposalId, projectOwner, 0.5 ether);
        vm.prank(projectOwner);
        funding.withdraw(proposalId, 0.5 ether);
        assertEq(funding.proposalBalances(proposalId), 0.5 ether);
    }

    function testFundProposalWithZeroEther() public {
        vm.expectRevert("Must send ETH to fund");
        funding.fundProposal{value: 0}(1);
    }

    function testWithdrawMoreThanBalance() public {
        uint256 proposalId = 1;
        vm.deal(user1, 1 ether);

        // User funds the proposal
        vm.prank(user1);
        funding.fundProposal{value: 1 ether}(proposalId);

        // User attempts to withdraw more than balance
        vm.prank(user1);
        vm.expectRevert("Insufficient funds to withdraw");
        funding.withdraw(proposalId, 2 ether);
    }

    function testMultipleFundingContributions() public {
        uint256 proposalId = 1;
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId);
        vm.prank(projectOwner);
        funding.fundProposal{value: 0.5 ether}(proposalId);
        assertEq(funding.userContributions(proposalId, projectOwner), 1.5 ether);
    }

    function testProposalSpecificFunding() public {
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(1);
        vm.prank(projectOwner);
        funding.fundProposal{value: 0.5 ether}(2);
        assertEq(funding.userContributions(1, projectOwner), 1 ether);
        assertEq(funding.userContributions(2, projectOwner), 0.5 ether);
    }

    function testWithdrawEvent() public {
        uint256 proposalId = 1;
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId);
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(proposalId, projectOwner, 0.5 ether);
        funding.withdraw(proposalId, 0.5 ether);
    }

    function testMultipleUsersFundingAndWithdrawal() public {
        uint256 proposalId = 1;

        // Fund both users
        vm.deal(user1, 2 ether);
        vm.deal(user2, 2 ether);

        // User1 funds the proposal
        vm.prank(user1);
        funding.fundProposal{value: 1 ether}(proposalId);
        assertEq(funding.userContributions(proposalId, user1), 1 ether);

        // User2 funds the proposal
        vm.prank(user2);
        funding.fundProposal{value: 1.5 ether}(proposalId);
        assertEq(funding.userContributions(proposalId, user2), 1.5 ether);

        // Attempt withdrawals
        vm.prank(user1);
        funding.withdraw(proposalId, 1 ether); // Ensure withdrawal is within contribution

        vm.prank(user2);
        funding.withdraw(proposalId, 1 ether); // Partial withdrawal for user2

        // Validate final state
        assertEq(funding.userContributions(proposalId, user1), 0);
        assertEq(funding.userContributions(proposalId, user2), 0.5 ether); // Remaining balance for user2
    }

    function testExceedProposalFundingCap() public {
        uint256 proposalId = 1;

        // User attempts to fund more than the cap
        vm.prank(projectOwner);
        vm.expectRevert("Funding cap exceeded");
        funding.fundProposal{value: 11 ether}(proposalId);
    }

    function testBalanceAfterMultipleWithdrawals() public {
        uint256 proposalId = 1;
        vm.prank(projectOwner);
        funding.fundProposal{value: 3 ether}(proposalId);
        vm.prank(projectOwner);
        funding.withdraw(proposalId, 1 ether);
        assertEq(funding.proposalBalances(proposalId), 2 ether);
        vm.prank(projectOwner);
        funding.withdraw(proposalId, 0.5 ether);
        assertEq(funding.proposalBalances(proposalId), 1.5 ether);
    }

    function testMultipleProposalFundingIsolation() public {
        uint256 proposalId1 = 1;
        uint256 proposalId2 = 2;
        vm.prank(projectOwner);
        funding.fundProposal{value: 2 ether}(proposalId1);
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId2);
        assertEq(funding.proposalBalances(proposalId1), 2 ether);
        assertEq(funding.proposalBalances(proposalId2), 1 ether);
    }

    function testFractionalWithdraw() public {
        uint256 proposalId = 1;
        vm.prank(projectOwner);
        funding.fundProposal{value: 1.5 ether}(proposalId);
        vm.prank(projectOwner);
        funding.withdraw(proposalId, 0.75 ether);
        assertEq(funding.proposalBalances(proposalId), 0.75 ether);
    }

    receive() external payable {}
}
