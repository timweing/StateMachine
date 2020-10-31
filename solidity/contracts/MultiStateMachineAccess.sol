pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";

contract MultiStateMachine is AccessControl {

  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
  bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
  bytes32 public constant STAGE_CHANGER_ROLE = keccak256("STAGE_CHANGER_ROLE");
  bytes32 public constant FINISHER_ROLE = keccak256("FINISHER_ROLE");

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

  constructor(address _creator, address _changer, address _finisher) public {
    _setupRole(ADMIN_ROLE, msg.sender);
    _setupRole(CREATOR_ROLE, _creator);
    _setupRole(STAGE_CHANGER_ROLE, _changer);
    _setupRole(FINISHER_ROLE, _finisher);
  }

  // This modifier checks the asset is new.
  modifier assetNew(uint256 _id) {
    require(!assets[_id].exist, "Asset already exists."); // duplicate key
    _;
  }

  // This modifier checks the asset already exists.
  modifier assetExist(uint256 _id) {
    require(assets[_id].exist, "Asset does not exist.");
    _;
  }

  // This modifier checks the sender is creator.
  modifier onlyCreator() {
    require(hasRole(CREATOR_ROLE, msg.sender), "Caller is not a asset creator");
    _;
  }

  // This modifier checks the sender is stage changer.
  modifier onlyStageChanger() {
    require(hasRole(STAGE_CHANGER_ROLE, msg.sender), "Caller is not a stage changer");
    _;
  }

  // This modifier checks the sender is finisher.
  modifier onlyFinisher() {
    require(hasRole(FINISHER_ROLE, msg.sender), "Caller is not a finisher");
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
    onlyCreator
    assetNew(_id)
  {
    assets[_id].stage = Stages.INIT;
    assets[_id].fingerprint = _content;
    assets[_id].exist = true;
    emit newAssetAdded(_id, _content);
  }

  // Inidividual implementation
  function transitionToSecond(uint256 _id)
      public
      onlyStageChanger
      assetExist(_id)
      atStage(_id, Stages.INIT)
      transitionNext(_id)
  {
    assets[_id].fingerprint = "first done";
  }

  function transitionToThird(uint256 _id)
      public
      onlyStageChanger
      assetExist(_id)
      atStage(_id, Stages.SECOND)
      transitionNext(_id)
  {
    assets[_id].fingerprint = "second done";
  }

  function transitionToFinished(uint256 _id)
      public
      onlyFinisher
      assetExist(_id)
      atStage(_id, Stages.THIRD)
      transitionNext(_id)
  {
    assets[_id].fingerprint = "all done";
  }

}
