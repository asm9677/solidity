// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST6 {   
    /*
        숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
        예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   5,3,9 // 28712 -> 5,   2,8,7,1,2
        --------------------------------------------------------------------------------------------
        문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
        예) abde -> 4,   a,b,d,e // fkeadf -> 6,   f,k,e,a,d,f
    */

    function getDigits(uint _n) public pure returns(uint[] memory digits) {
        uint length = 0;
        uint tmp = _n;
        while(tmp != 0) {
            length += 1;
            tmp /= 10;
        }
        if(length == 0)
            length++;

        digits = new uint[](length + 1);
        digits[0] = length;
        while(_n != 0) {
            digits[length--] = _n % 10;
            _n /= 10;
        }
    }

    function getChars(string memory _s) public pure returns(string[] memory chars) {
        bytes memory byteString = bytes(_s);
        uint[] memory digits = getDigits(byteString.length);
        bytes memory stringLength = new bytes(digits.length-1);
        chars = new string[](byteString.length + 1);
        
        for(uint i = 0; i < stringLength.length; i++) {
            stringLength[i] = bytes1(uint8(digits[i+1]) + 0x30);
        } 
        chars[0] = string(stringLength);

        for(uint i = 1; i <= byteString.length; i++) {
            chars[i] = string(abi.encodePacked(byteString[i-1]));
        }
    }
}