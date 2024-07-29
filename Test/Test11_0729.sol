// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Test11 {
    /*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

    참가 금액은 0.05이더이다.

    예시 1 : 8,2,4,7,D,A
    예시 2 : 9,1,4,2,F,B
    */
    
    struct Ticket {
        uint8 a;
        uint8 b;
        uint8 c;
        uint8 d;
        uint8 e;
        uint8 f;
    }

    address owner; 
    uint round;
    mapping(uint => mapping(address => Ticket[])) tickets;
    mapping(uint => Ticket) winningNumbers;
    mapping(uint => uint) raffleBlock;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier checkBlockNumber(uint _round) {
        uint _raffleBlock = raffleBlock[_round];
        require(_raffleBlock != 0 && block.number >= _raffleBlock, "started yet");
        _;
    }

    function start() public onlyOwner {        
        raffleBlock[++round] = block.number + 100;
    }

    function sorting(uint8 _a, uint8 _b, uint8 _c, uint8 _d, uint8 _e, uint8 _f) public pure returns(uint8,uint8,uint8,uint8,uint8,uint8) {
        uint8[4] memory _numbers = [_a, _b, _c, _d];
        for(uint i = 0; i < 3; i++) {
            for(uint j = i+1; j < 4; j++ ){
                if(_numbers[i] > _numbers[j]) {
                    (_numbers[i], _numbers[j]) = (_numbers[j], _numbers[i]);
                }
            }
        }

        (_e, _f) = _e > _f ? (_f, _e) : (_e, _f);
        return (_numbers[0],_numbers[1],_numbers[2],_numbers[3],_e,_f);
    }

    function buyTicket(uint8 _a, uint8 _b, uint8 _c, uint8 _d, string memory _e, string memory _f) public payable {
        require(msg.value >= 0.05 ether, "insufficient balance");
        require(block.number + 32 < raffleBlock[round], "ended");

        bytes memory _c1 = bytes(_e);
        bytes memory _c2 = bytes(_f);
        require(_c1.length == 1 && _c2.length == 1, "nope");
        require(_a <= 45 && _b <= 45 && _c <= 45 && _d <= 45, "nope");
        require(_a > 0 && _b > 0 && _c > 0 && _d > 0, "nope");
        require(bytes1(_c1[0]) >= bytes1('A') && bytes1(_c1[0]) <= bytes1('Z') , "nope");
        require(bytes1(_c2[0]) >= bytes1('A') && bytes1(_c2[0]) <= bytes1('Z') , "nope");

        uint8 _e1;
        uint8 _f1;
        (_a, _b, _c, _d, _e1, _f1) = sorting(_a,_b,_c,_d,uint8(_c1[0]) - 0x40, uint8(_c2[0]) - 0x40);
        tickets[round][msg.sender].push(Ticket(_a, _b, _c, _d, _e1, _f1));
    }

    function getWinningNumbers(uint _round) public view returns(Ticket memory) {
        uint _raffleBlock = raffleBlock[_round];
        uint _a = uint256(keccak256(abi.encodePacked(blockhash(_raffleBlock)))) % 45 + 1;
        uint _b = uint256(keccak256(abi.encodePacked(blockhash(_raffleBlock-1)))) % 45 + 1;
        uint _c = uint256(keccak256(abi.encodePacked(blockhash(_raffleBlock-2)))) % 45 + 1;
        uint _d = uint256(keccak256(abi.encodePacked(blockhash(_raffleBlock-3)))) % 45 + 1;
        uint _e = uint256(keccak256(abi.encodePacked(blockhash(_raffleBlock-4)))) % 26 + 1;
        uint _f = uint256(keccak256(abi.encodePacked(blockhash(_raffleBlock-5)))) % 26 + 1;

        (_a, _b, _c, _d, _e, _f) = sorting(uint8(_a),uint8(_b),uint8(_c),uint8(_d),uint8(_e),uint8(_f));
        return Ticket(uint8(_a), uint8(_b), uint8(_c), uint8(_d), uint8(_e), uint8(_f));
    }

    function correctNumber(Ticket memory _t1, Ticket memory _t2) public pure returns(uint count) {
        count += _t1.a == _t2.a ? 1 : 0;
        count += _t1.b == _t2.b ? 1 : 0;
        count += _t1.c == _t2.c ? 1 : 0;
        count += _t1.d == _t2.d ? 1 : 0;
        count += _t1.e == _t2.e ? 1 : 0;
        count += _t1.f == _t2.f ? 1 : 0;
    }

    function getwinningAmount(uint _count) public pure returns(uint reward) {
        if(_count == 6)
            reward = 1 ether;
        else if(_count == 5)
            reward = 0.75 ether;
        else if(_count == 4)
            reward = 0.25 ether;
        else if(_count == 3)
            reward = 0.1 ether;
    }

    function claim(uint _round) public checkBlockNumber(_round) {
        Ticket memory _winningNumbers = getWinningNumbers(_round);
        Ticket[] memory _myTickets = tickets[_round][msg.sender];
        uint _claimReward;
        for(uint i = 0; i < _myTickets.length; i++) {
            uint _count = correctNumber(_myTickets[i], _winningNumbers);
            _claimReward += getwinningAmount(_count);            
        }
        delete tickets[_round][msg.sender];
        payable(msg.sender).transfer(_claimReward);
    }
}