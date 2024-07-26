// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q71 {    
    /*
    71. 숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
        한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    */

    uint a;
    uint timestamp;

    function setA(uint _a) public {
        require(timestamp < block.timestamp, "nope");
        a = _a;
        timestamp = block.timestamp + 10 minutes;
    }
   
}

contract Q72 {
    /*
    72. contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
    
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
    */ 

    address owner;
    uint highest;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "nope");
        _;
    }

    function deposit() public payable {
        if(msg.value > highest) {
            owner = msg.sender;
            highest += msg.value;
        }
    }

    function withdraw(uint _amount) public onlyOwner {        
        require(address(this).balance >= _amount, "nope");
        payable(msg.sender).transfer(_amount);
    }
}

contract Q73 {
    /*
    73. 위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
    */ 

    address owner;
    mapping(address => uint) depositValue;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "nope");
        _;
    }

    function deposit() public payable {
        depositValue[msg.sender] += msg.value;
        if(depositValue[msg.sender] > depositValue[owner]) {
            owner = msg.sender;
        }
    }

    function withdraw(uint _amount) public onlyOwner {        
        require(address(this).balance >= _amount, "nope");
        payable(msg.sender).transfer(_amount);
    }
}

contract Q74 {
    /*
    74. 어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    
    예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
    */ 

    function addTenPercent(uint _a) public pure returns(uint, uint) {
        return (_a * 11 / 10, _a % 10);
    }
}

contract Q75 {
    /*
    75. 문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    
    예) abc,3 -> abcabcabc // ab,5 -> ababababab
    */ 

    function repeat(string memory _s, uint _n) public pure returns(string memory ret) {
        for(uint i = 0 ; i < _n; i++) {
            ret = string.concat(ret, _s);
        }
    }

}

contract Q76 {
    /*    
    76. 숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
        (패키지없이)
    */ 
    function getDigits(uint _n) public pure returns(uint) {
        uint length = 1;

        while(_n >= 10) {
            length++;
            _n /= 10;
        }

        return length;
    }

    function toString(uint _n) public pure returns(string memory) {
        uint digits = getDigits(_n);
        bytes memory ret = new bytes(digits);

        while(digits > 0) {
            ret[--digits] = bytes1(uint8(_n % 10) + 0x30);
            _n /= 10;        
        }

        return string(ret);
    }

}

import "@openzeppelin/contracts/utils/Strings.sol";
contract Q77 {
    /*    
    77. 위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    
    힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
    */ 

    function toString(uint _n) public pure returns(string memory) {
        return Strings.toString(_n);
    }
}

contract Q78 {
    /*    
    78. 숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    
    예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
    */ 

    uint[] numbers;

    constructor() {
        numbers = [1,2,6,9,11,19];
        // numbers = [1,9,3,6,2,8,9,39] ;
    }

    function pushNumber(uint _n) public {
        numbers.push(_n);
    }

    function checkRange() public view returns(bool) {
        for(uint i = 0; i < numbers.length; i++) {
            if(numbers[i] >= 10 && numbers[i] <= 25)
                return true;
        }
        return false;
    }
}

contract Q79_A {
    /*    
    79.  3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 구현할 때는 Contract A를 import 하여 구현하세요.
    */ 

    function max(uint _a, uint _b, uint _c) public pure returns(uint) {
        return _a > _b ? _a > _c ? _a : _c : _b > _c ? _b : _c;
    }
}

contract Q79_B {
    struct Student {
        string name;
        uint number;
        uint score;
    }

    Q79_A A = new Q79_A();
    Student[3] students;

    constructor() {
        students[0] = Student("Alice", 1, 80);
        students[1] = Student("Bob", 2, 90);
        students[2] = Student("Charlie", 3, 55);
    }

    function greatest() public view returns(Student memory _s) {
        uint _score = A.max(students[0].score, students[1].score, students[2].score);
        for(uint i = 0; i < 3; i++) {
            if(_score == students[i].score) {
                _s = students[i];
                break;
            }
        }
    }

}

contract Q80 {
    /*    
    80. 지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다. 가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    */

    uint[] private queue;
    uint left;

    function push(uint _n) public {
        queue.push(_n);
    }

    function pop() public {
        require(left < queue.length, "out of range");
        if(left + 1 == queue.length) {
            delete queue;
            delete left;
        } else {
            delete queue[left++];
        }        
    }

    function getFirst() public view returns(uint) {
        return queue[left];
    }

    function getQueue() public view returns(uint[] memory ret) {
        uint _left = left;
        ret = new uint[](queue.length - _left);
        
        for(uint i = 0; i < ret.length; i++) {
            ret[i] = queue[_left+i];
        }
    }

    function getLenght() public view returns(uint) {
        return queue.length - left;
    }
}