pragma solidity ^0.5.0;

/**
 * @title IChallenge
 * @dev An interface for challenges.
 */
interface IChallenge {
  // returns the address of the challenger.
  function challenger() external view returns (address);

  // closes the challenge.
  function close() external;

  // should return `true` if close() has been called.
  function isClosed() external view returns (bool);

  // indicates whether the challenge has passed.
  function passed() external view returns (bool);

  // returns the amount of tokens the challenge needs to reward participants.
  function fundsRequired() external view returns (uint);

  // returns amount of tokens that should be allocated to challenge winner
  function winnerReward() external view returns (uint);
}
