# StateMachine

This repository contains several implementations of StateMachines as Solidity Smart Contracts

## SimpleStateMachine.sol
This contract contains four stages and implements transitions to the respective next phase (one directional). Only the owner of the contract can perform these actions.

## SimpleBidirectionalStateMachine.sol
This contract contains four stages and implements transitions to the respective next  and previous phase (bidirectional). Only the owner of the contract can perform these actions.

## MultiStateMachine.sol
This contract contains four stages and a list of different assets that can be created. For each asset the stage can independently changed to the next phase. New assets can be allocated. Only the owner of the contract can perform these actions.

## MultiStateMachineAccess.sol
This contract is similar to `MultiStateMachine.sol` but implemnts a more advanced access control.  
