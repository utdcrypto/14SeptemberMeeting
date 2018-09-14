// What this contract does: The contract owner sets a hash value, whose corresponding input
// is unknown, then deposits some Ether. Anyone who then calls the method "get_money()" with
// a string that hashes to the target hash digest set by the owner gets the contract's balance
// as a prize.


// The 'pragma' statement is a message to the compiler, saying
// "only allow this contract to be compiled by compiler versions greater than or equal to 0.4.23",
// so you don't write a contract utilizing newer features that older compiler versions can't handle.
pragma solidity ^0.4.23;

// the `contract` keyword marks a code block which is analogous to a module in other languages.
contract Friday {
        
// global variables. the 'public' modidifier automatically creates a getter function for you when compiled.
// (lastGuess) is purposely left private for demonstration. Keep in mind there is NO SECRET DATA 
// IN A SMART CONTRACT. "Not public" =/= "secret".
    address public owner;
    uint public balance;
    bytes32 public targetHash;
    string lastGuess;
    
// As of solidity version 0.4.22, a contract's constructor function is declared explicitly with
// the keyword `constructor`. Constructor functions run ONCE and ONLY ONCE upon a contract's deployment,
// after which they can never be run again, by anybody.

// JOKE
   constructor(string _setTarget) public {
      targetHash = keccak256(abi.encodePacked(_setTarget));
      owner = msg.sender;
   }
    
// WOKE
//   constructor(bytes32 _setTarget) public {
//       targetHash = _setTarget;
//       owner = msg.sender;
//   }
    
// Solidity functions which wish to accept Ether must explicitly be marked with the 'payable' keyword.
// All functions, when called, have access to the calling message's data in the form of the "msg" object.
// In classic object oriented style, attributes of the msg object can be accessed with msg.<attr>
    function depositMoney() public payable returns (bool success) {
        balance += msg.value;
        return true;
    }
    
// 'automatic' variables can be set within functions with the format <type> <name> = <value>
// Good: branch with an if/else conditional
    function getMoney(string _callersGuess) public returns (bool success) {
        lastGuess = _callersGuess;
        uint _bal = balance;
// Properly encode's the caller's string, hashes it, and compares the digest to the target.
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
    
    // Better: functions that deal with strings often carry the risk of being DOS'd,
    // as strings are allowed to be of arbitrary length. In a real application, 
    // your function would accept an input of fixed length that has been converted
    // beforehand. IE a bytes32 that's been converted by your front end.
    //
    // function getMoney(bytes32 _callersGuess) public returns...
    
    
//    Remember!: function execution is atomic; the occurence of any exception (IE failure
//    of a `require` or `assert` statement will cause all state
//    changes by a transaction to revert. While this code WOULD prevent the function
//    from completing if the hash doesn't match (which is good), it would NOT record the previous guess
//    (which is not good).
//    
//    function getMoney(string _callersGuess) public returns (bool success) {
//        lastGuess = _callersGuess;
//        require(keccak256(abi.encodePacked(_callersGuess)) == targetHash);
//        uint _bal = balance;
//        balance = 0;
//        msg.sender.transfer(_bal);
//        return true;
//    }
    
    
// An example of writing your own Getter function. The 'view' keyword means this function
// consumes 0 gas (is free to call), and cannot/does not modify any piece of state.
    function viewLastGuess() public view returns (string _lastGuess) {
        return lastGuess;
    }
    
}