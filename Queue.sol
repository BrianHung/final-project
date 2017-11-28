pragma solidity ^0.4.17;

import './MultisigWallet.sol';

contract Queue {

    uint private back;

    MultisigWallet.Transact[] private txs;

    MultisigWallet.Transact ts;

    function Queue() {
        back = 0;
    }

    function size() constant returns (uint) {
        return txs.length;
    }

    function enqueue(address sender, address receipient, uint value) {
        txs[back] = MultisigWallet.Transact(sender, receipient, value);
        back++;
    }

    function dequeue() returns (MultisigWallet.Transact) {
        ts = txs[0];
        txs[0] = txs[back]; back--;
        return ts;
    }

}
