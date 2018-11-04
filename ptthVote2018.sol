pragma solidity ^0.4.16;

contract ptthVote2018 {
    
    struct Candidate {
        bool exist;
        uint8 aye;
        uint8 nay;
    }

    string public name;
    uint8[] public numbers;
    mapping(uint8 => Candidate) public candidates;
    mapping(address => bool) public voters;
    address private owner;
    bytes32 private password;
    
    constructor(string voteName, uint8[] candidateNumbers) public {
        uint i;
        name = voteName;
        owner = msg.sender;
        for (i = 0; i < candidateNumbers.length; i++) {
            candidates[candidateNumbers[i]] = Candidate({exist: true, aye: 0, nay: 0});
            numbers.push(candidateNumbers[i]);
        }
        password = sha256(abi.encodePacked(block.timestamp, block.difficulty, voteName));
    }
    
    function getPassword() public constant returns (bytes32) {
        require(owner == msg.sender);
        return password;
    }
  
    function voteAll(bytes32 passHash, uint8[] voteNumbers, bool[] votes) public {
        uint i;
        require(sha256(abi.encodePacked(password, msg.sender)) == passHash);
        require(! voters[msg.sender]);
        require(voteNumbers.length == votes.length);
        for (i = 0; i < numbers.length; i++) {
            uint8 voteNumber = voteNumbers[i];
            require(candidates[voteNumber].exist);
            if (votes[i]) {
                candidates[voteNumber].aye++;
            } else {
                candidates[voteNumber].nay++;
            }
        }
        voters[msg.sender] = true;
    }
    
    function getVoteAye(uint8 voteNumber)  public constant returns (uint8) {
        require (candidates[voteNumber].exist);
        return candidates[voteNumber].aye;
    }
    
    function getVoteNay(uint8 voteNumber) public constant returns (uint8) {
        require (candidates[voteNumber].exist);
        return candidates[voteNumber].nay;
    }
}