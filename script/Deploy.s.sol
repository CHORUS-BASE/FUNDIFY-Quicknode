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

        // Start Broadcasting
        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy the Governance Token
        GovernanceToken governanceToken = new GovernanceToken();
        console.log("GovernanceToken deployed at:", address(governanceToken));

        // Step 2: Deploy the ProposalVoting Contract, passing the Governance Token address
        ProposalVoting proposalVoting = new ProposalVoting(governanceToken);
        console.log("ProposalVoting deployed at:", address(proposalVoting));

        // Step 3: Deploy the Funding Contract, passing the ProposalVoting contract address
        Funding funding = new Funding();
        console.log("Funding deployed at:", address(funding));

        // End Broadcasting
        vm.stopBroadcast();
    }
}