import os

import pytest
from populus.plugin import create_project
from populus.utils.config import Config


@pytest.fixture(scope="session")
def project(request):
    """Create a Populus project to run tests with custom import remappings."""
    config = Config()
    config.add_section("solc")

    # Set path mapping for Zeppelin sol files
    remappings = "zeppelin=" + os.path.join(os.path.abspath(os.getcwd()), "zeppelin")
    config.set("solc", "remappings", remappings)
    return create_project(request, config)


@pytest.fixture()
def shareholder1(request, chain):
    web3 = chain.web3
    return web3.eth.accounts[1]


@pytest.fixture()
def shareholder2(request, chain):
    web3 = chain.web3
    return web3.eth.accounts[2]


@pytest.fixture()
def kyc_partner1(request, chain):
    web3 = chain.web3
    return web3.eth.accounts[1]


@pytest.fixture()
def kyc_partner2(request, chain):
    web3 = chain.web3
    return web3.eth.accounts[2]


@pytest.fixture()
def boogieman(request, chain):
    web3 = chain.web3
    return web3.eth.accounts[3]