======================================
Know Your Customer partner integration
======================================

Introduction
============

TokenMarket provides a smart contract for managing Know Your Customer status of Ethereum token holders. Know Your Customer status can be updated by chosen set of partners.

The partnership integration is managed through `KYC Ethereum smart contract <>`_.

Rules
=====

KYC partners are trusted. Any partner can freeze or clear any address.

Partner requirements
====================

KYC partners must be able to interact with Ethereum blockchain.

* They run their own Ethereum node (

Partner enrollment
==================

* KYC partner contacts token contract owner and reports their Ethereum public key (address) they are going to use for the clearance

* Token contract owner registers the partner through `