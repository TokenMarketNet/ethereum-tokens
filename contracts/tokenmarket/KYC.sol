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

import "zeppelin/Ownable.sol";
import "../libraries/AddressSet.sol";


/**
 * Know Your Customer status and partnership program management.
 *
 *
 *
 */
contract KYC is Ownable {

    // KYC status value, compressed to uint8
    enum KYCStatus {
        unknown, // 0: Initial status when nothing has been done for the address yet
        cleared, // 1: Address cleared by owner or KYC partner
        frozen // 2: Address frozen by owner or KYC partner
    }

    // New KYC partner introduced
    event AddedKYCPartner(address addr);

    // KYC partner removed
    event RemovedKYCPartner(address addr);

    // KYC partner set account blocked
    event AccountFrozen(address addr, address indexed by);

    // KYC partner set account status cleared
    event AccountCleared(address addr, address indexed by);

    // KYC status map
    mapping(address=>uint8) public addressKYCStatus;

    AddressSet.Data kycPartners;

    /**
     * Owner may add a new party that is allowed to perform KYC.
     *
     */
    function addKYCPartner(address addr) public onlyOwner {

        if(!AddressSet.insert(kycPartners, addr)) {
            // Already there
            throw;
        }

        AddedKYCPartner(addr);
    }

    /**
     * Owner may add a new party that is allowed to perform KYC.
     *
     */
    function removeKYCPartner(address addr) public onlyOwner {

        if(!AddressSet.remove(kycPartners, addr)) {
            // Already there
            throw;
        }

        RemovedKYCPartner(addr);
    }

    /**
     * Query KYC status of a particular address.
     *
     */
    function getAddressStatus(address addr) public constant returns (uint8) {
        return uint8(addressKYCStatus[addr]);
    }

    /**
     * Stop all transfers by an account.
     *
     * Must be called by the owner or KYC partner.
     */
    function freezeAccount(address addr) public onlyOwnerOrPartner {
        var status = addressKYCStatus[addr];

        // Already frozen
        if(status == uint8(KYCStatus.frozen)) {
            throw;
        }

        addressKYCStatus[addr] = uint8(KYCStatus.frozen);

        AccountFrozen(addr, msg.sender);
    }


    /**
     * Allow transfer by an account.
     *
     * Must be called by the owner or KYC partner.
     */
    function clearAccount(address addr) public onlyOwnerOrPartner {
        var status = addressKYCStatus[addr];

        // Already frozen
        if(status == uint8(KYCStatus.cleared)) {
            throw;
        }

        addressKYCStatus[addr] = uint8(KYCStatus.cleared);

        AccountCleared(addr, msg.sender);
    }

    /**
     * Only the KYC process owner or KYC partners are allowed to call this function.
     */
    modifier onlyOwnerOrPartner() {

        if(!(msg.sender == owner || AddressSet.contains(kycPartners, msg.sender))) {
            throw;
        }

        _;
    }

}