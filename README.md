# **Documentation**

## Overview

This documentation provides details on two smart contracts: **ProposalVoting** and **Funding**. These contracts implement a decentralized voting and funding system for proposals. Users can create proposals, vote on them using governance tokens, and contribute funds to support proposals.

---

## **Foundry**

**Foundry is a fast, portable, and modular toolkit for Ethereum application development, written in Rust.** Foundry provides several tools for building, testing, and deploying Ethereum smart contracts efficiently.

### Foundry Components

- **Forge**: An Ethereum testing framework, similar to Truffle, Hardhat, and DappTools.
- **Cast**: A versatile tool for interacting with EVM smart contracts, sending transactions, and retrieving chain data.
- **Anvil**: A local Ethereum node, comparable to Ganache or Hardhat Network, for running tests on a local blockchain.
- **Chisel**: A REPL for Solidity, offering a quick way to interact with Solidity code directly.

### Foundry Documentation
For more details, refer to the official Foundry documentation: [Foundry Book](https://book.getfoundry.sh/).

---

## **ProposalVoting Contract**

The `ProposalVoting` contract allows users to create proposals, vote on them using governance tokens, and view proposal details. It prevents multiple votes per address on the same proposal and emits events to track proposal creation and voting actions.

### **Contract Variables**

- **governanceToken**: Instance of the `GovernanceToken` contract, verifying users' token balances.
- **proposals**: A mapping of proposal IDs to `Proposal` structs, storing proposal details.
- **proposalCount**: Counter for proposal IDs, incremented with each new proposal.
- **hasVoted**: Nested mapping `(proposalId => address => bool)` to track if a user has voted on a proposal.

### **Structs**

- **Proposal**: Stores details of each proposal, including:
  - `id`: Unique proposal identifier.
  - `title`: Proposal title.
  - `description`: Proposal description.
  - `voteCount`: Count of votes received.
  - `exists`: Boolean indicating the proposal’s existence.

### **Events**

- `ProposalCreated(uint256 proposalId, string title, string description)`: Emitted when a new proposal is created.
- `VotedOnProposal(uint256 proposalId, address voter)`: Emitted when a vote is cast on a proposal.

### **Functions**

#### `createProposal(string memory title, string memory description)`
Creates a new proposal with the given title and description, increasing `proposalCount` and adding the proposal to `proposals`.

#### `getProposal(uint256 proposalId)`
Fetches details of a specific proposal, reverting if the proposal does not exist.

#### `voteOnProposal(uint256 proposalId)`
Allows a user to vote on a proposal, incrementing the vote count by `1` for each address. Prevents multiple votes from the same address on the same proposal.

---

## **Funding Contract**

The `Funding` contract enables users to contribute funds to proposals and withdraw previously contributed amounts. Contributions and withdrawals are tracked by user address.

### **Contract Variables**

- **balances**: A mapping from user address to balance, storing each user’s total contributions.

### **Events**

- `Withdrawn(address indexed projectOwner, uint256 amount)`: Emitted when a user withdraws funds.

### **Functions**

#### `fundProposal(uint256 proposalId)`
Allows users to fund a proposal with Ether. Reverts if no Ether is sent.

#### `withdraw(uint256 amount)`
Allows users to withdraw a specific amount from their balance. Reverts if the withdrawal exceeds the user’s balance.

---

## **Foundry Usage**

### Build the Contracts

To compile the contracts, run:
```shell
$ forge build
```

### Run Tests

To run the test suite, use:
```shell
$ forge test
```

### Format Code

To format Solidity code according to best practices:
```shell
$ forge fmt
```

### Generate Gas Snapshots

To obtain gas usage metrics:
```shell
$ forge snapshot
```

### Anvil: Local Ethereum Node

To start Anvil, Foundry's local Ethereum node for testing:
```shell
$ anvil
```

### Deploy Contracts

To deploy a contract, use the `forge script` command. Replace `<your_rpc_url>` and `<your_private_key>` with appropriate values.
```shell
$ forge script script/Deploy.s.sol:DeployScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast: Interact with Contracts

`Cast` provides subcommands for sending transactions, reading data, and interacting with contracts.
```shell
$ cast <subcommand>
```

### Get Help

For additional help with Foundry commands:
```shell
$ forge --help
$ anvil --help
$ cast --help
```

---

## **Testing the Contracts**

The test suite ensures that both contracts operate as expected. Here’s a summary of key tests:

### ProposalVoting Contract Tests

1. **Create Proposal**: Tests successful creation of a proposal and emits `ProposalCreated`.
2. **Vote on Proposal**: Tests that a user can vote on a proposal once and emits `VotedOnProposal`.
3. **Prevent Double Voting**: Ensures a user cannot vote multiple times on the same proposal.
4. **Proposal Existence Check**: Ensures voting fails if the proposal does not exist.

### Funding Contract Tests

1. **Fund Proposal**: Tests that funding a proposal updates user balance correctly.
2. **Withdraw Funds**: Verifies successful withdrawal and correct `Withdrawn` event emission.
3. **Prevent Over-Withdrawal**: Ensures users cannot withdraw more than their balance.
4. **Multiple Users Funding and Withdrawing**: Tests contributions and withdrawals by multiple users, verifying balance updates independently.

---
