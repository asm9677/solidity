// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST10 {  
    /*
    은행에 관련된 어플리케이션을 만드세요.
    은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
    국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
    세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

    * 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    * 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    * 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    * 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    * 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    * 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
    -------------------------------------------------------------------------------------------------
    * 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
    * 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
    */    
}

contract Central {
    address[] banks;
    mapping(address => bool) isBank;
    mapping(address => uint) lastPayTaxesTimestamp;
    
    uint lastTimestamp;
    address owner;
    constructor() {
        owner = msg.sender;
        lastTimestamp = block.timestamp;
    }

    modifier check(address _bank) {
        require(isBank[_bank], "nope");
        _;
    }

    modifier checkTax() {
        if(lastTimestamp + 30 days < block.timestamp) {
            lastTimestamp += 30 days;
        }
        _payTaxes(msg.sender);
        _;
    }

    function sumTaxes(address _user) public view returns(uint) {
        uint _sum;
        uint percent = (lastTimestamp - lastPayTaxesTimestamp[_user]) / 30 days;
        for(uint i = 0; i < banks.length; i++) {                 
            Bank b = Bank(banks[i]);            
            _sum += b.balanceOf(_user)*percent / 100;
        }
        return _sum;
    }

    function collectTaxes(address _user) public {
        require(msg.sender == owner, "nope");
        _payTaxes(_user);
    }

    function _payTaxes(address _user) private {
        if(lastPayTaxesTimestamp[_user] >= lastTimestamp) {
            return;
        }
        
        uint _total = sumTaxes(_user);
        for(uint i = 0; i < banks.length && _total != 0; i++) {                 
            Bank b = Bank(banks[i]);            
            uint userBalance = b.balanceOf(_user);
            if(userBalance == 0) { 
                continue;
            }
            b.withdraw(_user, address(this),  _total > userBalance ? userBalance : _total);                
            _total -= userBalance;
        }

        lastPayTaxesTimestamp[_user] = lastTimestamp;
    }

    function createBank() public returns(address) {
        address _bank = address(new Bank());
        banks.push(_bank);
        isBank[_bank] = true;        
        return _bank;
    }    

    function signUp(address _bank, string memory _name) public payable check(_bank) {
        Bank(_bank).signUp(msg.sender, _name);
        lastPayTaxesTimestamp[msg.sender] = lastTimestamp;
    }

    function deposit(address _bank) public payable check(_bank) checkTax {
        Bank(_bank).deposit{value: msg.value}(msg.sender);
    }

    function withdraw(address _bank, uint _amount) public check(_bank) checkTax {
        Bank(_bank).withdraw(msg.sender, msg.sender, _amount);        
    }

    function transfer1(address _bankFrom, address _bankTo, uint _amount) public check(_bankFrom) check(_bankTo) checkTax {
        Bank(_bankFrom).withdraw(msg.sender, address(this), _amount);        
        Bank(_bankTo).deposit{value: _amount}(msg.sender);        
    }

    function transfer2(address _bankFrom, address _bankTo, address _to, uint _amount) public check(_bankFrom) check(_bankTo) checkTax {
        require(_amount > 0.001 ether, "nope");
        Bank(_bankFrom).withdraw(msg.sender, address(this), _amount + 0.001 ether);                
        Bank(_bankTo).deposit{value: _amount}(_to);        
    }
}

contract Bank {    
    struct User {
        string name;
        uint balance;
    }
    mapping(address => User) users;

    address central;
    constructor() {
        central = msg.sender;
    }

    modifier check() {
        require(msg.sender == central, "nope");
        _;
    }

    function signUp(address _user, string memory _name) public check {
        require(bytes(users[_user].name).length == 0 || bytes(_name).length != 0, "nope");
        users[_user] = User(_name, 0);
    }

    function deposit(address _to) public payable check {
        require(bytes(users[_to].name).length != 0, "nope");
        users[_to].balance += msg.value;
    }

    function withdraw(address _from, address _to, uint _amount) public check {
        uint _balance = users[_to].balance;
        require(_balance >= _amount, "nope");
        users[_from].balance -= _amount;
        payable(_to).transfer(_amount);
    }

    function balanceOf(address _user) public view returns(uint) {
        return users[_user].balance;
    }
}

