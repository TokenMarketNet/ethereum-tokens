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

/**
 * A token carrying following properties
 *
 * - Milestone based crowdsale
 *
 * - KYC clearance for crowdsale participants
 *
 * - Dividends paying
 *
 */
contract TokenMarketToken is StandardToken {

    mapping(address => bool) public initialParticipant;

    function transfer(address _to, uint _value) returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

  function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        var _allowance = allowed[_from][msg.sender];

        balances[_to] = safeAdd(balances[_to], _value);
        balances[_from] = safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = safeSub(_allowance, _value);
        Transfer(_from, _to, _value);
        return true;
  }

}