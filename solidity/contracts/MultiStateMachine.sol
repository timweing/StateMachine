pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract MultiStateMachine is Ownable {

  enum Stages {
    INIT,
    SECOND,
    THIRD,
    FINISHED
  }

  // Inidividual configuration

  struct Asset {
    // This is the current stage.
    Stages stage;
    // DEFINE YOUR ASSET here
    string fingerprint;
    bool exist;
  }

  mapping (uint256 => Asset) internal assets;

  event newAssetAdded(uint256 _id, string _content);
  event stageChanged(uint256 _id, uint8 _stage);


  // This modifier checks the asset already exists.
  modifier assetExistNot(uint256 _id) {
    require(!assets[_id].exist, "Asset already exists."); // duplicate key
    _;
  }

  // This modifier checks the asset already exists.
  modifier assetExist(uint256 _id) {
    require(assets[_id].exist, "Asset does not exist.");
    _;
  }

  // This modifier checks the required stage.
  modifier atStage(uint256 _id, Stages _stage) {
    require(assets[_id].stage == _stage, "Asset not in required stage.");
    _;
  }

  // This modifier goes to the next stage
  // after the function is done.
  modifier transitionNext(uint256 _id)
  {
    _;
    assets[_id].stage = Stages(uint8(assets[_id].stage) + 1);
    emit stageChanged(_id, uint8(assets[_id].stage));
  }

  function getStage(uint256 _id) public view returns (uint8){
    return uint8(assets[_id].stage);
  }

  function getFingerprint(uint256 _id) public view returns (string memory){
    string memory returnvalue = assets[_id].fingerprint;
    return returnvalue;
  }

  function newAsset(uint256 _id, string memory _content)
    public
    onlyOwner
    assetExistNot(_id)
  {
    assets[_id].stage = Stages.INIT;
    assets[_id].fingerprint = _content;
    assets[_id].exist = true;
    emit newAssetAdded(_id, _content);
  }

  // Inidividual implementation
  function transitionToSecond(uint256 _id)
      public
      onlyOwner
      assetExist(_id)
      atStage(_id, Stages.INIT)
      transitionNext(_id)
  {
    assets[_id].fingerprint = "first done";
  }

  function transitionToThird(uint256 _id)
      public
      onlyOwner
      assetExist(_id)
      atStage(_id, Stages.SECOND)
      transitionNext(_id)
  {
    assets[_id].fingerprint = "second done";

  }

  function transitionToFinished(uint256 _id)
      public
      onlyOwner
      assetExist(_id)
      atStage(_id, Stages.THIRD)
      transitionNext(_id)
  {
    assets[_id].fingerprint = "all done";

  }

}
