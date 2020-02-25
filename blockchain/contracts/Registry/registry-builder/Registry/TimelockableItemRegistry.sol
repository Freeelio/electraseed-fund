pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./BasicRegistry.sol";

/**
 * @title TimelockableItemRegistry
 * @dev A registry that allows items to be locked from removal.
 */
contract TimelockableItemRegistry is Initializable, BasicRegistry {

  // maps item id to a time when the item will be unlocked.
  mapping(bytes32 => uint) public unlockTimes;

  /**
   * @dev Overrides BasicRegistry.remove(), deletes item owner state.
   * @param _id The item to remove from the registry.
   */
  function remove(bytes32 _id) public {
    require(!isLocked(_id), "Timelock: id cannot be locked.");

    delete unlockTimes[_id];
    super.remove(_id);
  }

  /**
   * @dev Checks if an item is locked, reverts if the item does not exist.
   * @param _id The item to check.
   * @return A bool indicating whether the item is locked.
   */
  function isLocked(bytes32 _id) public view returns(bool) {
    require(_exists(_id), "Timelock: id does not exist.");

    return _isLocked(_id);
  }

  /**
   * @dev Internal function to check if an item is locked.
   * @param _id The item to check.
   * @return A bool indicating whether the item is locked.
   */
  function _isLocked(bytes32 _id) internal view returns(bool) {
    /* solium-disable-next-line security/no-block-members */
    return unlockTimes[_id] > now;
  }
}
