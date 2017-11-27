pragma solidity ^0.4.18;

contract Queue {

    uint private back;

    struct Transaction {
        address sender;
        address recipient;
        uint256 value;
    }

    Transaction[] private txs;

    function Queue() {
        back = 0;
    }

    function size() constant returns (uint) {
        return txs.length;
    }

    function enqueue(Transaction tx) {
        txs[back] = tx;
        back++;
    }

    function dequeue() returns (Transaction) {
        Transaction tx = txs[0];
        txs[0] = txs[back]; back--;
        return tx;
    }

}
