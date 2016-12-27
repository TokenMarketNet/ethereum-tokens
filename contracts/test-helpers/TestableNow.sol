pragma solidity ^0.4.4;

import "../tokenmarket/TimeBased.sol";

/**
 * Allow overriding now time for testing purposes.
 */
contract TestableNow is TimeBased {

    uint public currentNow = 0;

    function setNow(uint now_) public {
        currentNow = now_;
    }

    function getNow() public constant returns (uint) {

        // Not set
        if(currentNow == 0) {
            throw;
        }

        return currentNow;
    }
}