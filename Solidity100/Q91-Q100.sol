// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q91 {    
    /*
    91. 배열에서 특정 요소를 없애는 함수를 구현하세요. 
        예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    */

    uint[] numbers = [4,3,2,1,8];

    function deleteNumber(uint _n) public {
        for(uint i = _n; i < numbers.length; i++ ) {
            numbers[i-1] = numbers[i];            
        }
        numbers.pop();
    }

    function getNumbers() public view returns(uint[] memory){
        return numbers;
    }
}

contract Q92 {
    /*
    92. 특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    */ 

    function isEOA(address _addr) public view returns(bool) {
        return _addr.code.length == 0;
    }
}

contract Q93 {
    /*
    93. 다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    */ 

    function call(address _contract, bytes4 _methodId, uint _a, address _addr) public {
        (bool success, ) = _contract.call(abi.encodeWithSelector(_methodId, _a, _addr));
        require(success);
    }

}

contract Q94 {
    /*
    94. inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    */ 

    function add(uint _a, uint _b) public pure returns(uint _ret) {
        assembly {
            _ret := add(_a, _b)
        }
    }

    function sub(uint _a, uint _b) public pure returns(uint _ret) {
        assembly {
            _ret := sub(_a, _b)
        }
    }

    function mul(uint _a, uint _b) public pure returns(uint _ret) {
        assembly {
            _ret := mul(_a, _b)
        }
    }

    function div(uint _a, uint _b) public pure returns(uint _ret) {
        assembly {
            _ret := div(_a, _b)
        }
    }

}

contract Q95 {
    /*
    95. inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
    */ 

    function addAndMul(uint _a, uint _b, uint _c) public pure returns(uint _add, uint _mul) {
        assembly {
            _add := add(_a, add(_b, _c))
            _mul := mul(_a, mul(_b, _c))
        }
    }
}

contract Q96 {
    /*    
    96. inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */ 
    
    function getMaxAndMin(uint[4] memory _a) public pure returns(uint _max, uint _min) {
        assembly {
            _min := sub(0,1)
            for{let i := 0} lt(i, 4) {i := add(i,1)} {
                let k := mload(add(_a, mul(0x20, i)))
                if lt(_max, k) {
                    _max := k
                }
                if gt(_min, k) {
                    _min := k
                }
            }
        }
    }
}

contract Q97 {
    /*    
    97. inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요. 
    */ 

    uint[] numbers;

    function push(uint _n) public {
        assembly {
            let length := sload(numbers.slot)

            mstore(0x0, numbers.slot)
            let nSlot := add(keccak256(0x0, 0x20), length)
            sstore(nSlot, _n)
            sstore(numbers.slot, add(length, 1))
        }
    }

    function pop() public {
        assembly {
            let length := sload(numbers.slot)
            if iszero(length) {
                revert(0,0)
            }
            mstore(0x0, numbers.slot)
            let nSlot := add(keccak256(0x0, 0x20), sub(length,1))
            sstore(nSlot, 0)
            sstore(numbers.slot, sub(length, 1))
        }
    }

    function getNumbers() public view returns(uint[] memory _numbers) {
        assembly {
            _numbers := mload(0x40) 

            let length := sload(numbers.slot)            
            mstore(_numbers, length)
            mstore(0x40, add(_numbers, mul(add(length,1) , 0x20)))

            mstore(0x0, numbers.slot)
            let nSlot := keccak256(0x0, 0x20)

            for{let i := 0} lt(i, length) {i := add(i, 1)} {
                mstore(add(_numbers, mul(0x20, add(i,1))), sload(add(nSlot, i)))
            }
        }
    }
}

contract Q98 {
    /*    
    98. inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요..
    */
    string public letter;

    function setLetter(string memory _letter) public {
        assembly {
            let length := mload(_letter)
            let ptr := add(_letter, 0x20)     
            let size := shl(1,length)     

            if lt(length, 32) {
                sstore(letter.slot, or(mload(ptr), size))            
            }
            if iszero(lt(length, 32)) {
                sstore(letter.slot, add(size, 1))

                mstore(0x0, letter.slot)
                let nSlot := keccak256(0x0, 0x20)

                for{let i := 0} lt(i, length) {i := add(i,0x20)} {                    
                    sstore(nSlot, mload(add(ptr, i)))
                    nSlot := add(nSlot, 1)
                }
            }
        }   
    }
}

contract Q99 {
    /*    
    99. inline - bytes4형 b의 값을 정하는 함수 setB를 구현하세요.
    */ 
    bytes4 public b;
    function setB(bytes4 _b) public {
        assembly {
            sstore(b.slot, shr(224, _b))
        }
    }
}

contract Q100 {
    /*    
    100. inline - bytes형 변수 b의 값을 정하는 함수 setB를 구현하세요.
    */

    bytes public b = bytes("0x1234");
    function setB(bytes memory _b) public {
        assembly{
            let length := mload(_b)
            let ptr := add(_b, 0x20)     
            let size := shl(1,length)     

            if lt(length, 32) {
                sstore(b.slot, or(mload(ptr), size))            
            }
            if iszero(lt(length, 32)) {
                sstore(b.slot, add(size, 1))

                mstore(0x0, b.slot)
                let nSlot := keccak256(0x0, 0x20)

                for{let i := 0} lt(i, length) {i := add(i,0x20)} {                    
                    sstore(nSlot, mload(add(ptr, i)))
                    nSlot := add(nSlot, 1)
                }
            }
        }
    }

    function getB() public view returns(bytes32 _b) {
        assembly {
            _b := sload(b.slot)
        }
    }
}