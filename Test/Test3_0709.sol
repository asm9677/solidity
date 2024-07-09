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

    mapping(uint class => Student[]) students;
    uint[] classList;

    constructor() {
        pushStudent(1, "Alice", 85);
        pushStudent(1, "Bob", 75);
        pushStudent(1, "Charlie", 60);
        pushStudent(1, "Dwayne", 90);
        pushStudent(1, "Ellen", 65);
        pushStudent(2, "Fitz", 50);
        pushStudent(2, "Garret", 80);
        pushStudent(2, "Hubert", 90);
        pushStudent(2, "Isabel", 100);
        pushStudent(2, "Jane", 70);
    }

    function getTotalStudentCount() public view returns(uint) {
        uint total;
        for(uint i = 0; i < classList.length; i++) {            
            total += students[classList[i]].length;            
        }
        return total;
    }

    function pushStudent(uint _class, string memory _name, uint _score) public {
        if(students[_class].length == 0)
            classList.push(_class);
        students[_class].push(Student(getTotalStudentCount()+1, _name, _score));        
    }

    // 가장 점수가 낮은 사람의 정보를 보여주는 기능,    
    function getLowest(uint _class) public view returns(Student memory) {
        uint _idx;
        uint _score = type(uint).max;
        for(uint i = 0; i < students[_class].length; i++) {
            if(_score > students[_class][i].score) {
                _score = students[_class][i].score;
                _idx = i;
            }
        }

        return students[_class][_idx];
    }

    // 총 점수 합계, 총 점수 평균을 보여주는 기능,
    function getTotalSumAndAvg(uint _class) public view returns(uint, uint) {
        uint sum;
        for(uint i = 0; i < students[_class].length; i++) {
            sum += students[_class][i].score;
        }

        return (sum, sum/students[_class].length);
    }

    // 특정 학생을 반환하는 기능, -> 숫자로 반환
    function getStudent(uint _number) public view returns(Student memory) {
        Student memory _student;

        for(uint i = 0; i < classList.length; i++) {
            uint _class = classList[i];
            for(uint j = 0; j < students[_class].length; j++) {
                if(students[_class][j].number == _number)
                    _student = students[_class][j];
            }
        }

        return _student;
    }

    function getStudents(uint _class) public view returns(Student[] memory) {
        return students[_class];
    }

    // 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    function getStudents() public view returns(Student[] memory) {
        Student[] memory _students = new Student[](getTotalStudentCount());
        uint k = 0;
        for(uint i = 0; i < classList.length; i++) {
            uint _class = classList[i];
            for(uint j = 0; j < students[_class].length; j++) 
                _students[k++] = students[_class][j];
        }
        return _students;
    }
}