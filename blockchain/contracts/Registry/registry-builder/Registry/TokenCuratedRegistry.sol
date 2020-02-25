pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./TimelockableItemRegistry.sol";
import "./StakedRegistry.sol";
import "../Challenge/IChallengeFactory.sol";
import "../Challenge/IChallenge.sol";

/**
 * @title TokenCuratedRegistry
 * @dev A registry with tokenized governance of item addition and removal.
 * Based on https://github.com/skmgoldin/tcr
 */
contract TokenCuratedRegistry is Initializable, StakedRegistry, TimelockableItemRegistry {

  // amount of time to lock new items in the application phase.
  uint public applicationPeriod;

  // contract used to create new challenges.
  IChallengeFactory public challengeFactory;

  // maps item id to challenge contract addresses.
  mapping(bytes32 => IChallenge) public challenges;

  event Application(bytes32 indexed _itemid, address indexed _itemOwner, uint _applicationEndDate);

  event ItemRejected(bytes32 indexed _itemid);

  event ChallengeSucceeded(bytes32 indexed _itemid, address _challenge);

  event ChallengeFailed(bytes32 indexed _itemid, address _challenge);

  event ChallengeInitiated(bytes32 indexed _itemid, address _challenge, address _challenger);

  function initialize(
    ERC20 _token,
    uint _minStake,
    uint _applicationPeriod,
    IChallengeFactory _challengeFactory
  )
    public
    initializer
  {
    require(address(_challengeFactory) != address(0x0),
      "StakedRegistry: Token address cannot be 0x0.");

    applicationPeriod = _applicationPeriod;
    challengeFactory = _challengeFactory;
    StakedRegistry.initialize(_token, _minStake);
  }

  /**
   * @dev Overrides StakedRegistry.add(), sets unlock time to end of application period.
   * @param _id The item to add to the registry.
   */
  function add(bytes32 _id) public {
    super.add(_id);
    //solium-disable-next-line security/no-block-members
    unlockTimes[_id] = now.add(applicationPeriod);

    emit Application(_id, msg.sender, unlockTimes[_id]);
  }

  /**
   * @dev Overrides StakedRegistry.remove(), requires that there is no challenge for the item.
   * @param _id The item to remove from the registry.
   */
  function remove(bytes32 _id) public {
    require(!challengeExists(_id), "TCR: Challenge id does not exit");

    super.remove(_id);
  }

  /**
   * @dev Creates a new challenge for an item, sets msg.sender as the challenger. Requires the
   * challenger to match the item owner's stake.
   * @param _id The item to challenge.
   */
  function challenge(bytes32 _id) public {
    require(!challengeExists(_id), "TCR: Challenge already exists for item");
    require(token.transferFrom(msg.sender, address(this), minStake),
      "TCR: Token transfer for challenge failed");

    challenges[_id] = IChallenge(challengeFactory.createChallenge(address(this), msg.sender, owners[_id]));

    uint challengeFunds = challenges[_id].fundsRequired();
    require(challengeFunds <= minStake, "TCR: challengeFunds must be <= minStake");
    require(token.approve(address(challenges[_id]), challengeFunds),
      "TCR: challengeFunds approval failed");

    emit ChallengeInitiated(_id, address(challenges[_id]), msg.sender);
  }

  /**
   * @dev Resolves a challenge by allocating reward tokens to the winner, closing the challenge
   * contract, and deleting challenge state.
   * @param _id The item to challenge.
   */
  function resolveChallenge(bytes32 _id) public {
    require(challengeExists(_id), "TCR: Challenge id does not exist.");

    if(!challenges[_id].isClosed()) {
      challenges[_id].close();
    }

    uint reward = challenges[_id].winnerReward();
    if (challenges[_id].passed()) {
      // if the challenge passed, reward the challenger (via token.transfer), then remove
      // the item and all state related to it
      require(token.transfer(challenges[_id].challenger(), reward),
        "TCR: token tranfer for resolveChallenge failed");

      _reject(_id);

      emit ChallengeSucceeded(_id, address(challenges[_id]));
    } else {
      // if the challenge failed, reward the applicant (by adding to their staked balance)
      ownerStakes[_id] = ownerStakes[_id].add(reward).sub(minStake);

      address temp = address(challenges[_id]);
      delete unlockTimes[_id];
      delete challenges[_id];

      emit ChallengeFailed(_id, temp);
    }
  }

  /**
   * @dev Checks if an item is in the application phase, reverts if the item does not exist.
   * @return A bool indicating whether the item is in the application phase.
   */
  function inApplicationPhase(bytes32 id) public view returns (bool) {
    return isLocked(id);
  }

  /**
   * @dev Checks if a challenge exists for an item, reverts if the item does not exist.
   * @param id The item to check for an existing challenge.
   * @return A bool indicating whether a challenge exists for the item.
   */
  function challengeExists(bytes32 id) public view returns (bool) {
    require(_exists(id), "TCR: Item id does not exist.");

    return address(challenges[id]) != address(0x0);
  }

  /**
   * @dev Overrides BasicRegistry.exists(), adds logic to check that the item is not locked in
   * the application phase.
   * @param id The item to check for existence on the registry.
   * @return A bool indicating whether the item exists on the registry.
   */
  function exists(bytes32 id) public view returns (bool) {
    return _exists(id) && !_isLocked(id);
  }

  /**
   * @dev Internal function to reject an item from the registry by deleting all item state.
   * @param id The item to reject.
   */
  function _reject(bytes32 id) internal {
    ownerStakes[id] = 0;
    delete owners[id];
    delete unlockTimes[id];
    delete challenges[id];

    _remove(id);

    emit ItemRejected(id);
  }
}
