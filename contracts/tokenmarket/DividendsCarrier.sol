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

/**
 * Describe dividends carrying and redeeming contract interface.
 *
 */
contract DividendsCarrier {

    // The claiming of dividends from this batch can begun
    event DividendsBatchReady(uint indexed batchNum);

    // New dividends have been issued.
    // They cannot be redeemed before the issuance batch is selaed.
    event DividendsIssued(uint indexed batchNum, address indexed shareholder, uint256 value);

    // Shareholder claimed their own dividends or they were forcefully claimed by the owner
    event DividendsPaid(uint indexed batchNum, address indexed shareholder, address indexed paidTo, uint256 value);

    /**
     * Ask how much dividends particular address received in a batch.
     *
     *
     */
    function getAvailableDividends(uint batchNum, address shareholderAddress) public constant returns (uint256);

    /**
     * Can a shareholder address claim dividends.
     *
     * Failure reasons are 1) claiming process is temporary halted 2) shareholder address has not performed KYC.
     */
    function canClaim(uint batchNum, address payToAddress) public constant returns (bool);

    /**
     * Customer self claims dividends.
     *
     * The function caller must be an address that has been issued dividends.
     *
     * Dividends cannot be claimed if emergency mode is set.
     *
     */
    function claimDividends(uint batchNum, address payToAddress);

    /**
     * Is token transfer allowed between addresses.
     *
     * Dividend carrying tokens are transferred between addresses.
     *
     * Throws if there unredeemed dividends scramble between addresses.
     *
     */
    function canTransfer(address from_, address to_) public constant returns (bool);

}