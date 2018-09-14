pragma solidity ^0.4.23;

contract Friday {
        
    address public owner;
    uint public balance;
    bytes32 public targetHash;
    string lastGuess;
    

// Don't do this in a real contract; taking a string here is for convenience.
   constructor(string _setTarget) public {
      targetHash = keccak256(abi.encodePacked(_setTarget));
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