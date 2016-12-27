import datetime
import os

import pytest

from populus.plugin import create_project
from populus.utils.config import Config
from web3.contract import Contract


def to_timestamp(dt):
    """http://stackoverflow.com/a/8778548/315168"""
    return int(dt.replace(tzinfo=datetime.timezone.utc).timestamp())


def to_dt(timestamp):
    return datetime.datetime.fromtimestamp(timestamp).replace(tzinfo=datetime.timezone.utc)


@pytest.fixture()
def contract(request, chain):
    return chain.get_contract("TestableMilestonePriced")


def get_price(contract: Contract, now: datetime.datetime):
    contract.transact().setNow(to_timestamp(now))
    return contract.call().getPrice()


def test_create_contract(contract):
    """We can deploy milestone based contract."""
    assert contract.call().tested() == False
    assert contract.call().currentNow() == 0
    assert contract.call().getMilestoneCount() == 0


def test_add_milestones(contract):
    """We can succesfully add milestones and seal the contract."""

    milestones = [
        [0, 0],
        [to_timestamp(datetime.datetime(2017, 1, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 200],
        [to_timestamp(datetime.datetime(2017, 3, 1)), 0],  # End
    ]

    for t, price in milestones:
        contract.transact().addMilestone(t, price)

    contract.transact().sealMilestones()

    assert contract.call().getMilestoneCount() == 4

    for i in range(0, 3):
        t, price = contract.call().getMilestone(i)
        assert t == milestones[i][0]
        assert price == milestones[i][1]


def test_add_wrong_order(contract):
    """Enforce milestone creation order."""

    milestones = [
        [0, 0],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 1, 1)), 200],
    ]

    contract.transact().addMilestone(milestones[0][0], milestones[0][1])
    contract.transact().addMilestone(milestones[1][0], milestones[1][1])
    with pytest.raises(ValueError):
        contract.transact().addMilestone(milestones[2][0], milestones[2][1])


def test_bad_start(contract):
    """First milestone must be at UNIX epoch."""

    milestones = [
        [to_timestamp(datetime.datetime(2017, 1, 1)), 100],
    ]

    with pytest.raises(ValueError):
        contract.transact().addMilestone(milestones[0][0], milestones[0][1])


def test_seal_without_end(contract):
    """Make sure we terminate with price 0 milestone."""

    milestones = [
        [0, 0],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 200],
    ]

    contract.transact().addMilestone(milestones[0][0], milestones[0][1])
    contract.transact().addMilestone(milestones[1][0], milestones[1][1])

    with pytest.raises(ValueError):
        contract.transact().sealMilestones()


def test_get_price(contract):
    """See pricing function works."""

    milestones = [
        [0, 0],
        [to_timestamp(datetime.datetime(2017, 1, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 200],
        [to_timestamp(datetime.datetime(2017, 3, 1)), 0],  # End
    ]

    for t, price in milestones:
        contract.transact().addMilestone(t, price)

    contract.transact().sealMilestones()

    assert get_price(contract, datetime.datetime(2016, 12, 31)) == 0
    assert get_price(contract, datetime.datetime(2017, 1, 1)) == 100
    assert get_price(contract, datetime.datetime(2017, 1, 2)) == 100
    assert get_price(contract, datetime.datetime(2017, 1, 31)) == 100

    assert get_price(contract, datetime.datetime(2017, 2, 1)) == 200
    assert get_price(contract, datetime.datetime(2017, 2, 2)) == 200
    assert get_price(contract, datetime.datetime(2017, 2, 28)) == 200

    assert get_price(contract, datetime.datetime(2017, 3, 1)) == 0
    assert get_price(contract, datetime.datetime(2017, 3, 2)) == 0


def test_no_seal_no_price(contract):
    """Cannot get price before we are sealed."""

    milestones = [
        [0, 0],
        [to_timestamp(datetime.datetime(2017, 3, 1)), 100],  # End
    ]

    for t, price in milestones:
        contract.transact().addMilestone(t, price)

    with pytest.raises(ValueError):
        contract.call().getPrice()


def test_range(contract):
    """Test hasStarted and hasEnded."""

    milestones = [
        [0, 0],
        [to_timestamp(datetime.datetime(2017, 1, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 200],
        [to_timestamp(datetime.datetime(2017, 3, 1)), 0],  # End
    ]

    for t, price in milestones:
        contract.transact().addMilestone(t, price)

    contract.transact().sealMilestones()

    contract.transact().setNow(1)
    assert contract.call().hasStarted() == False
    assert contract.call().hasEnded() == False

    contract.transact().setNow(to_timestamp(datetime.datetime(2017, 1, 1)))
    assert contract.call().hasStarted() == True
    assert contract.call().hasEnded() == False

    contract.transact().setNow(to_timestamp(datetime.datetime(2017, 1, 2)))
    assert contract.call().hasStarted() == True
    assert contract.call().hasEnded() == False

    contract.transact().setNow(to_timestamp(datetime.datetime(2017, 3, 1)))
    assert contract.call().hasStarted() == True
    assert contract.call().hasEnded() == True

    contract.transact().setNow(to_timestamp(datetime.datetime(2017, 3, 2)))
    assert contract.call().hasStarted() == True
    assert contract.call().hasEnded() == True

