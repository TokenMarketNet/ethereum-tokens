
pragma solidity ^0.4.4;

/**
 * Abstract interface declaring now function.
 *
 * Allows design for testing, so that now value can be easily overridden in tests.
 *
 */
contract TimeBased {

    //
    // Abstract functions
    //

    /**
     * Allow override
     *
     * Returns the result of 'now' statement of Solidity language
     *
     * @return unix timestamp for current moment in time
     */
    function getNow() public constant returns (uint);
}