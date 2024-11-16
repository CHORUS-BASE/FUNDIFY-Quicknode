// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console2.sol";  // Import console2 for logging
import "../src/GovernanceToken.sol";
import "../src/ProposalVoting.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractScript is Script {
    ProposalVoting proposalVoting;
    GovernanceToken governanceToken;
    IERC20 taikoToken; // Declare Taiko token variable

    function setUp() public {
        // Initialize contract addresses (ensure they are correct)
        proposalVoting = ProposalVoting(0x5C0cB0c0826AD6B4E85eFAd9e1eA8c94fed152DA);
        governanceToken = GovernanceToken(0xdc301e7e6D8625f14383fB9Dc8174035eC2e23D6); 
        taikoToken = IERC20(0x6490E12d480549D333499236fF2Ba6676C296011); // Address of the Taiko token contract
    }

    function run() public {
        address voter = address(this); // Script's address

        // Mint tokens to the voter (Governance token)
        uint256 mintAmount = 100 * 10 ** 18; // 100 tokens (adjust based on your token's decimals)
        try governanceToken.mint(voter, mintAmount) {
            console2.log("Minted governance tokens for voting.");
        } catch (bytes memory reason) {
            console2.log("Error minting governance tokens:");
            console2.logBytes(reason);
        }

        // Mint tokens to the voter (Taiko token)
        uint256 taikoMintAmount = 100 * 10 ** 18; // 100 Taiko tokens (adjust based on your token's decimals)
        try taikoToken.transfer(voter, taikoMintAmount) {
            console2.log("Minted Taiko tokens for voting.");
        } catch (bytes memory reason) {
            console2.log("Error minting Taiko tokens:");
            console2.logBytes(reason);
        }

        // Check the Taiko token balance of the contract (this address)
        uint256 taikoBalance = taikoToken.balanceOf(address(this)); // Get the balance of the script's contract address
        console2.log("Taiko token balance of contract: ", taikoBalance);

        // Create a proposal with a smaller funding target (1 ether)
        try proposalVoting.createProposal(
            "New Initiative", 
            "This proposal is to launch a new initiative.", 
            1 weeks, 
            ProposalVoting.Category.Development, 
            1 ether // Funding target set to 1 ether
        ) {
            console2.log("Proposal created successfully.");
        } catch (bytes memory reason) {
            console2.log("Error creating proposal:");
            console2.logBytes(reason);
        }

        // Get the proposal count and vote on the latest proposal
        uint256 proposalId = proposalVoting.proposalCount(); // Get the latest proposalId dynamically

        // Ensure that the proposal exists before voting
        try proposalVoting.voteOnProposal(proposalId) {
            console2.log("Vote cast successfully for proposal ID: ", proposalId);
        } catch (bytes memory reason) {
            console2.log("Error casting vote on proposal ID: ", proposalId);
            console2.logBytes(reason);
        }
    }
}
