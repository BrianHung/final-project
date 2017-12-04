pragma solidity ^0.4.14;

import "./Queue.sol";

contract MultisigWallet {

    
    address[] owners;
    uint256[] tiers;

    uint256 totalWeight;
    uint256 maxTier;

    mapping (address => uint) weights;
    mapping (address => uint) balance;

    Queue pending;

    mapping (bytes32 => uint) approve;

    mapping (bytes32 =>
     mapping (address => bool)) check;


    struct Request {
        address to; uint value; bytes data;
    }

    function MultisigWallet(address[] _owners) {
        owners = _owners; pending = Queue(5);
        setDefaultTiers(); setDefaultWeights();
    }


    modifier OwnerOnly() {
        require (isOwner(msg.sender));
        _;
    }

    function isOwner(address addr) private constant returns (bool) {
        bytes32 hashedAddr = keccak256(addr);
        for (uint i = 0; i < owners.length; i++) {
            if (keccak256(owners[i]) == hashedAddr) {
                return true;
            }
        }
        return false;
    }


    function setDefaultTiers() private {
        maxTier = 5;
        for (uint i = 1; i <= maxTier; i++) {
            tiers[i]= (totalWeight / maxTier) * i;
        }
    }

    function setDefaultWeights() private {
        totalWeight = 100;
        for (uint i = 0; i < owners.length; i++) {
            weights[owners[i]] = 100 / owners.length;
        }
    }


    function request(uint256 value) OwnerOnly() returns (bool) {
        return pending.enqueue(msg.sender, value, msg.data);
    }

    function withdraw(uint256 value) returns (bool) {
        uint bal = balance[msg.sender];
        if (value <= bal) {
            balance[msg.sender] = bal - value;
            msg.sender.transfer(bal);
            return true;
        } else {
            return false;
        }
    }


    function nullify(uint index) OwnerOnly {
        Request memory req = pending.getRequest(index);
        if (keccak256(req.to) == keccak256(msg.sender)) {
            pending.dequeue(index);
        }
    }

    function confirm(uint index) OwnerOnly returns (bool) {
        Request memory req = pending.getRequest(index);
        if (check[keccak256(req)][msg.sender]) {
            return false;
        } else {
            approve[keccak256(req)] += weights[msg.sender];
        }
    }

    function process(uint index) OwnerOnly returns (bool) {
        Request memory req = pending.getRequest(index);
        if (approve[keccak256(req)] >= tiers[getTier(req.value)]) {
            balance[req.to] += req.value;
            pending.dequeue(index); return true;
        } else {
            return false;
        }
    }


    function getTier(uint value) private returns (uint) {
        for (uint tier = maxTier; tier > 0; tier--) {
            if (value > tiers[tier]) { return tier; }
        }
        return 0;
    }

    function() payable {
        if (msg.value > 0) { balance[msg.sender] += msg.value; }
    }


}
