import datetime
import os

import ethereum
import pytest
from ethereum.tester import TransactionFailed

from populus.plugin import create_project
from populus.utils.config import Config


def to_timestamp(dt):
    """http://stackoverflow.com/a/8778548/315168"""
    return int(dt.replace(tzinfo=datetime.timezone.utc).timestamp())


def to_dt(timestamp):
    return datetime.datetime.fromtimestamp(timestamp).repace(tzinfo=datetime.timezone.utc)


@pytest.fixture(scope="module")
def project(request):
    """Create a Populus project to run tests with custom import remappings."""
    config = Config()
    config.add_section("solc")

    # Set path mapping for Zeppelin sol files
    remappings = "zeppelin=" + os.path.join(os.path.abspath(os.getcwd()), "zeppelin")
    config.set("solc", "remappings", remappings)
    return create_project(request, config)


@pytest.fixture()
def contract(request, chain):
    return chain.get_contract("TestableMilestonePriced")


def test_create_contract(contract):
    """We can deploy milestone based contract."""
    assert contract.call().tested() == False
    assert contract.call().currentNow() == 0
    assert contract.call().getMilestoneCount() == 0


def test_add_milestones(contract):
    """We can succesfully add milestones and seal the contract."""

    milestones = [
        [to_timestamp(datetime.datetime(2017, 1, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 200],
        [to_timestamp(datetime.datetime(2017, 3, 1)), 0],  # End
    ]

    for t, price in milestones:
        print(t, price)
        contract.transact().addMilestone(t, price)

    contract.transact().sealMilestones()

    assert contract.call().getMilestoneCount() == 3

    for i in range(0, 3):
        t, price = contract.call().getMilestone(i)
        assert t == milestones[i][0]
        assert price == milestones[i][1]


def test_add_wrong_order(contract):
    """Enforce milestone creation order."""

    milestones = [
        [to_timestamp(datetime.datetime(2017, 2, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 1, 1)), 200],
    ]

    contract.transact().addMilestone(milestones[0][0], milestones[0][1])
    with pytest.raises(ValueError):
        contract.transact().addMilestone(milestones[1][0], milestones[1][1])


def test_seal_without_end(contract):
    """Make sure we terminate with price 0 milestone."""

    milestones = [
        [to_timestamp(datetime.datetime(2017, 1, 1)), 100],
        [to_timestamp(datetime.datetime(2017, 2, 1)), 200],
    ]

    contract.transact().addMilestone(milestones[0][0], milestones[0][1])
    contract.transact().addMilestone(milestones[1][0], milestones[1][1])

    with pytest.raises(ValueError):
        contract.transact().sealMilestones()

