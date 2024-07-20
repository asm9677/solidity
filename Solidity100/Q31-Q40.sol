// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q31 {
    /*
    31. string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.    
    */
    function pushNumber(string memory _name) public pure returns(bool){
        return keccak256(abi.encodePacked(_name)) == keccak256("Alice") || keccak256(abi.encodePacked(_name)) == keccak256("Bob");
    }
}

contract Q32 {
    /*
    32. 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.    
    예) 3 → o , 9 → o , 15 → o , 30 → x
    */ 

    uint[] public numbers;
    function pushNumber(uint _n) public {
        if(_n % 3 == 0 && _n % 10 != 0)
            numbers.push(_n);
    }
}

contract Q33 {
    /*
    33. 이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    */ 

    struct Customer {
        string name;
        uint number;
        address account;
        uint birthday;
    }

    mapping(string => Customer) customers;
    uint totalCustomer;

    function setCustomer(string memory _name, address _account, uint _birthday) public {
        customers[_name] = Customer(_name, ++totalCustomer, _account, _birthday);
    }

    function getCustomer(string memory _name) public view returns(Customer memory) {
        return customers[_name];
    }
}

contract Q34 {
    /*
    34. 이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    */ 

    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[] students;
    constructor() {
        pushStudent("Alice", 75);
        pushStudent("Bob", 70);
        pushStudent("Charlie", 80);
    }

    function pushStudent(string memory _name, uint _score) public {
        students.push(Student(_name, students.length, _score));
    }

    function getAverage() public view returns(uint) {
        uint _sum;
        for(uint i = 0; i < students.length; i++) 
            _sum += students[i].score;
        return _sum / students.length;
    }

}

contract Q35 {
    /*
    35. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    
    예) [1,2,3,4,5,6] -> [2,4,6] // [3,5,7,9,11,13] -> [5,9,13]
    */ 

    uint[] public numbers;

    constructor() {
        // numbers = [1,2,3,4,5,6];
        // numbers = [3,5,7,9,11,13];
    }

    function pushNumbers(uint _n) public { 
        numbers.push(_n);
    }

    function getEvenElements() public view returns(uint[] memory _even) {
        _even = new uint[](numbers.length / 2);
        for(uint i = 1; i < numbers.length; i+=2)
            _even[i/2] = numbers[i];
    }
}

contract Q36 {
    /*    
    36. high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    */ 

    enum State {
        high, neutral, low
    }
    State public state;

    function setState(uint _a) public {
        if(_a >= 7)
            state = State.high;
        else if(_a >= 4)
            state = State.neutral;
        else
            state = State.low;
    }    
}

contract Q37 {
    /*    
    37. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    
    (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    */ 

    address owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "nope");
        _;
    }

    modifier checkValue(uint _value) {
        require(msg.value == _value, "nope");
        _;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function depositWei() public payable checkValue(1 wei) {}
    function depositFinney() public payable checkValue(0.001 ether)  {}
    function depositEther() public payable checkValue(1 ether)  {}
}

contract Q38 {
    /*    
    38. 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    
    (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
    */ 

    address owner;
    bytes1 a = "A";

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "nope");
        _;
    }

    function setB() public onlyOwner {
        a = "B";
    }

    function setC() public onlyOwner {
        a = "C";
    }

    function getA() public view returns(string memory) {
        bytes memory _a = new bytes(1);
        _a[0] = a;
        return string(_a);
    }
}

contract Q39 {
    /*    
    39. 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    
    예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    */ 
    
    function getCount(uint _number) public pure returns(uint, uint, uint, uint) {
        return (_number/2, _number/3, _number/5, _number/7);
    }
}

contract Q40 {
    /*    
    40. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    
    예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
    */

    function sort(uint[] memory _numbers) public pure returns(uint[] memory){
        uint[] memory center = new uint[](2 - _numbers.length % 2);

        for(uint i = 1; i < _numbers.length; i++) {
            for(uint j = i; j > 0; j--) {
                if(_numbers[j] < _numbers[j-1]) {
                    (_numbers[j-1], _numbers[j]) = (_numbers[j], _numbers[j-1]);
                }
            }                
        }

        center[0] = _numbers[_numbers.length/2 + _numbers.length%2 - 1];
        if(center.length == 2) 
            center[1] = _numbers[_numbers.length/2];
        return center;
    }
}