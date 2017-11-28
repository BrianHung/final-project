pragma solidity ^0.4.17;

import "./Queue.sol";


contract MultisigWallet {

    address[] public owners;

    uint private totalWeights;
    uint[] private bucketMins;

    Queue public pendingTX;

    mapping (address => uint) weights;
    mapping (address => uint) balance;
    mapping (uint    => uint) buckets;

    struct Transact {
        address sender;
        address recipient;
        uint256 value;
    }

    Transact ts;

    function Multisig(address[] _owners, uint[] _weights) {
        require(_owners.length == _weights.length);

        owners = _owners;
        setWeights(_weights);

        pendingTX = new Queue();
    }

    function Multisig(address[] _owners) {

        owners = _owners;
        setDefaultWeights();

        pendingTX = new Queue();
    }

    function setWeights(uint[] _weights) private {
        for (uint i = 0; i < owners.length; i += 1) {
            balance[owners[i]] = _weights[i];
            totalWeights += _weights[i];
        }
    }

    function setDefaultWeights() private {
        totalWeights = 100; uint const = totalWeights / owners.length;
        for (uint i = 0; i < owners.length; i += 1) {
            balance[owners[i]] = const;
        }
    }

    function setDefaultBuckets() private {
        bucketMins = [1, 5, 10, 25, 50, 100];
        for (uint i = 0; i < bucketMins.length; i += 1) {
            buckets[i] = (bucketMins[i] / 100) * totalWeights;
        }
    }

    function request(uint256 _value, address _recipient) {
        pendingTX.enqueue(msg.sender, _recipient, _value);
    }

    function request(uint256 _value) {
        request(_value, msg.sender);
    }

    function withdraw(uint256 _value, address _recipient) {

        address recipient = _recipient;
        require(balance[recipient] >= _value);

        balance[recipient] -= _value;
        if (!recipient.send(_value)) {
             balance[recipient] += _value;
        }
    }

    function withdraw(uint256 _value) {
        withdraw(_value, msg.sender);
    }

    function checkBalance() returns (uint256) {
        return balance[msg.sender];
    }

    function() payable {
        balance[msg.sender] = msg.value;
    }
}
