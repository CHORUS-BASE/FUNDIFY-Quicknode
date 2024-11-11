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
    address payable private funder = payable(address(0x123));
    address payable private projectOwner = payable(address(this));

    event Withdrawn(uint256 indexed proposalId, address indexed projectOwner, uint256 amount);

    function setUp() public {
        governanceToken = new GovernanceToken();
        proposalVoting = new ProposalVoting(governanceToken);
        funding = new Funding(); 
    }

    function testProjectOwnerDeposit() public {
        uint256 proposalId = 1;

        // Fund the proposal with 1 ether
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId);

        // Check if the user's contribution to the proposal matches 1 ether
        assertEq(funding.userContributions(proposalId, projectOwner), 1 ether);
    }

    function testWithdraw() public {
        uint256 proposalId = 1;

        // Fund the proposal
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(proposalId);

        // Expect the event to be emitted for withdrawal
        vm.expectEmit(true, true, true, true);
        emit Withdrawn(proposalId, projectOwner, 0.5 ether);

        // Withdraw 0.5 ether from the proposal
        vm.prank(projectOwner);
        funding.withdraw(proposalId, 0.5 ether);

        // Check if the proposal balance matches the remaining amount
        assertEq(funding.proposalBalances(proposalId), 0.5 ether);
    }

    function testFundProposalWithZeroEther() public {
        vm.expectRevert("Must send ETH to fund");
        funding.fundProposal{value: 0}(1);
    }

    function testWithdrawMoreThanBalance() public {
    uint256 proposalId = 1;
    address user1 = address(0x1);

    // Fund the proposal as user1
    vm.deal(user1, 1 ether);
    vm.prank(user1);
    funding.fundProposal{value: 1 ether}(proposalId);

    // Attempt to withdraw more than user1's contribution
    vm.prank(user1);
    vm.expectRevert("Insufficient user contribution");
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
        funding.fundProposal{value: 1 ether}(1); // Fund proposal ID 1

        vm.prank(projectOwner);
        funding.fundProposal{value: 0.5 ether}(2); // Fund proposal ID 2

        // Verify balances are isolated per proposal
        assertEq(funding.userContributions(1, projectOwner), 1 ether); // Balance for proposal 1
        assertEq(funding.userContributions(2, projectOwner), 0.5 ether); // Balance for proposal 2
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
    address user1 = address(0x1);
    address user2 = address(0x2);

    // Ensure both users have enough Ether
    vm.deal(user1, 2 ether);
    vm.deal(user2, 2 ether);

    // Fund the contract as user1 and user2
    vm.prank(user1);
    funding.fundProposal{value: 1 ether}(proposalId);
    assertEq(funding.userContributions(proposalId, user1), 1 ether);
    assertEq(funding.proposalBalances(proposalId), 1 ether);

    vm.prank(user2);
    funding.fundProposal{value: 2 ether}(proposalId);
    assertEq(funding.userContributions(proposalId, user2), 2 ether);
    assertEq(funding.proposalBalances(proposalId), 3 ether); // Total proposal balance should be 3 Ether

    // User1 withdraws 0.5 Ether
    vm.prank(user1);
    funding.withdraw(proposalId, 0.5 ether);
    assertEq(funding.userContributions(proposalId, user1), 0.5 ether);
    assertEq(funding.proposalBalances(proposalId), 2.5 ether);

    // User2 withdraws 1 Ether
    vm.prank(user2);
    funding.withdraw(proposalId, 1 ether);
    assertEq(funding.userContributions(proposalId, user2), 1 ether);
    assertEq(funding.proposalBalances(proposalId), 1.5 ether); // Remaining balance should be 1.5 Ether
}


    receive() external payable {}
}
