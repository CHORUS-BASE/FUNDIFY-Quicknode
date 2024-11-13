import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  DelegateSet,
  ProposalCreated,
  ProposalFinalized,
  VotedOnProposal
} from "../generated/ProposalVoting/ProposalVoting"

export function createDelegateSetEvent(
  delegator: Address,
  delegatee: Address
): DelegateSet {
  let delegateSetEvent = changetype<DelegateSet>(newMockEvent())

  delegateSetEvent.parameters = new Array()

  delegateSetEvent.parameters.push(
    new ethereum.EventParam("delegator", ethereum.Value.fromAddress(delegator))
  )
  delegateSetEvent.parameters.push(
    new ethereum.EventParam("delegatee", ethereum.Value.fromAddress(delegatee))
  )

  return delegateSetEvent
}

export function createProposalCreatedEvent(
  proposalId: BigInt,
  title: string,
  description: string,
  deadline: BigInt,
  fundingTarget: BigInt
): ProposalCreated {
  let proposalCreatedEvent = changetype<ProposalCreated>(newMockEvent())

  proposalCreatedEvent.parameters = new Array()

  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "proposalId",
      ethereum.Value.fromUnsignedBigInt(proposalId)
    )
  )
  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam("title", ethereum.Value.fromString(title))
  )
  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "description",
      ethereum.Value.fromString(description)
    )
  )
  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "deadline",
      ethereum.Value.fromUnsignedBigInt(deadline)
    )
  )
  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "fundingTarget",
      ethereum.Value.fromUnsignedBigInt(fundingTarget)
    )
  )

  return proposalCreatedEvent
}

export function createProposalFinalizedEvent(
  proposalId: BigInt,
  isSuccessful: boolean
): ProposalFinalized {
  let proposalFinalizedEvent = changetype<ProposalFinalized>(newMockEvent())

  proposalFinalizedEvent.parameters = new Array()

  proposalFinalizedEvent.parameters.push(
    new ethereum.EventParam(
      "proposalId",
      ethereum.Value.fromUnsignedBigInt(proposalId)
    )
  )
  proposalFinalizedEvent.parameters.push(
    new ethereum.EventParam(
      "isSuccessful",
      ethereum.Value.fromBoolean(isSuccessful)
    )
  )

  return proposalFinalizedEvent
}

export function createVotedOnProposalEvent(
  proposalId: BigInt,
  voter: Address
): VotedOnProposal {
  let votedOnProposalEvent = changetype<VotedOnProposal>(newMockEvent())

  votedOnProposalEvent.parameters = new Array()

  votedOnProposalEvent.parameters.push(
    new ethereum.EventParam(
      "proposalId",
      ethereum.Value.fromUnsignedBigInt(proposalId)
    )
  )
  votedOnProposalEvent.parameters.push(
    new ethereum.EventParam("voter", ethereum.Value.fromAddress(voter))
  )

  return votedOnProposalEvent
}
