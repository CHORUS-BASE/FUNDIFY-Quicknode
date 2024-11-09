
# FUNDIFY: A Decentralized Platform for Community-Driven Public Goods Funding

## Project Structure
```plaintext
├── script
│   └── Deploy.s.sol                 # Deployment script for deploying contracts
├── src
│   ├── Funding.sol                   # Manages funding contributions and fund disbursements
│   ├── GovernanceToken.sol           # ERC-20 token for voting and rewards
│   └── ProposalVoting.sol            # Handles proposal creation, voting, and decision logic
└── test
    └── ProposalVoting.t.sol          # Unit tests for the ProposalVoting contract
```

---

## Table of Contents
1. [Overview](#overview)
2. [Project Motivation](#project-motivation)
3. [Key Features](#key-features)
4. [Smart Contract Overview](#smart-contract-overview)
5. [Deployment](#deployment)
6. [Testing](#testing)
7. [Future Enhancements](#future-enhancements)

---

## 1. Overview
**FUNDIFY** is a decentralized platform enabling communities to fund, propose, and vote on public goods projects. It leverages blockchain technology to offer secure, transparent funding and governance.

---

## 2. Project Motivation
Current funding mechanisms for public goods face challenges in transparency and community involvement. FUNDIFY addresses these with a decentralized, token-based platform where users can:
- Propose public projects
- Vote on project proposals
- Contribute funds transparently

---

## 3. Key Features
- **Proposal Creation and Voting**: Allows users to submit and vote on proposals for community projects.
- **Token-Based Governance**: Uses an ERC-20 token for voting and incentives.
- **Secure Funding**: Contributions are held securely until project milestones are achieved.

---

## 4. Smart Contract Overview

### A. Funding.sol
Manages funding contributions, tracks funds in escrow, and releases them based on project milestones. Key functions:
- `contribute`: Allows users to contribute funds to a project.
- `releaseFunds`: Releases funds to a project upon reaching a milestone.

### B. GovernanceToken.sol
Implements an ERC-20 token to serve as a voting and reward mechanism. Key functions:
- `mint`: Mints new tokens for rewarding participants.
- `burn`: Burns tokens when needed, providing flexibility for governance mechanisms.

### C. ProposalVoting.sol
Handles the proposal creation and voting process. Key functions:
- `createProposal`: Allows users to submit new project proposals.
- `vote`: Allows token holders to vote on active proposals.
- `executeProposal`: Executes proposals once voting has concluded and thresholds are met.

---

## 5. Deployment
### Setting Up Environment Variables
To deploy contracts to the Taiko network, set up environment variables:
```bash
export PRIVATE_KEY="your_private_key_with_0x_prefix"
export TAIKO_RPC_URL="https://rpc.hekla.taiko.xyz"
```

### Deployment Command
Use Foundry's `forge` tool to deploy contracts:
```bash
forge script script/Deploy.s.sol:DeployScript --rpc-url $TAIKO_RPC_URL --private-key $PRIVATE_KEY --broadcast --slow -vvvv
```

This command deploys all the necessary smart contracts to the Taiko network and broadcasts the transaction.

---

## 6. Testing
Testing is set up in the `test` directory, where unit tests validate the key functionality of the `ProposalVoting.sol` contract.

### Running Tests
Run tests using Foundry’s `forge` testing framework:
```bash
forge test --match-path test/ProposalVoting.t.sol
```

This command verifies that the core features, such as proposal creation, voting, and fund disbursement, work as expected.

---

## 7. Future Enhancements
- **Enhanced Governance Model**: Adding quadratic or weighted voting for more representative governance.
- **Multi-Chain Support**: Expanding beyond Taiko to support Ethereum, Binance Smart Chain, and others.
- **Reputation System**: Rewarding active contributors with governance influence, creating a reputation-based incentive layer.
  
---

## Conclusion
FUNDIFY is a decentralized solution for transparent, community-driven public goods funding. Its design prioritizes community engagement, accountability, and scalability, making it an impactful tool for funding community-led projects.
