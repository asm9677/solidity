// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST5 {    
    /*
    숫자를 시분초로 변환하세요.
    예) 100 -> 1 min 40 sec
    600 -> 10min 
    1000 -> 16min 40sec
    5250 -> 1hour 27min 30sec
    */

    function toBytes(uint _n) public pure returns(bytes memory res) {        
        uint length;
        uint tmp = _n;

        while (tmp != 0) {
            tmp /= 10;
            length += 1;
        }       

        if(length == 0) 
            length = 1;
            
        res = new bytes(length);
        for(uint i = length; i > 0; i--) {
            res[i-1] = bytes1(uint8(_n % 10) + 0x30);
            _n /= 10;
        }
    }

    function getTime(uint _s) public pure returns(string memory hms) {
        uint _hours;
        uint _minutes;
        uint _seconds;

        _hours = _s / 1 hours;
        _minutes = _s % 1 hours / 1 minutes;
        _seconds = _s % 1 minutes;

        if(_hours > 0) {
            hms = string(abi.encodePacked(toBytes(_hours), "hour "));
        }
        if(_minutes > 0) {
            hms = string(abi.encodePacked(hms, toBytes(_minutes), "min "));
        }        
        if(_seconds > 0) {
            hms = string(abi.encodePacked(hms, toBytes(_seconds), "sec"));        
        }
    }    
}