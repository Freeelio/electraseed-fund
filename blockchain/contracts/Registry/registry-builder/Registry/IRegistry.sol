pragma solidity ^0.5.0;

/**
 * @title IRegistry
 * @dev An interface for registries.
 */
interface IRegistry {
  function add(bytes32 _id) external;
  function remove(bytes32 _id) external;
  function exists(bytes32 _id) external view returns (bool item);
}
