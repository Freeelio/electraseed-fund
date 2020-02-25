pragma solidity ^0.5.0;

contract AttributeStore {
    mapping(bytes32 => uint) public store;

    function getAttribute(bytes32 _UUID, string memory _attrName)
        internal
        view
        returns(uint)
    {
        // bytes32 key = keccak256(_UUID, _attrName);
        bytes32 key = keccak256(abi.encodePacked(_UUID, _attrName));

        return store[key];
    }

    function setAttribute(bytes32 _UUID, string memory _attrName, uint _attrVal) internal
    {
        // bytes32 key = keccak256(_UUID, _attrName);
        bytes32 key = keccak256(abi.encodePacked(_UUID, _attrName));
        store[key] = _attrVal;
    }
}
