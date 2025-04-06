pragma solidity ^0.8.0;

contract simpleBanking {
    address public owner;
    uint public clientCount;

    mapping(address => uint) private balances;
    mapping(address => bool) public registeredClients;
    address[] public clients;

    event Enrolled(address client);
    event Deposited(address indexed client, uint amount);
    event Withdrawn(address indexed client, uint amount);
    event Transferred(address from, address to, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this.");
        _;
    }

    modifier onlyRegistered() {
        require(registeredClients[msg.sender], "You must enroll first.");
        _;
    }

    function enroll() external {
        require(!registeredClients[msg.sender], "Already enrolled.");
        registeredClients[msg.sender] = true;
        balances[msg.sender] = 0;
        clients.push(msg.sender);
        clientCount++;
        emit Enrolled(msg.sender);
    }

    function deposit() external payable onlyRegistered {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint amount) external onlyRegistered {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function transfer(address to, uint amount) external onlyRegistered {
        require(registeredClients[to], "Recipient not enrolled.");
        require(balances[msg.sender] >= amount, "Insufficient funds");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transferred(msg.sender, to, amount);
    }

    function getBalance() external view onlyRegistered returns (uint) {
        return balances[msg.sender];
    }

    function totalDeposits() external view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function getAllClients() external view onlyOwner returns (address[] memory) {
        return clients;
    }
}
