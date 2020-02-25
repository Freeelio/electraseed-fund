These are the contracts from the registry-builder package in the openzeppelin repo and its dependency plcr-voting, originally developed by LevelK (https://github.com/levelkdev/registry-builder) and Yorke Rhodes and have been upgraded to solidity 0.5 and extended by me.

TODO:
- make voting modular to include different mechanisms
- add listing states ( {Unlisted, Listed, Whitelisted, Challenged, Blacklisted} ) and a state machine to manage transitions
- add a configuration manager contract to enable upgrades of settings such as:
    minStake = 10 * 10 ** 18
    challengerStake = 10 * 10 ** 18
    applicationPeriod = 60 * 60 * 24
    commitStageLength = 60 * 60 * 24
    revealStageLength = 60 * 60 * 24
    voteQuorum = 50
    percentVoterReward = 50
    (taken from: https://github.com/levelkdev/registry-builder-example/blob/master/deploy/deploy.js)
- add a Funding and respective factory contracts
- review and standardize error messages
- code refactoring needed. example:
    address public challenger;
    (...)
    function challenger() public view returns (address) {
        return challenger;
    }
    (in: PLCRVotingChallenge.sol)

