pragma solidity >=0.7.0 <0.8.0;
pragma experimental ABIEncoderV2;


import "./VotingSystem.sol";
import "./FirstPastThePost.sol";
import "./DataTypes.sol";

/**
@title Election
@dev Main contract used to set up the election on the blockchain
 */
contract Election {
    DataTypes.Candidate[] public candidates;

    enum votingTypes {firstPastThePost}
    votingTypes votingType;

    uint256 public endTime;
    uint256 public startTime;

    address public organizer;

    mapping(address => DataTypes.Voter) public voters;

    event timestamp(uint256 timestamp, uint256 endTime);   
    modifier onlyHost() {
        
        require(msg.sender == organizer);
        _;
    }


    modifier onlyDuringElection() {
        require(block.timestamp < endTime, "Election has ended");
        require(block.timestamp >= startTime, "Election has started");
        _;
    }

    
    modifier onlyBeforeElection() {
        require(block.timestamp < startTime, "Election start time has passed");
        _;
    }


    modifier onlyAfterElection() {
        //emit timestamp(block.timestamp, endTime);
        require(block.timestamp >= endTime, "Election end time has not passed");
        _;
    }

    
    constructor(
        string[] memory candidateNames,
        uint256 _endTime,
        uint256 _startTime
    ) {
        votingType = votingTypes.firstPastThePost;
        organizer = msg.sender;
        endTime = _endTime;
        startTime = _startTime;
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(
                DataTypes.Candidate({
                    name: candidateNames[i],
                    voteCount: 0,
                    id: i
                })
            );
        }
    }

    
    function giveRightToVote(address[] memory voterAddress) public onlyHost {
        for (uint256 i = 0; i < voterAddress.length; i++) {
            voters[voterAddress[i]].validVoter = true;
        }
    }

    
    function vote(uint256 candidateID) public onlyDuringElection {
        require(voters[msg.sender].validVoter, "Has no right to vote");
        require(!voters[msg.sender].voted, "Already voted.");
        voters[msg.sender].voted = true;
        voters[msg.sender].votedFor = candidateID;
        candidates[candidateID].voteCount += 1;
    }   


    function getWinner()
        public
        onlyAfterElection
        returns (string memory winnerName)
    {
        FirstPastThePost countMethod = new FirstPastThePost(candidates);
        
        
        uint256[10] memory winners = countMethod.calculate();
        winnerName = string(candidates[winners[0]].name);
        for (uint256 i = 1; i < winners.length; i++) {
            
            if (winners[i] == 0 && i != 0) {
                break;
            }
            winnerName = string(
                abi.encodePacked(winnerName, ",", candidates[winners[i]].name)
            );
        }
    }



    function numberOfCandidates() public view returns (uint256 num) {
        num = candidates.length;
        return num;
    }
}
