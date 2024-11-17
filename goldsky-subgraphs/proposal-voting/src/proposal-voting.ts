import {
  DelegateSet as DelegateSetEvent,
  ProposalCreated as ProposalCreatedEvent,
  ProposalFinalized as ProposalFinalizedEvent,
  VotedOnProposal as VotedOnProposalEvent
} from "../generated/ProposalVoting/ProposalVoting"
import {
  DelegateSet,
  ProposalCreated,
  ProposalFinalized,
  VotedOnProposal
} from "../generated/schema"

export function handleDelegateSet(event: DelegateSetEvent): void {
  let entity = new DelegateSet(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.delegator = event.params.delegator
  entity.delegatee = event.params.delegatee

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleProposalCreated(event: ProposalCreatedEvent): void {
  let entity = new ProposalCreated(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.proposalId = event.params.proposalId
  entity.title = event.params.title
  entity.description = event.params.description
  entity.deadline = event.params.deadline
  entity.fundingTarget = event.params.fundingTarget

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleProposalFinalized(event: ProposalFinalizedEvent): void {
  let entity = new ProposalFinalized(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.proposalId = event.params.proposalId
  entity.isSuccessful = event.params.isSuccessful

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleVotedOnProposal(event: VotedOnProposalEvent): void {
  let entity = new VotedOnProposal(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.proposalId = event.params.proposalId
  entity.voter = event.params.voter

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
