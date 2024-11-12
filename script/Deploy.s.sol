// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/GovernanceToken.sol";
import "../src/ProposalVoting.sol";
import "../src/Funding.sol";

contract DeployScript is Script {
    function run() external {
        // Load environment variables
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Set up proposal voting parameters
        uint256 quorum = 100;         
        uint256 voteThreshold = 5000; 

        // Start Broadcasting
        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy the Governance Token
        GovernanceToken governanceToken = new GovernanceToken();
        console.log("GovernanceToken deployed at:", address(governanceToken));

        // Step 2: Deploy the ProposalVoting Contract, passing Governance Token, quorum, and voteThreshold
        ProposalVoting proposalVoting = new ProposalVoting(governanceToken, quorum, voteThreshold);
        console.log("ProposalVoting deployed at:", address(proposalVoting));

        // Step 3: Deploy the Funding Contract, passing the Governance Token address
        Funding funding = new Funding(address(governanceToken));
        console.log("Funding deployed at:", address(funding));

        // End Broadcasting
        vm.stopBroadcast();
    }
}
