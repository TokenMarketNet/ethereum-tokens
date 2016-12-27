======================================
Know Your Customer partner integration
======================================

.. contents:: :local:

Introduction
============

TokenMarket provides a smart contract for managing Know Your Customer status of Ethereum token holders. Know Your Customer status can be updated by trusted vendors (exchanges and such) through a partnership program with the token issuer.

The partnership integration is managed through `KYC Ethereum smart contract <https://github.com/TokenMarketNet/ethereum-tokens/blob/master/contracts/tokenmarket/KYC.sol>`_.

Motivation
==========

When dealing with regulated and real assets, like equity, the asset manager must adhere to the local regulation. Often this regulation says that one must know the asset owners before engaging to business relationship with them.

KYC smart contract allows create Know Your Customer programs to cope with the established business practices. This includes, but is not limited, to

* Stop transfers in the case of reported crime like a stolen user account

* Handle incorporation edge cases like acquisitions, mergers and bankrupts

* Pay dividends only to good know owners - anti money laundering (AML)

Rules
=====

KYC vendors are trusted. Any partner can freeze or clear any address.

Partner requirements
====================

KYC partners must be able to interact with Ethereum blockchain.

* They run their own Ethereum node (`Go Ethereum <https://github.com/ethereum/go-ethereum/>`_, `Parity <https://ethcore.io/parity.html>`_, etc).

* Their back office system can interact with smart contracts. Libraries to interact include `Populus (Python) <http://populus.readthedocs.io/>`_, `Web3.js (JavaScript) <https://github.com/ethereum/web3.js/>`_

* KYC partners create their own Ethereum address (private key, public key pair) for the operations and hold minimal Etheruem balance required for these operations

Partner enrollment
==================

* KYC partner contacts token contract owner and reports their Ethereum public key (address) they are going to use for the clearance

* Token issuer registers the partner through `addKYCPartner` function

* After this KYC partner can call `freezeAccount` and `clearAccount` functions to signal they have cleared a particular Ethereum address holder and have KYC documentation available for her


About TokenMarket
=================

`TokenMarket <https://tokenmarket.net>`_ is a digital asset platform for investors and growth companies to issue assets, trade in secondary markets and run corporate governance. Crowdfunding, blockchain based initial coin offerings (ICOs) and outflow of Asian capital have become an attractive source of financing; the most profitable investment deals are no longer limited to a few privileged equity companies. TokenMarket's blockchain based tools are building blocks for creating networks of global secondary markets and creating a diverse investor base, which are prerequisites to tap the full potential of globalization and the democratization of the investment industry.
