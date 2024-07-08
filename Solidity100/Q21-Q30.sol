// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q21 {
    /*
    21. 3의 배수만 들어갈 수 있는 array를 구현하세요.
    */
    uint[] numbers;

    function pushNumber(uint _n) public {
        if(_n % 3 == 0)
            numbers.push(_n);
    }
}

contract Q22 {
    /*
    22. 뺄셈 함수를 구현하세요. 임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
    */ 

    function sub(int _a, int _b) public pure returns(int) {
        int result = _a - _b;
        return result > 0 ? result : -result;
    }
}

contract Q23 {
    /*
    23. 3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    */ 

    function getGrade(uint _n) public pure returns(string memory) {
        string[3] memory grade = ["A", "B", "C"];
        return grade[_n%3];        
    }
}

contract Q24 {
    /*
    24. string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
    */ 

    function isAlice(string memory _name) public pure returns(bool){
        return keccak256(abi.encodePacked("Alice")) == keccak256(abi.encodePacked(_name));
    }

}

contract Q25 {
    /*
    25. 배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요. 
    */ 

    uint[] public A;

    function pushNumbers(int _n) public {        
        for(int i = _n; i >= 0; i--)
            A.push(uint(i));
    }
}

contract Q26 {
    /*    
    26. 홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    */ 

    uint[] evens;
    uint[] odds;

    function pushNumber(uint _n) public {        
        if(_n %2 == 0)
            evens.push(_n);
        else
            odds.push(_n);
    }
}

contract Q27 {
    /*    
    27. string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
    */ 

    mapping(string => bytes32) map;

    function setMap(string memory _key, bytes32 _value) public {
        map[_key] = _value;
    }

    function getMap(string memory _key) public view returns(bytes32) {
        return map[_key];
    }
}

contract Q28 {
    /*    
    28. ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    */ 

    function getHash(string memory _ID, string memory _PW) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_ID,_PW));
    }
}

contract Q29 {
    /*    
    29. 숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    */ 

    uint a;
    string b;

    constructor(uint _a, string memory _b) {
        a = _a;
        b = _b;
    }
}

contract Q30 {
    /*    
    30. 임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
    (sorting 코드 응용 → 약간 까다로움)
    */

    function sort(uint[] memory _numbers) public pure returns(uint[] memory){
        for(uint i = 1; i < _numbers.length; i++) {
            for(uint j = i; j > 0; j--) {
                if(_numbers[j] > _numbers[j-1]) {
                    uint tmp = _numbers[j];
                    _numbers[j] = _numbers[j-1];
                    _numbers[j-1] = tmp;
                }
            }                
        }
        return _numbers;
    }
}