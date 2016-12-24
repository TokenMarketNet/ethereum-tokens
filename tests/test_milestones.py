
def test_create_contract(chain):
    milestones = chain.get_contract('tokenmarket/test-helpers/TestableMilestones')
    assert milestones.call().getMilestonesCount() == 0
    assert milestones.call().milestonesSealed == False

