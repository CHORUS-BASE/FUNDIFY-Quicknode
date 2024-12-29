# Fundify Documentation

## Overview
Fundify is a decentralized platform designed to empower communities to propose, vote on, and fund public goods projects transparently and securely. It leverages blockchain technology to create an immutable and trustless system for governance and funding.

---
# Video Demo
https://www.awesomescreenshot.com/video/35049502?key=18592650ebd01a1366e6e02fcf80d7c8

## Features

### Proposal Submission
- Users can create proposals for community-reviewed projects.
- Proposals include details such as project description, funding goals, and deadlines.

### Governance Voting
- Governance tokens enable participants to vote on proposals.
- Voting is secured and recorded on-chain to ensure transparency.

### Funding System
- Approved proposals receive funds through smart contracts.
- Transactions and fund allocations are fully traceable on-chain.

### Blockchain Integration
- Powered by QuickNode for seamless blockchain interactions.
- Efficient handling of on-chain data with low latency.

---

## Tech Stack

### Smart Contracts
- **Language**: Solidity 0.8.24
- **Frameworks**: Foundry for testing and deployment
- **Libraries**: OpenZeppelin Contracts 5.1.0

### Backend
- **Blockchain Node**: QuickNode
- **Integration**: Webhooks for real-time data updates

### Frontend
- React vite

### Tools
- Ethers.js for interacting with smart contracts.
- Hardhat or Foundry for development and deployment.

---

## Installation and Setup

### Prerequisites
- Node.js (v18+)
- npm or yarn
- Foundry installed locally
- QuickNode API key

### Clone the Repository
```bash
git clone https://github.com/your-username/fundify.git
cd fundify
```



## Smart Contracts

### Key Contracts

#### 1. **GovernanceContract**
- Manages governance tokens and voting processes.
- Emits events for proposal creation and voting.

#### 2. **FundingContract**
- Handles the allocation of funds to approved proposals.
- Tracks contributions and disbursements transparently.

---

## API Integration

### Using QuickNode
Fundify integrates with QuickNode to manage on-chain interactions efficiently. Ensure you configure the QuickNode URL in the `.env` file.

### Webhooks
Fundify supports webhook integrations for receiving real-time updates on:
- Proposal submissions
- Voting outcomes
- Funding disbursements

---

## Contributing

### How to Contribute
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push the branch.
4. Create a pull request for review.

### Code Style
- Follow Solidity best practices.
- Ensure all new code includes tests.
- Run `npm run lint` before committing.

---

## License
This project is licensed under the MIT License. See the LICENSE file for details.

---

## Contact
For questions or support, please contact:
- **Lead Developer**: Anjolaoluwa Adeyemi
- **Email**: anjolaadeyemi4545@gmail.com
- **GitHub**: [your-github-profile]

---

## Roadmap

### Upcoming Features
- Tokenization for additional revenue streams.
- Integration with Layer 2 solutions for enhanced scalability.
- Advanced analytics for community engagement metrics.

### Future Plans
- Expand community governance features.
- Introduce a rewards system for active participants.
- Collaborate with non-profits and DAOs to drive adoption.


