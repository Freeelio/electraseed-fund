pragma solidity ^0.5.0;

/**
 * @title IChallengeFactory
 * @dev An interface for factory contracts that create challenges.
 */
interface IChallengeFactory {
  function createChallenge(address _registry, address _challenger, address _itemOwner) external returns (address challenge);
}
