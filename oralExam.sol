// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OralExam {
    struct Student {
        string name;
        string studentId;
        bool hasPresented;
        uint8 grade; // 0-10
    }

    address public admin;
    string public topic;
    string public examDateTime;
    address public examiner;

    mapping(address => Student) public students;
    address[] public studentList;

    constructor(string memory _topic, string memory _examDateTime) {
        admin = msg.sender;
        topic = _topic;
        examDateTime = _examDateTime;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin allowed");
        _;
    }

    modifier onlyExaminer() {
        require(msg.sender == examiner, "Only examiner allowed");
        _;
    }

    function setExaminer(address _examiner) public onlyAdmin {
        examiner = _examiner;
    }

    function registerStudent(string memory _name, string memory _studentId) public {
        require(bytes(students[msg.sender].studentId).length == 0, "Already registered");
        students[msg.sender] = Student(_name, _studentId, false, 0);
        studentList.push(msg.sender);
    }

    function markAsPresented(address _student, uint8 _grade) public onlyExaminer {
        require(_grade <= 10, "Invalid grade");
        require(bytes(students[_student].studentId).length > 0, "Student not found");

        students[_student].hasPresented = true;
        students[_student].grade = _grade;
    }

    function getStudentList() public view returns (address[] memory) {
        return studentList;
    }

    function getStudentInfo(address _student) public view returns (string memory, string memory, bool, uint8) {
        Student memory s = students[_student];
        return (s.name, s.studentId, s.hasPresented, s.grade);
    }
}
