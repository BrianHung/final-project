pragma solidity 0.4.15;

contract Wallet {

    address private owner;

    mapping (address => uint) balance;

    string constant balError = "Insufficient Balance.";
    string constant senError = "Error with send. Please try again.";

    event Deposit(address sender, uint256 value);
    event Sent(address recipient, uint256 value);

    event Error(string error);

    modifier OwnerOnly() {
	    if (msg.sender == owner)
	        _;
	}

    function Wallet() public {
        owner = msg.sender;
    }

    function getBalance() public returns (uint) {
        return balance[msg.sender];
    }

    function send(address recipient, uint value) public OwnerOnly() {

        uint currBalance = balance[recipient];
        uint remaining = currBalance - value;

        if (currBalance < value) {
            Error(balError);

        } else if (remaining > 0) {

            balance[recipient] = remaining;
            if (!recipient.send(value)) {
                balance[recipient] = currBalance;
            }

        } else {
            Error(senError);
        }
    }

    function withdraw(uint value) public OwnerOnly() {
        send(owner, value);
    }

    function deposit() public payable {
        balance[owner] += msg.value;
        Deposit(msg.sender, msg.value);
    }

    function () public payable {
        balance[owner] += msg.value;
        Deposit(msg.sender, msg.value);
    }

    function destruct(address recipient) public OwnerOnly() {
        selfdestruct(recipient);
    }

}
