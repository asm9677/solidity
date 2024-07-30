// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Test12 {
    /*
    주차정산 프로그램을 만드세요. 주차시간 첫 2시간은 무료, 그 이후는 1분마다 200원(wei)씩 부과합니다. 
    주차료는 차량번호인식을 기반으로 실행됩니다.
    주차료는 주차장 이용을 종료할 때 부과됩니다.
    ----------------------------------------------------------------------
    차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
    차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
    */

    mapping(string => uint) startTime;

    function checkCarNumber(string memory _carNumber, bool isDigit) public pure returns(bool) {
        bytes memory _b = bytes(_carNumber);

        (bytes1 start, bytes2 end) = isDigit ? (bytes1('0'),bytes1('9')) : (bytes1('A'),bytes1('Z'));

        for(uint i = 0; i < _b.length; i++) {
            if(bytes1(_b[i]) < start || bytes1(_b[i]) > end) 
                return false;
        }
        return true;
    }

    function toUpperCase(string memory _carNumber) public pure returns(string memory) {
        bytes memory _b = bytes(_carNumber);

        for(uint i = 0; i < _b.length; i++) {
            if(bytes1(_b[i]) >= bytes1('a') && bytes1(_b[i]) <= bytes1('z')) 
                _b[i] = bytes1(uint8(bytes1('a')) - 0x20);
        }

        return string(_b);
    }

    function parking(string memory _carNumber) public {
        _carNumber = toUpperCase(_carNumber);
        require(startTime[_carNumber] == 0, "nope");

        startTime[_carNumber] = block.timestamp;
    }

    function exit(string memory _carNumber) public payable returns(uint){
        _carNumber = toUpperCase(_carNumber);
        uint timeDiff = block.timestamp - startTime[_carNumber];
        uint fee;
        if(timeDiff > 2 hours) {
            fee = timeDiff / 1 minutes;
            timeDiff % 1 minutes == 0 ? fee : fee++;
            fee *= 200;
        }

        if(checkCarNumber(_carNumber, true)) {
            fee = fee*8/10;
        } else if(checkCarNumber(_carNumber, false)) {
            fee /= 2;
        }

        require(msg.value >= fee, "nope");
        payable(msg.sender).transfer(msg.value - fee);
        delete startTime[_carNumber];

        return fee;
    }
}