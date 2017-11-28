pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Wallet.sol";

contract TestWallet {

  function testInitialBalanceUsingDeployedContract() {
    Wallet wallet = Wallet(DeployedAddresses.Wallet());
    uint expected = 0;
    Assert.equal(wallet.getBalance(), expected, "Owner should have 0 balance initially");
  }

  function testBalanceWithDeposit() {
    Wallet wallet = Wallet(DeployedAddresses.Wallet());
    uint expected = 10000;
    wallet.transfer(expected);
    Assert.equal(wallet.getBalance(), expected, "Owner should have 10000 balance after deposit.");
  }

}
