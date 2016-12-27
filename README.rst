==================
TokenMarket tokens
==================

.. contents :: :local:

Introduction
============

This repository contains `TokenMarket <https://tokenmarket.net>`_ Ethereum smart contract source code.

Some available contracts include

* Milestone based pricing

* Dividends issuance

* Dividends carrying token

* Know Your Customer state management

* Crowdfunded token that combines all the features above

`Populus toolchain <http://populus.readthedocs.io/>`_ is used to manage and test contracts.

Installation
============

`First create Python 3.5 virtual environment <https://packaging.python.org/en/latest/installing/>`_.

Contracts depend on `Zeppelin Solidity <https://github.com/OpenZeppelin/zeppelin-solidity/>`_ package which is not distributed with the source code.

To compile the contracts:

.. code-block:: console

    npm install zeppelin-solidity
    populus compile

Running tests
=============

Tests are py.test and `Populus based <http://populus.readthedocs.io/>`_.

To run the tests::

    pip install -r requirements.txt
    py.test tests

Questions
=========

For any questions contract `info@tokenmarket.net <mailto:info@tokenmarket.net>`_.

Licensing
=========

Please read the `license <https://github.com/TokenMarketNet/ethereum-tokens/blob/master/license.txt>`_ before using any presented material here.

About TokenMarket
=================

`TokenMarket <https://tokenmarket.net>`_ is a digital asset platform for investors and growth companies to issue assets, trade in secondary markets and run corporate governance. Crowdfunding, blockchain based initial coin offerings (ICOs) and outflow of Asian capital have become an attractive source of financing; the most profitable investment deals are no longer limited to a few privileged equity companies. TokenMarket's blockchain based tools are building blocks for creating networks of global secondary markets and creating a diverse investor base, which are prerequisites to tap the full potential of globalization and the democratization of the investment industry.
