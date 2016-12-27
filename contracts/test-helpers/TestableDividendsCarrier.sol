/**
 * Copyright 2016 TokenMarket Ltd.
 *
 * You may not, without the author's express written permission, copy, deploy, modify or mirror any material presented here. You may not, without the author's express written permission, use any material presented here to create derivative works. This material includes, but is not limited to, source code, deployment scripts, interface descriptions and business process descriptions.
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

pragma solidity ^0.4.4;

import "zeppelin/token/ERC20.sol";
import "../tokenmarket/DividendsCarrier.sol";


/**
 * Test stub for testing token + dividends carrier co-operation.
 *
 */
contract TestableDividendsCarrier is DividendsCarrier {

    bool public canClaimFlag = false;
    bool public canTransferFlag= false;
    bool public alreadyClaimedFlag= false;
    uint public dividendsOnAddress = 0;
    ERC20 public token;

    function setToken(ERC20 token_) {
        token = token_;
    }

    function setState(bool canClaimFlag_, bool canTransferFlag_, bool alreadyClaimedFlag_, uint dividendsOnAddress_) public {
        canClaimFlag = canClaimFlag_;
        canTransferFlag = canTransferFlag_;
        alreadyClaimedFlag = alreadyClaimedFlag_;
        dividendsOnAddress = dividendsOnAddress_;
    }

    /**
     * Check if address contains unclaimed dividends.
     *
     * Unpaid dividends may prevent transferring tokens to prevent pay out double dipping.
     *
     */
    function hasUnclaimedDividends(address shareholderAddress) public constant returns (bool) {
        return dividendsOnAddress != 0;
    }

    /**
     * Ask how much dividends particular address received in a batch.
     *
     *
     */
    function getAvailableDividends(uint batchNum, address shareholderAddress) public constant returns (uint256) {
        return dividendsOnAddress;
    }

    /**
     * Can a shareholder address claim dividends.
     *
     * Failure reasons are 1) claiming process is temporary halted 2) shareholder address has not performed KYC.
     */
    function canClaim(uint batchNum, address shareholderAddress) public constant returns (bool) {
        return canClaimFlag;
    }

    /**
     * The shareholder claims her dividends.
     *
     * The function transactor must be an address that has been issued dividends.
     *
     * Under the following conditions the dividends cannot be claimed and the function throws
     * - emergency mode is set (Stoppable)
     * - dividend batch number is invalid
     * - dividend batch is already claimed for this shareholder
     * - shareholder address lacks KYC clearance
     * - no dividends issued for this address
     *
     */
    function claimByShareholder(uint batchNum, address payToAddress) {
    }

    /**
     * Is token transfer allowed between addresses.
     *
     * Dividend carrying tokens are transferred between addresses.
     *
     * Throws if there unredeemed dividends scramble between addresses.
     *
     */
    function canTransfer(address from_, address to_) public constant returns (bool) {
        return canTransferFlag;
    }


    function transfer(address from_, address to_, bool all) {

        // Only allowd to be called by the token contract
        if(msg.sender != address(token)) {
            throw;
        }

        if(!canTransferFlag) {
            throw;
        }
    }

    /**
     * How many dividends issuance batches are available.
     *
     * Note that be batch may not be claimable until DividendsBatchReady event.
     */
    function getBatchCount() public constant returns (uint) {
        return 1;
    }

    /**
     * Human readable name of issuance batch
     *
     * E.q. Q1/2017.
     *
     * Only available after DividendsBatchReady event.
     */
    function getBatchName(uint batchNum) public constant returns (string) {
        return "Dividends Q1/2017";
    }

    /**
     * Return total issued diviends for a batch.
     *
     * Return amount in wei.
     */
    function getBatchDividendsAmount(uint batchNum) public constant returns (uint) {
        return 1000 ether;
    }

    /**
     * Has shareholder claimed this issuance.
     *
     */
    function hasShareholderClaimedIssuance(uint batchNum, address shareholderAddress) public constant returns (bool) {
        return alreadyClaimedFlag;
    }
}