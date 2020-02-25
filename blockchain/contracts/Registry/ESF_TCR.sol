pragma solidity ^0.5.0;

// import "openzeppelin-eth/contracts/token/ERC20/StandaloneERC20.sol";
import "../Token/ElectraSeedFundToken.sol";
import "./registry-builder/PLCR-Voting/PLCRVoting.sol";
import "./registry-builder/Challenge/PLCRVotingChallengeFactory.sol";
import "./registry-builder/Registry/TokenCuratedRegistry.sol";


contract ElectraSeedFundTCR {
    //temp for development purposes
    address public owner;
    constructor() public {
        owner = msg.sender;
    }
}