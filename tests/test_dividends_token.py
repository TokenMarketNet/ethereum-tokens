import pytest


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


def set_state(token, canClaimFlag=False, canTransferFlag=False, alreadyClaimedFlag=False, dividendsOnAddress=0):
    """Set internal test state."""
    carrier = token.call().dividendsCarrier()
    carrier.setState(canClaimFlag, canTransferFlag, alreadyClaimedFlag, dividendsOnAddress)


def test_create_contract(token, carrier):
    """We can deploy milestone based contract."""
    assert token.call().dividendsCarrier() == carrier.address


def test_transfer(token, shareholder1, boogieman):
    """Tokens should be transferable if the carrier does not block the transfer."""

    token.setState(canTransferFlag=True)
    token.transact({"from": shareholder1}).transfer(shareholder1, boogieman)
    assert token.balanceOf(shareholder1) == 0
    assert token.balanceOf(boogieman) == 4000


def test_transfer_blocked(token, shareholder1, boogieman):
    """Tokens should not be transferable if the carrier blocks the transfer."""

    token.setState(canTransferFlag=False)
    token.transact({"from": shareholder1}).transfer(shareholder1, boogieman)
    assert token.balanceOf(shareholder1) == 0
    assert token.balanceOf(boogieman) == 4000
