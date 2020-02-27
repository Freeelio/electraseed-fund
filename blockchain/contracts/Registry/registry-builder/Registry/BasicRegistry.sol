pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./IRegistry.sol";

/**
 * @title BasicRegistry
 * @dev A simple implementation of IRegistry, allows any address to add/remove items
 */
contract BasicRegistry is Initializable, IRegistry {

    mapping(bytes32 => bool) public items;

    event ItemAdded(bytes32 _id);

    event ItemRemoved(bytes32 _id);

    /**
     * @dev Adds an item to the registry.
     * @param _id The item to add to the registry, must be unique.
     */
    function add(bytes32 _id) public {
        require(!exists(_id), "Registry: Item already added");

        items[_id] = true;

        emit ItemAdded(_id);
    }

    /**
     * @dev Removes an item from the registry, reverts if the item does not exist.
     * @param _id The item to remove from the registry.
     */
    function remove(bytes32 _id) public {
        require(exists(_id), "Registry: Item already deleted");

       _remove(_id);

        emit ItemRemoved(_id);
    }

    /**
     * @dev Checks if an item exists in the registry.
     * @param _id The item to check.
     * @return A bool indicating whether the item exists.
     */
    function exists(bytes32 _id) public view returns(bool) {
        return _exists(_id);
    }

    /**
     * @dev Internal function to check if an item exists in the registry.
     * @param _id The item to check.
     * @return A bool indicating whether the item exists.
     */
    function _exists(bytes32 _id) internal view returns(bool) {
        return items[_id];
    }

    /**
     * @dev Internal function to remove an item from the registry.
     * @param _id The item to remove from the registry.
     */
    function _remove(bytes32 _id) internal {
        items[_id] = false;

        emit ItemRemoved(_id);
    }
}
