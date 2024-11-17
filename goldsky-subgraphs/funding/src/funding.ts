import {
  GTRewardIssued as GTRewardIssuedEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  ProposalCreated as ProposalCreatedEvent,
  Withdrawn as WithdrawnEvent
} from "../generated/Funding/Funding"
import {
  GTRewardIssued,
  OwnershipTransferred,
  ProposalCreated,
  Withdrawn
} from "../generated/schema"

export function handleGTRewardIssued(event: GTRewardIssuedEvent): void {
  let entity = new GTRewardIssued(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.proposalId = event.params.proposalId
  entity.contributor = event.params.contributor
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleOwnershipTransferred(
  event: OwnershipTransferredEvent
): void {
  let entity = new OwnershipTransferred(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.previousOwner = event.params.previousOwner
  entity.newOwner = event.params.newOwner

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

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleWithdrawn(event: WithdrawnEvent): void {
  let entity = new Withdrawn(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.proposalId = event.params.proposalId
  entity.contributor = event.params.contributor
  entity.amount = event.params.amount

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
