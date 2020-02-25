pragma solidity ^0.5.0;

contract VoterMap {

  uint constant NULL_NODE_ID = 0;

  struct Node {
    uint next;
    uint prev;
  }

  mapping(address => mapping(uint => Node)) public dllMap;

  function isEmpty(address voter) internal view returns (bool) {
    return getStart(voter) == NULL_NODE_ID;
  }

  function contains(address voter, uint _curr) internal view returns (bool) {
    if (isEmpty(voter) || _curr == NULL_NODE_ID) {
      return false;
    }

    bool isSingleNode = (getStart(voter) == _curr) && (getEnd(voter) == _curr);
    bool isNullNode = (getNext(voter, _curr) == NULL_NODE_ID) && (getPrev(voter, _curr) == NULL_NODE_ID);
    return isSingleNode || !isNullNode;
  }

  function getNext(address voter, uint _curr) internal view returns (uint) {
    return dllMap[voter][_curr].next;
  }

  function getPrev(address voter, uint _curr) internal view returns (uint) {
    return dllMap[voter][_curr].prev;
  }

  function getStart(address voter) internal view returns (uint) {
    return getNext(voter, NULL_NODE_ID);
  }

  function getEnd(address voter) internal view returns (uint) {
    return getPrev(voter, NULL_NODE_ID);
  }

  /**
  @dev Inserts a new node between _prev and _next. When inserting a node already existing in
  the list it will be automatically removed from the old position.
  @param _prev the node which _new will be inserted after
  @param _curr the id of the new node being inserted
  @param _next the node which _new will be inserted before
  */
  function insert(address voter, uint _prev, uint _curr, uint _next) internal {
    require(_curr != NULL_NODE_ID, "VoterMap: failed");

    remove(voter, _curr);

    require(_prev == NULL_NODE_ID || contains(voter, _prev), "VoterMap: failed");
    require(_next == NULL_NODE_ID || contains(voter, _next), "VoterMap: failed");

    require(getNext(voter, _prev) == _next, "VoterMap: failed");
    require(getPrev(voter, _next) == _prev, "VoterMap: failed");

    dllMap[voter][_curr].prev = _prev;
    dllMap[voter][_curr].next = _next;

    dllMap[voter][_prev].next = _curr;
    dllMap[voter][_next].prev = _curr;
  }

  function remove(address voter, uint _curr) internal {
    if (!contains(voter, _curr)) {
      return;
    }

    uint next = getNext(voter, _curr);
    uint prev = getPrev(voter, _curr);

    dllMap[voter][next].prev = prev;
    dllMap[voter][prev].next = next;

    delete dllMap[voter][_curr];
  }
}
