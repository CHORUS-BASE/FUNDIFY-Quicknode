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

    event Withdrawn(address indexed projectOwner, uint256 amount);

    function setUp() public {
        governanceToken = new GovernanceToken();
        proposalVoting = new ProposalVoting(governanceToken);
        funding = new Funding(); 
    }

    function testProjectOwnerDeposit() public {
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(1);
        assertEq(funding.balances(projectOwner), 1 ether);
    }

    function testWithdraw() public {
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(1);

        vm.expectEmit(true, true, true, true);
        emit Withdrawn(projectOwner, 0.5 ether);

        vm.prank(projectOwner);
        funding.withdraw(0.5 ether);
        assertEq(funding.balances(projectOwner), 0.5 ether);
    }

    function testFundProposalWithZeroEther() public {
        vm.expectRevert("Must send ETH to fund");
        funding.fundProposal{value: 0}(1);
    }

    function testWithdrawMoreThanBalance() public {
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(1);

        vm.expectRevert("Insufficient balance");
        funding.withdraw(2 ether);
    }

    function testMultipleFundingContributions() public {
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(1);
        funding.fundProposal{value: 0.5 ether}(1);

        assertEq(funding.balances(projectOwner), 1.5 ether);
    }

    function testWithdrawEvent() public {
        vm.prank(projectOwner);
        funding.fundProposal{value: 1 ether}(1);

        vm.expectEmit(true, true, true, true);
        emit Withdrawn(projectOwner, 0.5 ether);

        funding.withdraw(0.5 ether);
    }
function testMultipleUsersFundingAndWithdrawal() public {
    address user1 = address(0x1);
    address user2 = address(0x2);

    // Fund the contract as user1 and user2
    vm.prank(user1);
    funding.fundProposal{value: 1 ether}(1); // User1 funds 1 Ether

    vm.prank(user2);
    funding.fundProposal{value: 2 ether}(1); // User2 funds 2 Ether

    // Verify balances for user1 and user2 in Funding contract
    assertEq(funding.balances(user1), 1 ether);
    assertEq(funding.balances(user2), 2 ether);

    // User1 withdraws 0.5 Ether
    vm.prank(user1);
    funding.withdraw(0.5 ether);
    assertEq(funding.balances(user1), 0.5 ether); // User1’s remaining balance should be 0.5 Ether

    // User2 withdraws 1 Ether
    vm.prank(user2);
    funding.withdraw(1 ether);
    assertEq(funding.balances(user2), 1 ether); // User2’s remaining balance should be 1 Ether

    // Check contract balance if necessary
    assertEq(address(funding).balance, 2.5 ether); // Contract’s remaining balance should be 2.5 Ether
}


    receive() external payable {}
}
