pragma solidity ^0.5.0;

import "./utils/SafeMath.sol";

contract Crowdsale {
    using SafeMath for uint256;

    address constant public OWNER = address(0x00); //CHANGE
    uint256 constant public STARTDATE = 1548979201; //CHANGE
    uint256 constant public ENDDATE = 1551398401; //CHANGE
    uint256 constant public MINSALESCAP = 10 ether; //CHANGE
    uint256 constant public MAXSALESCAP = 200 ether; //CHANGE
    uint256 constant public MINCONTRIBUTION = 1 ether; //CHANGE

    enum State { Uninitialised, Running, Expired }
    State public state;

    struct Contributor {
        bool whitelisted;
        uint256 contributions;
    }

    mapping(address => Contributor) public Whitelist;

    modifier isOwner() {require(msg.sender == OWNER, "Admin function"); _;}
    modifier inState(State _state) {require(state == _state, "Incorrect state transition"); _;}
    modifier inWhitelist(address _contributor) {
        require(Whitelist[_contributor].whitelisted == true, "Whitelisting required");
        _;
    }

    event EmergencyStop();
    event WhitelistingLog(address indexed _contributor);
    event PurchaseLog(address indexed _contributor, address indexed _beneficiary, uint256 _amount);

    // constructor() public { }

    function () external {
        _updateStateIfExpired();
    }

    //available only to whitelisted addresses after startBlock
    function buyTokens(address _beneficiary)
        public
        payable
        inState(State.Running)
        inWhitelist(_beneficiary)
        returns (bool success)
    {
        //TODO::record deposit on erc721
        Whitelist[_beneficiary].contributions = Whitelist[_beneficiary].contributions.add(msg.value);
        success = true;
    }

    //as owner, whitelist individual address
    function whitelistAddr(address _contributor) external isOwner returns(bool) {
        Whitelist[_contributor].whitelisted = true;
    }

    function initialiseSale() external isOwner inState(State.Uninitialised) {
        require(block.timestamp >= STARTDATE, "Incorrect start date");
        state = State.Running;
    }

// function distributeFunds ? or...?

    function emergencyStop() external isOwner inState(State.Running) {
        state = State.Expired;
        emit EmergencyStop();
    }

    function _updateStateIfExpired() internal {
        if (state == State.Running) {
            if (block.timestamp >= ENDDATE || address(this).balance >= MAXSALESCAP) {
                state = State.Expired;
            }
        }
    }

}