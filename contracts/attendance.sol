// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ClassAttendance {
    address public teacher;

    constructor() {
        teacher = msg.sender; // deployer becomes teacher
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only teacher allowed");
        _;
    }

    // student ID => registered or not
    mapping(string => bool) public isRegistered;

    // student ID => (date => present/absent)
    mapping(string => mapping(uint256 => bool)) public attendance;

    event StudentRegistered(string studentId);
    event AttendanceMarked(string studentId, uint256 date, bool present);

    /// @notice Register a student using a unique ID (ex: "STU101")
    function registerStudent(string memory studentId) public onlyTeacher {
        require(!isRegistered[studentId], "Student already registered");
        isRegistered[studentId] = true;
        emit StudentRegistered(studentId);
    }

    /// @notice Teacher marks attendance for a student for a specific date
    /// @param studentId A unique string ID
    /// @param date A number like 20250101 (YYYYMMDD)
    function markAttendance(
        string memory studentId,
        uint256 date,
        bool present
    ) public onlyTeacher {
        require(isRegistered[studentId], "Student not registered");

        attendance[studentId][date] = present;

        emit AttendanceMarked(studentId, date, present);
    }

    /// @notice Check if student was present on a given date
    function checkAttendance(
        string memory studentId,
        uint256 date
    ) public view returns (bool) {
        return attendance[studentId][date];
    }
}
