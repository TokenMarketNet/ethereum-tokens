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
def token(request, chain, carrier):
    token = chain.get_contract("DividendsToken")
    token.transact().setDividendsCarrier(carrier.address)
    return token


def test_create_contract(token, carrier):
    """We can deploy milestone based contract."""
    assert token.call().dividendsCarrier() == carrier.address
