// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q81 {    
    /*
    81. Contract에 예치, 인출할 수 있는 기능을 구현하세요. 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.  
    */

    mapping(address => uint) public balanceOf;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balanceOf[msg.sender] >= _amount, "nope");
        balanceOf[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}

contract Q82 {
    /*
    82. 특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    */ 

    function getNumbers(uint _n) public pure returns(uint t, uint f, uint e) {
        return (_n / 3, _n / 5, _n / 8);
    }
}

contract Q83 {
    /*
    83. 이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
    */ 

    struct Person {
        string name;
        uint number;
        address addr;
        mapping(uint => string) word;
    }

    Person[] public p;

    function push(string memory _name, uint _number, address _addr) public {
        p.push();
        Person storage _p = p[p.length-1];        
        (_p.name, _p.number, _p.addr) = (_name, _number, _addr);
    }
}

contract Q84 {
    /*
    84. 2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    */ 

    mapping(address => bool) isBlacklist;

    modifier checkBlackList() {
        require(!isBlacklist[msg.sender], "nope");
        _;
    }

    function add(uint _a, uint _b) public view checkBlackList returns(uint) {
        return _a + _b;
    }

    function sub(uint _a, uint _b) public view checkBlackList returns(uint) {
        return _a - _b;
    }

    function mul(uint _a, uint _b) public view checkBlackList returns(uint) {
        return _a * _b;
    }
}

contract Q85 {
    /*
    85. 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    */ 

    uint public approveVotes;
    uint public disapproveVotes;

    uint deployBlockNumber;
    
    constructor() {
        deployBlockNumber = block.number;
    }

    function vote(bool isApprove) public {
        require(block.number <= deployBlockNumber + 20, "nope");

        isApprove ? approveVotes++ : disapproveVotes++;
    }   
}

contract Q86 {
    /*    
    86. 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.        
    */ 
    
    mapping(address => uint) public balanceOf;
    uint public approveVotes;
    uint public disapproveVotes;

    function vote(bool isApprove) public {
        require(balanceOf[msg.sender]  >= 1 ether, "nope");

        isApprove ? approveVotes++ : disapproveVotes++;
    }  

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
    }
}

contract Q87 {
    /*    
    87. visibility에 신경써서 구현하세요. 
    
    숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요.     
    */ 

    uint private a;

    function setA(uint _a) private {
        a = _a;
    }
}

contract OWNER {
    address private owner;
    
    constructor() {
    	owner = msg.sender;
    }
    
    function setInternal(address _a) internal {
        owner = _a;
    }
    
    function getOwner() public view returns(address) {
        return owner;
    }
}

contract Q88 is OWNER {
    /*    
    88. 아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
    
    ```solidity
    contract OWNER {
    	address private owner;
    
    	constructor() {
    		owner = msg.sender;
    	}
    
        function setInternal(address _a) internal {
            owner = _a;
        }
    
        function getOwner() public view returns(address) {
            return owner;
        }
    }
    ```
    
    힌트 : 상속
    */ 

    function setOwner() public {
        setInternal(msg.sender);
    }
}

contract Q89 {
    /*    
    89.  이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    */ 
    struct Customer {
        string name;
        string introduction;
    }

    mapping(address => Customer) c;

    function setCustomer(string memory _name, string memory _introduction) public {
        
        uint _nameLen = bytes(_name).length;
        uint _introductionLen = bytes(_name).length;
        require(_nameLen >= 5 && _nameLen <= 10, "nope");
        require(_introductionLen >= 20 && _introductionLen <= 50, "nope");

        Customer storage _c = c[msg.sender];
        (_c.name, _c.introduction) = (_name, _introduction);
    }
}

contract Q90 {
    /*    
    90. 당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    */

    function toString(address _addr) public pure returns(string memory) {                
        bytes memory _hex = "0123456789ABCDEF";        
        bytes memory _ret = new bytes(40);

        assembly {
            let ptr := add(_ret, add(0x20, 39))
            let h_ptr := add(_hex, 0x20) 
            for{let i := 0} lt(i, 40) {i := add(i,1)} {
                mstore8(ptr, byte(and(_addr,0xf), mload(h_ptr)))
                ptr := sub(ptr,1)
                _addr := shr(4, _addr)

            }
        }

        return string(_ret);        
    }
}