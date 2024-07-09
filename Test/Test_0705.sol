// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST1 {
    // 시간 : 30분
    // 학생이라는 구조체를 만드세요. 학생은 이름, 번호, 점수, 학점(A,B,C,D)으로 구성되어 있습니다.
    // 학점은 90점 이상이면 A, 80점 이상이면 B, 70점 이상이면 C, 나머지는 F입니다.  
    // 학생들이 들어가는 array를 구현하고, 학생 정보를 넣는 함수, 정보를 받는 함수를 구현하세요.

    // 필수 구현 기능 
    // * 학생 추가 기능 - 특정 학생의 정보를 추가
    // * 학생 정보 조회 기능 - 특정 학생의 정보를 조회

    struct Student {
        string name;
        uint number;
        uint score;
        string grade;
    }

    Student[] students;

    function pushStudent(string memory _name, uint _number, uint _score) public {
        string memory _grade = "F";
        if(_score >= 90)
            _grade = "A";
        else if(_score >= 80)
            _grade = "B";
        else if(_score >= 70)
            _grade = "C";

        students.push(Student(_name, _number, _score, _grade));        
    }

    function getStudent(uint _idx) public view returns(Student memory)  {
        return students[_idx];
    }

    function searchStudent(uint _number) public view returns(Student memory) {
        for(uint i = 0; i < students.length; i++)
            if(students[i].number == _number)
                return students[i];        
        return Student("", 0, 0, "F");
    }
}