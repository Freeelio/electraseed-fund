pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol";
import "./OwnedItemRegistry.sol";

/**
 * @title StakedRegistry
 * @dev A registry that lets owners stake tokens on items.
 */
contract StakedRegistry is Initializable, OwnedItemRegistry {
  using SafeMath for uint;

  // token used for item stake.
  ERC20 public token;

  // minimum required amount of tokens to add an item.
  uint public minStake;

  // maps item id to owner stake amount.
  mapping(bytes32 => uint) public ownerStakes;

  event NewStake(bytes32 indexed itemid, uint totalStake);

  event StakeIncreased(bytes32 indexed itemid, uint totalStake, uint increaseAmount);

  event StakeDecreased(bytes32 indexed itemid, uint totalStake, uint decreaseAmount);

  function initialize(ERC20 _token, uint _minStake) public initializer {
    require(address(token) != address(0x0), "StakedRegistry: Token address cannot be 0x0.");

    token = _token;
    minStake = _minStake;
  }

  /**
   * @dev Overrides OwnedItemRegistry.add(), transfers tokens from owner, sets stake.
   * @param _id The item to add to the registry.
   */
  function add(bytes32 _id) public {
    require(token.transferFrom(msg.sender, address(this), minStake),
      "StakedRegistry: Token transfer for adding item failed.");

    super.add(_id);
    ownerStakes[_id] = minStake;

    emit NewStake(_id, ownerStakes[_id]);
  }

  /**
   * @dev Overrides BasicRegistry.add(), tranfers tokens to owner, deletes stake.
   * @param _id The item to remove from the registry.
   */
  function remove(bytes32 _id) public {
    require(token.transfer(msg.sender, ownerStakes[_id]),
      "StakedRegistry: Token transfer for removing item failed.");
    delete ownerStakes[_id];
    super.remove(_id);
  }

  /**
   * @dev Increases stake for an item, only callable by item owner.
   * @param _id The item to increase stake for.
   * @param _stakeAmount The amount of tokens to add to the current stake.
   */
  function increaseStake(bytes32 _id, uint _stakeAmount) public onlyItemOwner(_id) {
    require(token.transferFrom(msg.sender, address(this), _stakeAmount),
      "StakedRegistry: Token transfer for incresing stake failed.");

    ownerStakes[_id] = ownerStakes[_id].add(_stakeAmount);

    emit StakeIncreased(_id, ownerStakes[_id], _stakeAmount);
  }

  /**
   * @dev Decreases stake for an item, only callable by item owner.
   * @param _id The item to decrease stake for.
   * @param _stakeAmount The amount of tokens to remove from the current stake.
   */
  function decreaseStake(bytes32 _id, uint _stakeAmount) public onlyItemOwner(_id) {
    require(ownerStakes[_id].sub(_stakeAmount) > minStake,
      "StakedRegistry: Cannot decrease stake below minStake.");
    require(token.transfer(msg.sender, _stakeAmount),
      "StakedRegistry: Token transfer for decreasing stake failed.");

    ownerStakes[_id] = ownerStakes[_id].sub(_stakeAmount);

    emit StakeDecreased(_id, ownerStakes[_id], _stakeAmount);
  }
}
