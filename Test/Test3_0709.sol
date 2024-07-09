// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST3 {
    /*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    가장 점수가 낮은 사람의 정보를 보여주는 기능,
    총 점수 합계, 총 점수 평균을 보여주는 기능,
    특정 학생을 반환하는 기능, -> 숫자로 반환
    가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    */

    struct Student {
        uint number;
        string name;
        uint score;
    }

    Student[] students;

    constructor() {
        pushStudent("Alice", 85);
        pushStudent("Bob", 75);
        pushStudent("Charlie", 60);
        pushStudent("Dwayne", 90);
        pushStudent("Ellen", 65);
        pushStudent("Fitz", 50);
        pushStudent("Garret", 80);
        pushStudent("Hubert", 90);
        pushStudent("Isabel", 100);
        pushStudent("Jane", 70);
    }

    function pushStudent(string memory _name, uint _score) public {
        students.push(Student(students.length+1, _name, _score));
    }

    // 가장 점수가 낮은 사람의 정보를 보여주는 기능,    
    function getLowest() public view returns(Student memory) {
        uint _idx;
        uint _score = type(uint).max;
        for(uint i = 0; i < students.length; i++) {
            if(_score > students[i].score) {
                _score = students[i].score;
                _idx = i;
            }
        }

        return students[_idx];
    }

    // 총 점수 합계, 총 점수 평균을 보여주는 기능,
    function getTotalSumAndAvg() public view returns(uint, uint) {
        uint sum;
        for(uint i = 0; i < students.length; i++) {
            sum += students[i].score;
        }

        return (sum, sum/students.length);
    }

    // 특정 학생을 반환하는 기능, -> 숫자로 반환
    function getStudent(uint _number) public view returns(Student memory) {
        Student memory _student;
        for(uint i = 0; i < students.length; i++) {
            if(students[i].number == _number)
                _student = students[i];
        }

        return _student;
    }

    // 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    function getStudents() public view returns(Student[] memory) {
        return students;
    }
}