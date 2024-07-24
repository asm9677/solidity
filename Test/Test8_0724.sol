// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST8 {  
    /*
    안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
    안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
    안건들을 모아놓은 자료구조도 구현하세요. 

    사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

    * 사용자 등록 기능 - 사용자를 등록하는 기능
    * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    -------------------------------------------------------------------------------------------------
    * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    */

    struct Proposal {
        uint number;
        string title;
        string description;
        address proponent;
        uint approvalCount;  
        uint disapprovalCount; 
    }

    struct ProposalResult {
        Proposal proposal;
        string result;    
    }

    struct User {
        string name;                     
        address addr;             
        
        string[] createdProposals;
        mapping(string => bool) votes;        
        mapping(string => bool) isApproval;
    }

    mapping(string => Proposal) proposals;
    uint proposalsCount; 
    mapping(address => User) users;
    uint userCount; 

    modifier checkUser(bool isZero) {
        require((users[msg.sender].addr == address(0)) == isZero, "nope");
        _;
    }

    modifier checkProposal(string memory _title, bool isZero) {
        require((proposals[_title].number == 0) == isZero, "nope");
        _;
    }

    function signUp(string memory _name) public checkUser(true)  {
        users[msg.sender].name = _name;
        users[msg.sender].addr = msg.sender;        
        userCount++;
    }

    function vote(string memory _title, bool _isApproval) public checkUser(false){
        require(users[msg.sender].votes[_title] == false, "nope");
        users[msg.sender].votes[_title] = true;
        users[msg.sender].isApproval[_title] = _isApproval;
        _isApproval ? proposals[_title].approvalCount++ : proposals[_title].disapprovalCount++;
    }

    function propose(string memory _title, string memory _description) public checkUser(false) checkProposal(_title, true) {        
        proposals[_title] = Proposal(++proposalsCount, _title, _description, msg.sender, 0, 0);
        users[msg.sender].createdProposals.push(_title);
    }

    function getProgress(string memory _title) public view checkProposal(_title, false) returns(string memory)   {
        Proposal memory _proposal = proposals[_title];
        uint voteCount = _proposal.approvalCount + _proposal.disapprovalCount;

        if(voteCount == 0 || voteCount*10 < userCount*7) {
            return unicode"투표 진행중";
        }
        else {
            if(_proposal.approvalCount >= _proposal.disapprovalCount * 2) {
                return unicode"통과";
            } else {
                return unicode"기각";
            }
        }     
    }

    function getMyProposals() public view checkUser(false) returns(ProposalResult[] memory ret)  {
        string[] memory createdProposals = users[msg.sender].createdProposals;
        uint length = createdProposals.length;
        ret = new ProposalResult[](length);

        for(uint i = 0; i < length; i++) {
            ret[i] = ProposalResult(getProposal(createdProposals[i]), getProgress(createdProposals[i]));
        }
    }

    function getProposal(string memory _title) public view returns(Proposal memory) {
        return proposals[_title];
    }    
}