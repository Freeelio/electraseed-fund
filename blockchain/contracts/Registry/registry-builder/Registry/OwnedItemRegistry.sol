pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./BasicRegistry.sol";

/**
 * @title OwnedItemRegistry
 * @dev A registry where items are only removable by an item owner.
 */
contract OwnedItemRegistry is Initializable, BasicRegistry {

  // maps item id to owner address.
  mapping(bytes32 => address) public owners;

  /**
   * @dev Modifier to make function callable only by item owner.
   * @param _id The item to require ownership for.
   */
  modifier onlyItemOwner(bytes32 _id) {
    require(owners[_id] == msg.sender, "OwnedRegistry: Caller is not item owner.");
    _;
  }

  /**
   * @dev Overrides BasicRegistry.add(), sets msg.sender as item owner.
   * @param _id The item to add to the registry.
   */
  function add(bytes32 _id) public {
    super.add(_id);

    owners[_id] = msg.sender;
  }

  /**
   * @dev Overrides BasicRegistry.remove(), deletes item owner state.
   * @param _id The item to remove from the registry.
   */
  function remove(bytes32 _id) public onlyItemOwner(_id) {
    delete owners[_id];

    super.remove(_id);
  }
}
