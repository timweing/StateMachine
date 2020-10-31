pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SimpleBidirectionalStateMachine is Ownable {

  enum Stages {
    INIT,
    SECOND,
    THIRD,
    FINISHED
  }

  // This is the current stage.
  Stages public stage = Stages.INIT;

  // This modifier checks the required stage.
  modifier atStage(Stages _stage) {
    require(stage == _stage);
    _;
  }

  // This modifier goes to the next stage
  // after the function is done.
  modifier transitionNext()
  {
    _;
    stage = Stages(uint(stage) + 1);
  }

  // This modifier goes to the previous stage
  // after the function is done.
  modifier transitionPrevious()
  {
    _;
    stage = Stages(uint(stage) - 1);
  }

  function getStage() public view returns (uint8){
    return uint8(stage);
  }

  // Inidividual implementation

  string public test = "empty";

  function transitionToSecond()
      public
      onlyOwner
      atStage(Stages.INIT)
      transitionNext
  {
    test = "first done";
  }

  function transitionToThird()
      public
      onlyOwner
      atStage(Stages.SECOND)
      transitionNext
  {
    test = "second done";
  }

  function transitionToFinished()
      public
      onlyOwner
      atStage(Stages.THIRD)
      transitionNext
  {
    test = "all done";
  }

  function transitionFromSecond()
      public
      onlyOwner
      atStage(Stages.SECOND)
      transitionPrevious
  {
    test = "back to first";
  }

  function transitionFromThird()
      public
      onlyOwner
      atStage(Stages.THIRD)
      transitionPrevious
  {
    test = "back to second";
  }

  function transitionFromFinished()
      public
      onlyOwner
      atStage(Stages.FINISHED)
      transitionPrevious
  {
    test = "back to third";

  }

}
