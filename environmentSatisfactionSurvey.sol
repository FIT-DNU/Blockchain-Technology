// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnvironmentSatisfactionSurvey {
    address public admin;
    bool public votingOpen;

    enum SatisfactionLevel { VeryUnsatisfied, Unsatisfied, Neutral, Satisfied, VerySatisfied }

    mapping(SatisfactionLevel => uint) public votes;
    mapping(address => bool) public hasVoted;

    event Voted(address voter, SatisfactionLevel level);
    event VotingOpened();
    event VotingClosed();

    constructor() {
        admin = msg.sender;
        votingOpen = false;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Quan tri vien moi duoc thuc hien.");
        _;
    }

    modifier voteActive() {
        require(votingOpen, "Khong hoat dong.");
        _;
    }

    function openVoting() external onlyAdmin {
        votingOpen = true;
        emit VotingOpened();
    }

    function closeVoting() external onlyAdmin {
        votingOpen = false;
        emit VotingClosed();
    }

    function vote(SatisfactionLevel level) external voteActive {
        require(!hasVoted[msg.sender], "Ban da bo phieu.");
        hasVoted[msg.sender] = true;
        votes[level]++;
        emit Voted(msg.sender, level);
    }

    function getVoteCount(SatisfactionLevel level) public view returns (uint) {
        return votes[level];
    }

    function totalVotes() public view returns (uint) {
        uint total = 0;
        for (uint i = 0; i < 5; i++) {
            total += votes[SatisfactionLevel(i)];
        }
        return total;
    }
}
