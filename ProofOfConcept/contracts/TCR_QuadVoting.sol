pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./utils/SafeMath.sol";
/**
Quadratic Voting logic:
The amount received by the project is (proportional to) the square of the sum of the square roots of contributions received
 */

contract QuadVotingTCR {
    using SafeMath for uint256;

    enum VoterStatus { Unregistered, Whitelisted, Voted }

    struct Vote {
        uint256[] projectIDs;
        uint256 amountLocked;
        VoterStatus status;
    }

    struct Project {
        uint256 round;
        uint256 votesFor; //sum of square roots of contributions received
        bytes32 projectURI;
    }

    address public constant OWNER = address(0x00); // CHANGE
    uint256 public constant VOTE_BASE_COST = 0.1 ether;
    uint256 public nextProjectID;
    uint256 public round;

    mapping(uint256 /** projectID */ => Project) public Projects;
    mapping(address /** voter */ => Vote) public Ballots;

    modifier isOwner() {require(msg.sender == OWNER, "Admin Function"); _;}

    event NewVotingRound();
    event VoteCast(address indexed _voter);
    event ProjectListed(uint256 indexed _projectID);
    event ProjectRemoved(uint256 indexed _projectID);
    event WhitelistingLog(address indexed _contributor);

    function () external { }

    function projectDataFor(uint256 _projectID)
        external
        view
        returns (Project memory P)
    {
        return Projects[_projectID];
    }

    function ballotFor(address _voter)
        external
        view
        returns (Vote memory V)
    {
        return Ballots[_voter];
    }

    function voteFor(uint256[] calldata _projectIDs, uint256[] calldata _votes)
        external
        payable
        returns (bool success)
    {
        require(Ballots[msg.sender].status == VoterStatus.Whitelisted, "Whitelisting required");
        require(_projectIDs.length == _votes.length, "Input arrays must have same size");

        uint256 quadVotes;
        uint256 sumVotes;
        for (uint8 i = 0; i < _projectIDs.length; i++) {
            sumVotes = sumVotes.add(_votes[i]);
            quadVotes = _sqrt(_votes[i]);
            Projects[_projectIDs[i]].votesFor = Projects[_projectIDs[i]].votesFor.add(quadVotes);

        }
        assert(msg.value == sumVotes);

        Vote memory thisVote = Vote ({
            projectIDs: _projectIDs,
            amountLocked: sumVotes,
            status: VoterStatus.Voted
        });

        Ballots[msg.sender] = thisVote;
        success = true;

        emit VoteCast(msg.sender);
    }

    function addProject(bytes32 _projectURI)
        external
        isOwner
    {
        uint256 projectID = nextProjectID;
        Projects[nextProjectID].projectURI = _projectURI;
        nextProjectID++;

        emit ProjectListed(projectID);
    }

    function removeProject(uint256 _projectID)
        external
        isOwner
    {
        Projects[_projectID].round = 0xdeadbeaf;

        emit ProjectRemoved(_projectID);
    }

    function newRound() external isOwner {
        require(_closeRound(), "Failed to execute _closeRound");
        round++;

        emit NewVotingRound();
    }

    function whitelistAddr(address _contributor) external isOwner {
        Ballots[_contributor].status = VoterStatus.Whitelisted;

        emit WhitelistingLog(_contributor);
    }

    function _closeRound() internal isOwner returns (bool success) {
        //update vote count w/  square of the sum of the square roots of contributions received
        for (uint256 i = nextProjectID; i >= 0; i--) {
            if (Projects[i].round == round) {
                Projects[i].votesFor = Projects[i].votesFor.mul(Projects[i].votesFor);
            } else {
                break;
            }
        }
        success = true;
    }

    function _sqrt(uint _x) internal pure returns (uint y) {
        if (_x == 0) {
            return 0;
        } else if (_x <= 3) {
            return 1;
        } else {
            /* solium-disable-next-line */
            assembly {
                let z := div(add(_x, 0x01), 0x02)
                y := _x
                for { } lt(z, y) { } {     // while(z < y)
                    y := z
                    z := div(add(div(_x, z), z), 0x02)
                }
            }
        }
    }

}