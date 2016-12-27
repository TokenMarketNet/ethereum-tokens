from enum import Enum

import pytest

class KYCStatus(Enum):
    unknown = 0
    frozen = 1
    cleared = 2


@pytest.fixture()
def contract(request, chain, kyc_partner1, kyc_partner2):

    contract = chain.get_contract("KYC")

    # Set KYC parties
    contract.transact().addKYCPartner(kyc_partner1)
    contract.transact().addKYCPartner(kyc_partner2)

    return contract


def test_set_address_status_by_partner(contract, kyc_partner1, kyc_partner2, boogieman):
    """KYC partners can modify address status."""

    contract.transact({"from": kyc_partner1}).freezeAccount(boogieman)
    contract.call().getAddressStatus(boogieman) == KYCStatus.frozen.value

    contract.transact({"from": kyc_partner2}).clearAccount(boogieman)
    contract.call().getAddressStatus(boogieman) == KYCStatus.cleared.value


def test_set_address_status_by_owner(contract, kyc_partner1, kyc_partner2, boogieman):
    """Owner can modify address status."""

    contract.transact().freezeAccount(boogieman)
    contract.call().getAddressStatus(boogieman) == KYCStatus.frozen.value

    contract.transact().clearAccount(boogieman)
    contract.call().getAddressStatus(boogieman) == KYCStatus.cleared.value


def test_remove_kyc_membership(contract, kyc_partner1, kyc_partner2, boogieman):
    """Owner can revoke the KYC partner rights."""

    contract.transact().removeKYCPartner(kyc_partner1)

    # Revoke
    with pytest.raises(ValueError):
        contract.transact({"from": kyc_partner1}).freezeAccount(boogieman)

    # Add back
    contract.transact().addKYCPartner(kyc_partner1)

    # Works again
    contract.transact({"from": kyc_partner1}).freezeAccount(boogieman)


def test_unknown_address(contract, kyc_partner1, kyc_partner2, boogieman):
    """Addresses without explicitly set status have status unknown."""
    contract.transact().getAddressStatus(boogieman) == KYCStatus.unknown.value



