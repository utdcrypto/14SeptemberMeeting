pragma solidity ^0.4.23;

contract FridayContract {
        
    address public owner;
    uint public balance;
    bytes32 public targetHash;
    string lastGuess;
    

   constructor(bytes32 _setTarget) public {
       targetHash = _setTarget;
       owner = msg.sender;
   }
    
    function depositMoney() public payable returns (bool success) {
        balance += msg.value;
        return true;
    }
    
    function getMoney(string _callersGuess) public returns (bool success) {
        lastGuess = _callersGuess;
        uint _bal = balance;
        if (keccak256(abi.encodePacked(_callersGuess)) == targetHash) {
            balance = 0;
            msg.sender.transfer(_bal);
            return true;
        } else {
            assert(_bal ==  balance);
            assert(_bal != 0);
            return true;
        }
    }
    
    function viewLastGuess() public view returns (string _lastGuess) {
        return lastGuess;
    }
    
}