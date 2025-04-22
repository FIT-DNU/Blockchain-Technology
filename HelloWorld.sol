pragma solidity ^0.8.10;
contract HelloWorld
{
    string public welcome = "Hello World!";
    function addition() public view returns(uint)
    {
        uint x = 10;
        uint y = 20;
        uint addition = x+y;
        return addition;
    }
}
