// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract TEST13 {
    /*
    가능한 모든 것을 inline assembly로 진행하시면 됩니다.
    1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
    2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
    3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
    4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
    5. number의 k번째 요소를 반환하는 함수를 구현하세요.
    6. number의 k번째 요소를 반환하는 함수를 구현하세요.
    */

    uint[] numbers;
    uint[4] numbers2;

    
    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }

    function getNumbers2() public view returns(uint[4] memory) {
        return numbers2;
    }

    // 1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
    function test1(uint _n) public {
        assembly {            
            mstore(0x0, numbers.slot)

            let nslot := keccak256(0x0, 0x20)

            for{let i := 1} iszero(gt(i, _n)) {i := add(i,1)} {
                sstore(nslot, i)
                nslot := add(nslot, 1)
            }

            sstore(numbers.slot, _n)
        }
    }


    // 2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
    function test2(uint _a, uint _b, uint _c,uint _d) public {
        assembly {            
            sstore(add(numbers2.slot, 0), _a)
            sstore(add(numbers2.slot, 1), _b)
            sstore(add(numbers2.slot, 2), _c)
            sstore(add(numbers2.slot, 3), _d)
        }
    }

    // 3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
    function test3() public view returns(uint sum) {
        assembly {            
            let length := sload(numbers.slot)
            mstore(0x0, numbers.slot)

            let nslot := keccak256(0x0, 0x20)
            for{let i := 0} lt(i,length) {i := add(i,1)} {
                sum := add(sum, sload(add(nslot, i)))
            }
        }
    }

    // 4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
    function test4() public view returns(uint sum) {
        assembly { 
            sum := add(sum, sload(add(numbers2.slot, 0)))           
            sum := add(sum, sload(add(numbers2.slot, 1)))           
            sum := add(sum, sload(add(numbers2.slot, 2)))           
            sum := add(sum, sload(add(numbers2.slot, 3)))           
        }
    }

    // 5. number의 k번째 요소를 반환하는 함수를 구현하세요.
    function test5(uint _k) public view returns(uint ret) {
        assembly {            
            let length := sload(numbers.slot)      
            if or(gt(_k, length),iszero(_k)) {revert(0,0)}      
            
            mstore(0x0, numbers.slot)
            let nslot := add(keccak256(0x0, 0x20), sub(_k,1))

            ret := sload(nslot)
        }
    }

    // 6. number2의 k번째 요소를 반환하는 함수를 구현하세요.
    function test6(uint _k) public view returns(uint ret) {
        assembly {            
            if or(gt(_k, 4),iszero(_k)) {revert(0,0)}
            ret := sload(add(numbers2.slot, sub(_k, 1)))
        }
    }
}