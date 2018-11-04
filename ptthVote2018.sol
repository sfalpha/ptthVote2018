/*

ptthVote2018

Copyright (C) 2018 Phattanon Duangdara <sfalpha@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

pragma solidity ^0.4.16;

contract ptthVote2018 {
    
    struct Candidate {
        bool exist;
        uint32 aye;
        uint32 nay;
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
    
    function getVoteAye(uint8 voteNumber)  public constant returns (uint32) {
        require (candidates[voteNumber].exist);
        return candidates[voteNumber].aye;
    }
    
    function getVoteNay(uint8 voteNumber) public constant returns (uint32) {
        require (candidates[voteNumber].exist);
        return candidates[voteNumber].nay;
    }
}