pragma solidity ^0.4.4;

import "../tokenmarket/TimeBased.sol";

/**
 * Allow overriding now time for testing purposes.
 */
contract TestableNow is TimeBased {

    // 0 is "null" time to simulate condition when time is not set,
    // to make sure you always set time before getNow() call
    uint public currentNow = 0;

    function setNow(uint now_) public {

        // Cannot set to "null"
        if(now_ == 0) {
            throw;
        }

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