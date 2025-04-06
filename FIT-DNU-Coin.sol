// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FitCoin {
    string public name = "FitCoin";
    string public symbol = "FIT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public owner;
    mapping(address => bool) public isMember;  // Dùng để xác định người dùng có phải là thành viên trong khoa hay không

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event MemberAdded(address indexed member);  // Sự kiện thêm thành viên vào khoa
    event MemberRemoved(address indexed member); // Sự kiện xóa thành viên khỏi khoa

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[owner] = totalSupply;
        isMember[owner] = true;  // Chủ sở hữu là thành viên mặc định
        emit Transfer(address(0), owner, totalSupply);
    }

    modifier onlyMember() {
        require(isMember[msg.sender], "You must be a member of the Faculty of Information Technology, DDN.");
        _;
    }

    // Chức năng để chỉ có thành viên trong khoa mới có thể chuyển token
    function transfer(address _to, uint256 _value) public onlyMember returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance.");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Chức năng phê duyệt cho phép chỉ thành viên trong khoa mới có thể phê duyệt
    function approve(address _spender, uint256 _value) public onlyMember returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Chức năng chuyển token từ tài khoản của người khác, chỉ thành viên khoa mới có thể sử dụng
    function transferFrom(address _from, address _to, uint256 _value) public onlyMember returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance.");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded.");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Chức năng thêm thành viên vào khoa
    function addMember(address _member) public onlyMember {
        isMember[_member] = true;
        emit MemberAdded(_member);
    }

    // Chức năng xóa thành viên khỏi khoa
    function removeMember(address _member) public onlyMember {
        isMember[_member] = false;
        emit MemberRemoved(_member);
    }
}
