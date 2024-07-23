// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST7 {  
    /*
        
        악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
        주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
        브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
        시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
        시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
        --------------------------------------------------------
        충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감
    */

    bool public ignitionOn;
    uint public gas;
    uint public speed;
    uint public balance;

    modifier checkGas(uint _gas) {
        require(gas > _gas, "nope");
        _;
    }

    modifier checkSpeed(bool isZero) {        
        require((speed == 0) == isZero, "nope");
        _;
    }
    
    modifier checkIgnition(bool _on) {
        require(ignitionOn == _on, "nope");
        _;
    }

    function accel() public checkGas(30) checkIgnition(true) {        
        gas -= 20;
        speed += 10;
    }

    function oiling() public payable{
        require(msg.value >= 1 ether || balance >= 1 ether, "nope");
        if(msg.value < 1 ether) 
            balance -= 1 ether;           
         
        gas = 100;
    }

    function stop() public checkGas(10) checkSpeed(false) checkIgnition(true) { 
        gas -= 10;
        speed -= 10;        
    }

    function  TurnOff() public checkSpeed(true) checkIgnition(true) {
        ignitionOn = false;
    }

    function  TurnOn() public checkIgnition(false) {
        ignitionOn = true;        
    }

    function charge() public payable{
        balance += msg.value;
    }
}