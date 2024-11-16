// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/ProposalVoting.sol";
import "../src/Funding.sol";

contract DeployScript is Script {
    function run() external {
        // Load deployer private key and Taiko token address from environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address taikoTokenAddress = vm.envAddress("TAIKO_TOKEN_ADDRESS");

        // Set up proposal voting parameters
        uint256 quorum = 100;             // Minimum number of votes needed for a proposal to pass
        uint256 voteThreshold = 5000;     // Minimum amount of tokens required to vote

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy the Governance Token
        GovernanceToken governanceToken = new GovernanceToken();
        console.log("GovernanceToken deployed at:", address(governanceToken));

        // Step 2: Deploy the ProposalVoting contract with Taiko token address, quorum, and voteThreshold
        ProposalVoting proposalVoting = new ProposalVoting(governanceToken, IERC20(taikoTokenAddress), quorum, voteThreshold);
        console.log("ProposalVoting deployed at:", address(proposalVoting));

        // Step 3: Deploy the Funding contract, passing the Governance Token address
        Funding funding = new Funding(address(governanceToken));
        console.log("Funding deployed at:", address(funding));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}
