// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuizCompetition {
    address public manager;
    string public question;
    address public winner;
    bool public isComplete;
    
    struct Participant {
        string answer;
        bool hasEntered;
    }

    mapping(address => Participant) public participants;
    address[] public participantAddresses;

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can call this function.");
        _;
    }

    constructor(string memory _question) {
        manager = msg.sender;
        question = _question;
        isComplete = false;
    }

    function enter(string memory answer) public {
        require(!isComplete, "The competition is already complete.");
        require(!participants[msg.sender].hasEntered, "You have already entered the competition.");

        participants[msg.sender] = Participant({
            answer: answer,
            hasEntered: true
        });

        participantAddresses.push(msg.sender);
    }

    function getParticipants() public view returns (address[] memory) {
        return participantAddresses;
    }

    function getAnswer(address participant) public view returns (string memory) {
        require(participants[participant].hasEntered, "This participant has not entered the competition.");
        return participants[participant].answer;
    }

    function pickWinner(address _winner) public onlyManager {
        require(!isComplete, "The competition is already complete.");
        require(participants[_winner].hasEntered, "This participant has not entered the competition.");

        winner = _winner;
        isComplete = true;
    }

    function checkIfWinner() public view returns (bool) {
        return msg.sender == winner;
    }
}
