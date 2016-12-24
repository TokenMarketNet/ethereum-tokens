pragma solidity ^0.4.4;

/**
 * Allow overriding now time for testing purposes.
 */
contract TestableNow {

    uint public currentNow = 0;

    function setNow(uint now_) public {
        currentNow = now_;
    }

    function getNow(uint now_) public constant returns (uint) {

        // Not set
        if(currentNow == 0) {
            throw;
        }

        currentNow = now_;
    }

}