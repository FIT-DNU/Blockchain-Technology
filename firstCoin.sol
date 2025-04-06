// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract firstCoin {
    address public minter;
    mapping(address => uint) public balances;

    event sent(address from, address to, uint amount);
    event starting();

    constructor () {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "Khong co quyen");
        require(amount < 1e60);
        balances[receiver] = amount;
        emit starting();
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Khong du tien");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit sent(msg.sender, receiver, amount);
    }
}
