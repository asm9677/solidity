// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
contract TEST5 {    
    /*
    숫자를 시분초로 변환하세요.
    예) 100 -> 1 min 40 sec
    600 -> 10min 
    1000 -> 16min 40sec
    5250 -> 1hour 27min 30sec
    */

    function getTime(uint _s) public pure returns(string memory hms) {
        uint _hours;
        uint _minutes;
        uint _seconds;

        _hours = _s / 1 hours;
        _minutes = _s % 1 hours / 1 minutes;
        _seconds = _s % 1 minutes;

        if(_hours > 0) {
            hms = string(abi.encodePacked(Strings.toString(_hours), "hour "));
        }
        if(_minutes > 0) {
            hms = string(abi.encodePacked(hms, Strings.toString(_minutes), "min "));
        }        
        if(_seconds > 0) {
            hms = string(abi.encodePacked(hms, Strings.toString(_seconds), "sec"));        
        }
    }    
}