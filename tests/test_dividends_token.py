import datetime
import os

import pytest

from populus.plugin import create_project
from populus.utils.config import Config
from web3.contract import Contract



@pytest.fixture()
def carrier(request, chain):
    return chain.get_contract("TestableDividendsCarrier")


@pytest.fixture()
def coinbase(request, chain):
    return chain.web3.eth.coinbase


@pytest.fixture()
def token(request, chain, carrier, coinbase, shareholder1, shareholder2):
    token = chain.get_contract("TestableDividendsToken")
    token.transact().setDividendsCarrier(carrier.address)

    # Set some initial balances
    token.transact().setBalance(coinbase, 10000)
    token.transact().transfer(shareholder1, 4000)
    token.transact().transfer(shareholder2, 6000)

    return token


def test_create_contract(token, carrier):
    """We can deploy milestone based contract."""
    assert token.call().dividendsCarrier() == carrier.address
