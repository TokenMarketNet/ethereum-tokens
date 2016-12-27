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

import "zeppelin/token/StandardToken.sol";
import "zeppelin/Ownable.sol";
import "./DividendsCarrier.sol";


/**
 * A token carrying following properties
 *
 * - Dividends carrying with scrambling
 *
 */
contract DividendsToken is StandardToken, Ownable {

    DividendsCarrier public dividendsCarrier;

    // Event telling the latest balance of an address
    event BalanceUpdated(address indexed addr, uint balance);

    event DividendsCarrierChanged(address indexed addr);

    function setDividendsCarrier(DividendsCarrier to_) public onlyOwner {
        dividendsCarrier = to_;
        DividendsCarrierChanged(to_);
    }

    function transferInternal(address _from, address _to, uint _value) internal returns(bool success) {

        var all = (balances[_from] == _value);

        // Blocked by
        // - dividends carrying status scrambling
        // - dividends halt mode
        // - KYC issue
        dividendsCarrier.transfer(_from, _to, all);

        balances[_from] = safeSub(balances[_from], _value);
        balances[_to] = safeAdd(balances[_to], _value);

        Transfer(_from, _to, _value);
        BalanceUpdated(_from, balances[_from]);
        BalanceUpdated(_to, balances[_to]);
        return true;
    }

    function transfer(address _to, uint _value) returns (bool success) {
        return transferInternal(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        var _allowance = allowed[_from][msg.sender];
        allowed[_from][msg.sender] = safeSub(_allowance, _value);
        return transferInternal(_from, _to, _value);
  }

}