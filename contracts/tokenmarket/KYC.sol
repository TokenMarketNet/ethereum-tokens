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
 * Know Your Customer status and partnership program management.
 *
 *
 *
 */
contract KYC is Ownable {

    // How many different KYC partners (keys) we support
    public constant MAX_KYC_PARTNERS = 10;

    enum KYCStatus {
        unknown, // 0: Initial status when nothing has been done for the address yet
        cleared, // 1: Address cleared by owner or KYC partner
        frozen, // 2: Address frozen by owner or KYC partner
    };

    // New KYC partner introduced
    event AddedKYCPartner(address addr);

    // KYC partner removed
    event RemovedKYCPartner(address addr);

    // KYC partner set account blocked
    event AccountFrozen(address addr);

    // KYC partner set account status cleared
    event AccountCleared(address addr);

    // KYC status map
    public mapping(address=>byte) addressKYCStatus;

    // List of KYC partners
    public address[] kycPartners;

    /**
     * Owner may add a new party that is allowed to perform KYC.
     *
     */
    function addKYCPartner(address addr) public onlyOwner;

    /**
     * Owner may add a new party that is allowed to perform KYC.
     *
     */
    function removeKYCPartner(address addr) public onlyOwner;

    /**
     * Stop all transfers by an account.
     *
     * Must be called by the owner or KYC partner.
     */
    function freezeAccount(address addr) public onlyOwnerOrPartner;

    /**
     * Allow transfer by an account.
     *
     * Must be called by the owner or KYC partner.
     */
    function clearAccount(address addr) public onlyOwnerOrPartner;

}