// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST2 {
    /*
    여러분은 선생님입니다. 학생들의 정보를 관리하려고 합니다. 
    학생의 정보는 이름, 번호, 점수, 학점 그리고 듣는 수업들이 포함되어야 합니다.

    번호는 1번부터 시작하여 정보를 기입하는 순으로 순차적으로 증가합니다.

    학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.

    필요한 기능들은 아래와 같습니다.

    * 학생 추가 기능 - 특정 학생의 정보를 추가
    * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    * 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    * 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    -------------------------------------------------------------------------------
    * S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)

    기입할 학생들의 정보는 아래와 같습니다.

    Alice, 1, 85
    Bob,2, 75
    Charlie,3,60
    Dwayne, 4, 90
    Ellen,5,65
    Fitz,6,50
    Garret,7,80
    Hubert,8,90
    Isabel,9,100
    Jane,10,70
    */

    struct Student {
        string name;
        uint number;
        uint score;
        string grade;
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

    // * 학생 추가 기능 - 특정 학생의 정보를 추가
    function pushStudent(string memory _name, uint _score) public {
        string memory _grade = "F";
        if(_score >= 90) 
            _grade = "A";
        else if(_score >= 80) 
            _grade = "B";
        else if(_score >= 70) 
            _grade = "C";
        else if(_score >= 60) 
            _grade = "D";

        students.push(Student(_name, students.length+1, _score, _grade));
    }

    // * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환    
    function getStudent(uint _number) public view returns(Student memory) {
        for(uint i = 0; i < students.length; i++) {
            if(_number == students[i].number)
                return students[i];
        }
        return Student("",0,0,"");
    }

    // * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    function getStudent(string memory _name) public view returns(Student memory) {
        for(uint i = 0; i < students.length; i++) {
            if(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(students[i].name)))
                return students[i];
        }
        return Student("",0,0,"");
    }
    
    // * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    function getScore(string memory _name) public view returns(uint) {
        for(uint i = 0; i < students.length; i++) {
            if(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(students[i].name)))
                return students[i].score;
        }
        return 0;
    }

    // * 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    function getStudentCount() public view returns(uint) {
        return students.length;
    }

    // * 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    function getStudents() public view returns(Student[] memory) {
        return students;
    }
    
    // * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    function getAvg() public view returns(uint) {
        uint sum = 0;
        for(uint i = 0; i < students.length; i++)
            sum += students[i].score;
        return sum / students.length;
    }

    // * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    function IsAboveAverage() public view returns(bool) {
        return getAvg() >= 70;
    }

    // * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    function getExtraClass() public view returns(uint, Student[] memory) {
        uint extraCount = 0;
        for(uint i = 0; i < students.length; i++) {
            if(students[i].score < 60)
                extraCount++;
        }

        Student[] memory extraStudents = new Student[](extraCount);
        uint j = 0;
        for(uint i = 0; i < students.length; i++) {
            if(students[i].score < 60)
                extraStudents[j++] = students[i];
        }

        return (extraCount, extraStudents);
    }

    // * S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)
    
    function getExcellentStudents() public view returns(Student[4] memory) {
        Student[4] memory excellentStudents;

        for(uint i = 0; i < students.length; i++) {
            if(students[i].score > excellentStudents[3].score) {
                excellentStudents[3] = students[i];
                for(uint j = 3; j > 0; j--) {
                    if(excellentStudents[j].score <= excellentStudents[j-1].score) 
                        break;
                    Student memory tmp = excellentStudents[j];
                    excellentStudents[j] = excellentStudents[j-1];
                    excellentStudents[j-1] = tmp;
                }
            }
        }

        return excellentStudents;
    }
}