# IPBS

Brian Hung. Final Project for Blockchain for Developers, Fall 2017.

## Overview

IPBS - InterPlanetary Banking System - is an Ethereum smart contract that provides the functionality of a bank account without the overhead.

## Basic Implementations

Withdrawals & Deposits: users should be able to withdraw and deposit Ether into their own accounts,
and if permitted, withdraw and or deposit from other users' accounts.

Multisig Wallet: an account should be accessible by multiple users. Control of Ether funds can be
structured as flat, where each user has equal voting weight; or tiered, where each user is assigned
a voting weight from a predefined bucket.

## Additional Features (if Time-permitted)

Frontend Integration: instead of requiring users to direct themselves to an IPFS gateway to view transactions,
or directly deal with the Ethereum contract, users should be able to use login with a pre-existing supported account
maintained by a 3rd party (e.g. Google, Facebook, Github) and view and commit transactions.

Experimentation with Tether: USDT, maintained by Bitfinex, is a cryptocurrency which is tethered 1:1 with
the USD. Instead of riding the waves of Ether, it is possible to stabilize the value of an account?

## Stack

Ethereum: where the contract is operated.

IPFS: everytime a transaction is made within an account, the change will be reflected and stored in an IPFS node
that is accessible by authorized users of that account.

## ETC.-
I'll see how far I get with the multisig wallet :) Also if you're wondering why there's a folder called "Mastodon" in this repository, it's because I had a initial idea to have a Twitter clone use IPFS to store tweets, and force new users to temporarily deposit Ether into a contract to reduce the amount of spammers / bots -- but that seems out of reach given the Gitlet project also assigned to me :(
