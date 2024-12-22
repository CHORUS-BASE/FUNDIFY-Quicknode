# Aderyn Analysis Report

This report was generated by [Aderyn](https://github.com/Cyfrin/aderyn), a static analysis tool built by [Cyfrin](https://cyfrin.io), a blockchain security company. This report is not a substitute for manual audit or security review. It should not be relied upon for any purpose other than to assist in the identification of potential security vulnerabilities.
# Table of Contents

- [Summary](#summary)
  - [Files Summary](#files-summary)
  - [Files Details](#files-details)
  - [Issue Summary](#issue-summary)
- [High Issues](#high-issues)
  - [H-1: Uninitialized State Variables](#h-1-uninitialized-state-variables)
  - [H-2: Functions send eth away from contract but performs no checks on any address.](#h-2-functions-send-eth-away-from-contract-but-performs-no-checks-on-any-address)
- [Low Issues](#low-issues)
  - [L-1: Centralization Risk for trusted owners](#l-1-centralization-risk-for-trusted-owners)
  - [L-2: Unsafe ERC20 Operations should not be used](#l-2-unsafe-erc20-operations-should-not-be-used)
  - [L-3: Solidity pragma should be specific, not wide](#l-3-solidity-pragma-should-be-specific-not-wide)
  - [L-4: Missing checks for `address(0)` when assigning values to address state variables](#l-4-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
  - [L-5: `public` functions not used internally could be marked `external`](#l-5-public-functions-not-used-internally-could-be-marked-external)
  - [L-6: Define and use `constant` variables instead of using literals](#l-6-define-and-use-constant-variables-instead-of-using-literals)
  - [L-7: Event is missing `indexed` fields](#l-7-event-is-missing-indexed-fields)
  - [L-8: PUSH0 is not supported by all chains](#l-8-push0-is-not-supported-by-all-chains)
  - [L-9: Large literal values multiples of 10000 can be replaced with scientific notation](#l-9-large-literal-values-multiples-of-10000-can-be-replaced-with-scientific-notation)
  - [L-10: State variable could be declared constant](#l-10-state-variable-could-be-declared-constant)
  - [L-11: State variable changes but no event is emitted.](#l-11-state-variable-changes-but-no-event-is-emitted)
  - [L-12: State variable could be declared immutable](#l-12-state-variable-could-be-declared-immutable)


# Summary

## Files Summary

| Key | Value |
| --- | --- |
| .sol Files | 3 |
| Total nSLOC | 193 |


## Files Details

| Filepath | nSLOC |
| --- | --- |
| src/Funding.sol | 49 |
| src/GovernanceToken.sol | 12 |
| src/ProposalVoting.sol | 132 |
| **Total** | **193** |


## Issue Summary

| Category | No. of Issues |
| --- | --- |
| High | 2 |
| Low | 12 |


# High Issues

## H-1: Uninitialized State Variables

Solidity does initialize variables by default when you declare them, however it's good practice to explicitly declare an initial value. For example, if you transfer money to an address we must make sure that the address has been initialized.

<details><summary>2 Found Instances</summary>


- Found in src/Funding.sol [Line: 24](src/Funding.sol#L24)

	```solidity
	    uint256 public proposalCounter;
	```

- Found in src/ProposalVoting.sol [Line: 33](src/ProposalVoting.sol#L33)

	```solidity
	    uint256 public proposalCount;
	```

</details>



## H-2: Functions send eth away from contract but performs no checks on any address.

Consider introducing checks for `msg.sender` to ensure the recipient of the money is as intended.

<details><summary>2 Found Instances</summary>


- Found in src/Funding.sol [Line: 85](src/Funding.sol#L85)

	```solidity
	    function withdraw(uint256 proposalId, uint256 amount) external nonReentrant {
	```

- Found in src/ProposalVoting.sol [Line: 167](src/ProposalVoting.sol#L167)

	```solidity
	    function executeProposal(uint256 proposalId) public {
	```

</details>



# Low Issues

## L-1: Centralization Risk for trusted owners

Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

<details><summary>2 Found Instances</summary>


- Found in src/Funding.sol [Line: 9](src/Funding.sol#L9)

	```solidity
	contract Funding is Ownable, ReentrancyGuard {
	```

- Found in src/Funding.sol [Line: 41](src/Funding.sol#L41)

	```solidity
	    function createProposal() external onlyOwner {
	```

</details>



## L-2: Unsafe ERC20 Operations should not be used

ERC20 functions may not behave as expected. For example: return values are not always meaningful. It is recommended to use OpenZeppelin's SafeERC20 library.

<details><summary>1 Found Instances</summary>


- Found in src/Funding.sol [Line: 90](src/Funding.sol#L90)

	```solidity
	        payable(msg.sender).transfer(amount);
	```

</details>



## L-3: Solidity pragma should be specific, not wide

Consider using a specific version of Solidity in your contracts instead of a wide version. For example, instead of `pragma solidity ^0.8.0;`, use `pragma solidity 0.8.0;`

<details><summary>2 Found Instances</summary>


- Found in src/GovernanceToken.sol [Line: 2](src/GovernanceToken.sol#L2)

	```solidity
	pragma solidity ^0.8.24;
	```

- Found in src/ProposalVoting.sol [Line: 2](src/ProposalVoting.sol#L2)

	```solidity
	pragma solidity ^0.8.24;
	```

</details>



## L-4: Missing checks for `address(0)` when assigning values to address state variables

Check for `address(0)` when assigning values to address state variables.

<details><summary>4 Found Instances</summary>


- Found in src/Funding.sol [Line: 37](src/Funding.sol#L37)

	```solidity
	        governanceToken = GovernanceToken(_governanceToken);
	```

- Found in src/ProposalVoting.sol [Line: 45](src/ProposalVoting.sol#L45)

	```solidity
	        governanceToken = _governanceToken;
	```

- Found in src/ProposalVoting.sol [Line: 46](src/ProposalVoting.sol#L46)

	```solidity
	        taikoToken = _taikoToken;
	```

- Found in src/ProposalVoting.sol [Line: 163](src/ProposalVoting.sol#L163)

	```solidity
	        targetContract = _targetContract;
	```

</details>



## L-5: `public` functions not used internally could be marked `external`

Instead of marking a function as `public`, consider marking it as `external` if it is not used internally.

<details><summary>7 Found Instances</summary>


- Found in src/ProposalVoting.sol [Line: 52](src/ProposalVoting.sol#L52)

	```solidity
	    function createProposal(
	```

- Found in src/ProposalVoting.sol [Line: 79](src/ProposalVoting.sol#L79)

	```solidity
	    function getProposal(uint256 proposalId)
	```

- Found in src/ProposalVoting.sol [Line: 100](src/ProposalVoting.sol#L100)

	```solidity
	    function delegateVote(address delegatee) public {
	```

- Found in src/ProposalVoting.sol [Line: 107](src/ProposalVoting.sol#L107)

	```solidity
	    function voteOnProposal(uint256 proposalId) public {
	```

- Found in src/ProposalVoting.sol [Line: 132](src/ProposalVoting.sol#L132)

	```solidity
	    function finalizeProposal(uint256 proposalId) public {
	```

- Found in src/ProposalVoting.sol [Line: 147](src/ProposalVoting.sol#L147)

	```solidity
	    function distributeRewards(uint256 proposalId) public {
	```

- Found in src/ProposalVoting.sol [Line: 167](src/ProposalVoting.sol#L167)

	```solidity
	    function executeProposal(uint256 proposalId) public {
	```

</details>



## L-6: Define and use `constant` variables instead of using literals

If the same constant literal value is used multiple times, create a constant state variable and reference it throughout the contract.

<details><summary>2 Found Instances</summary>


- Found in src/ProposalVoting.sol [Line: 139](src/ProposalVoting.sol#L139)

	```solidity
	        if (proposal.voteCount >= quorum && proposal.voteCount >= (voteThreshold * (governanceToken.totalSupply() + taikoToken.totalSupply())) / 100) {
	```

- Found in src/ProposalVoting.sol [Line: 152](src/ProposalVoting.sol#L152)

	```solidity
	        uint256 rewardAmount = (proposal.voteCount * rewardPercentage) / 100;
	```

</details>



## L-7: Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

<details><summary>4 Found Instances</summary>


- Found in src/Funding.sol [Line: 27](src/Funding.sol#L27)

	```solidity
	    event Withdrawn(uint256 indexed proposalId, address indexed contributor, uint256 amount);
	```

- Found in src/Funding.sol [Line: 30](src/Funding.sol#L30)

	```solidity
	    event GTRewardIssued(uint256 indexed proposalId, address indexed contributor, uint256 amount);
	```

- Found in src/ProposalVoting.sol [Line: 12](src/ProposalVoting.sol#L12)

	```solidity
	    event ProposalCreated(uint256 indexed proposalId, string title, string description, uint256 deadline, uint256 fundingTarget);
	```

- Found in src/ProposalVoting.sol [Line: 14](src/ProposalVoting.sol#L14)

	```solidity
	    event ProposalFinalized(uint256 indexed proposalId, bool isSuccessful);
	```

</details>



## L-8: PUSH0 is not supported by all chains

Solc compiler version 0.8.20 switches the default target EVM version to Shanghai, which means that the generated bytecode will include PUSH0 opcodes. Be sure to select the appropriate EVM version in case you intend to deploy on a chain other than mainnet like L2 chains that may not support PUSH0, otherwise deployment of your contracts will fail.

<details><summary>2 Found Instances</summary>


- Found in src/GovernanceToken.sol [Line: 2](src/GovernanceToken.sol#L2)

	```solidity
	pragma solidity ^0.8.24;
	```

- Found in src/ProposalVoting.sol [Line: 2](src/ProposalVoting.sol#L2)

	```solidity
	pragma solidity ^0.8.24;
	```

</details>



## L-9: Large literal values multiples of 10000 can be replaced with scientific notation

Use `e` notation, for example: `1e18`, instead of its full numeric value.

<details><summary>1 Found Instances</summary>


- Found in src/GovernanceToken.sol [Line: 11](src/GovernanceToken.sol#L11)

	```solidity
	        _mint(msg.sender, 1000000 * 10 ** decimals()); // Minting initial supply of 1 million tokens
	```

</details>



## L-10: State variable could be declared constant

State variables that are not updated following deployment should be declared constant to save gas. Add the `constant` attribute to state variables that never change.

<details><summary>2 Found Instances</summary>


- Found in src/ProposalVoting.sol [Line: 39](src/ProposalVoting.sol#L39)

	```solidity
	    uint256 public gracePeriod = 1 weeks;
	```

- Found in src/ProposalVoting.sol [Line: 40](src/ProposalVoting.sol#L40)

	```solidity
	    uint256 public rewardPercentage = 10;
	```

</details>



## L-11: State variable changes but no event is emitted.

State variable changes in this function but no event is emitted.

<details><summary>1 Found Instances</summary>


- Found in src/ProposalVoting.sol [Line: 162](src/ProposalVoting.sol#L162)

	```solidity
	    function setTargetContract(address _targetContract) external {
	```

</details>



## L-12: State variable could be declared immutable

State variables that are should be declared immutable to save gas. Add the `immutable` attribute to state variables that are only changed in the constructor

<details><summary>5 Found Instances</summary>


- Found in src/Funding.sol [Line: 21](src/Funding.sol#L21)

	```solidity
	    GovernanceToken public governanceToken;
	```

- Found in src/ProposalVoting.sol [Line: 8](src/ProposalVoting.sol#L8)

	```solidity
	    GovernanceToken public governanceToken;
	```

- Found in src/ProposalVoting.sol [Line: 9](src/ProposalVoting.sol#L9)

	```solidity
	    IERC20 public taikoToken; // Taiko token address for dual-token voting
	```

- Found in src/ProposalVoting.sol [Line: 37](src/ProposalVoting.sol#L37)

	```solidity
	    uint256 public quorum;
	```

- Found in src/ProposalVoting.sol [Line: 38](src/ProposalVoting.sol#L38)

	```solidity
	    uint256 public voteThreshold;
	```

</details>


