
# FUNDIFY: A Decentralized Platform for Community-Driven Public Goods Funding

[![Project Demo](https://img.shields.io/badge/Watch%20Demo-Click%20Here-blue?style=for-the-badge&logo=youtube)](https://youtu.be/cTJ184dlIM8)

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
7. [Integrations](#integrations)
8. [Future Enhancements](#future-enhancements)

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

## 7. Integrations

### A. Taiko Helka
Taiko Helka is used as the underlying layer for blockchain transaction handling in FUNDIFY, leveraging its scalability and low-cost transaction environment. Through HeLks, FUNDIFY ensures efficient and decentralized execution of proposals, funding contributions, and fund disbursements without compromising on security or transparency.

**Usage**:
- **Transaction Processing**: Helka processes all on-chain transactions, ensuring they are both secure and cost-effective.
- **Environment Setup**: Ensure that the Taiko RPC URL is properly configured in the environment variables, as shown in the [Deployment](#deployment) section.

### B. Goldsky Subgraph
The Goldsky Subgraph integration enables efficient and real-time querying of data within the FUNDIFY platform. This enhances the user experience by allowing instant access to proposal and voting data, without needing to query the blockchain directly.

**Subgraph Features**:
- **Proposal Tracking**: Provides real-time data on all active, pending, and completed proposals.
- **Voting Statistics**: Aggregates voting information, allowing users to track voting participation and outcomes on each proposal.

**Usage**:
- Ensure that your front end connects to the Goldsky Subgraph endpoint to retrieve proposal, voting, and funding data.
- Example query for retrieving proposal data:
  ```graphql
  {
    proposals {
      id
      creator
      title
      description
      votes {
        voter
        choice
      }
    }
  }
  ```

---

## 8. Future Enhancements
- **Enhanced Governance Model**: Adding quadratic or weighted voting for more representative governance.
- **Multi-Chain Support**: Expanding beyond Taiko to support Ethereum, Binance Smart Chain, and others.
- **Reputation System**: Rewarding active contributors with governance influence, creating a reputation-based incentive layer.
  
---

## Conclusion
FUNDIFY is a decentralized solution for transparent, community-driven public goods funding. Its design prioritizes community engagement, accountability, and scalability, making it an impactful tool for funding community-led projects. 

