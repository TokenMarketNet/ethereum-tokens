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
    carrier.transact().setToken(token.address)

    # Set some initial balances
    set_state(chain, token, canTransferFlag=True)
    token.transact().setBalance(coinbase, 10000)
    token.transact().transfer(shareholder1, 4000)
    token.transact().transfer(shareholder2, 6000)

    return token


def set_state(chain, token, canClaimFlag=False, canTransferFlag=False, alreadyClaimedFlag=False, dividendsOnAddress=0):
    """Set internal test state of dividends stub."""
    carrier_address = token.call().dividendsCarrier()
    factory = chain.get_contract_factory("TestableDividendsCarrier")
    carrier = factory(address=carrier_address)
    carrier.transact().setState(canClaimFlag, canTransferFlag, alreadyClaimedFlag, dividendsOnAddress)


def test_create_contract(token, carrier):
    """We can deploy milestone based contract."""
    assert token.call().dividendsCarrier() == carrier.address


def test_transfer(chain, token, shareholder1, boogieman):
    """Tokens should be transferable if the carrier does not block the transfer."""

    set_state(chain, token, canTransferFlag=True)
    token.transact({"from": shareholder1}).transfer(boogieman, 4000)
    assert token.call().balanceOf(shareholder1) == 0
    assert token.call().balanceOf(boogieman) == 4000


def test_transfer_blocked(chain, token, shareholder1, boogieman):
    """Tokens should not be transferable if the carrier blocks the transfer."""

    set_state(chain, token, canTransferFlag=False)
    with pytest.raises(ValueError):
        token.transact({"from": shareholder1}).transfer(boogieman, 4000)


def test_transfer_bypass_token(chain, token, carrier, shareholder1, boogieman):
    """We should not be able to directly manipulate transfer() in dividends contract."""

    set_state(chain, token, canTransferFlag=True)
    with pytest.raises(ValueError):
        # This call must always come from token contract
        carrier.transact().transfer(shareholder1, boogieman, True)
