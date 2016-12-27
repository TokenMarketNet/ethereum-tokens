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
import "./TimeBased.sol";


/**
 * A contract that has milestone based pricing.
 *
 * We use block timestamp based timing. This means the time may be unreliable for short time periods (minutes). If subminute timing matters for your application consider use block number based time source.
 *
 * Discussion regarding block.timestamp vs. block.number as a timing source.
 *
 * - http://ethereum.stackexchange.com/a/5933/620
 * - http://ethereum.stackexchange.com/a/428/620
 * . https://ethereum.stackexchange.com/questions/9564/how-does-ethereum-avoid-inaccurate-timestamps-in-blocks
 *
 *
 *
 */
contract MilestonePriced is Ownable, TimeBased {

    /**
    * Define pricing schedule using milestones.
    */
    struct Milestone {

        // UNIX timestamp when this milestone kicks in
        uint time;

        // How many tokens per satoshi you will get after this milestone has been passed
        uint price;
    }


    // Prevent the creation of too lengthy arrays
    uint public constant MAX_MILESTONES = 10;

    // Internal milestone storage.
    // First Milestone is always (0, 0) and not real milestone.
    // Last Milestone is always with price 0 and not real milestone.
    // This is to simplify time based look ups.
    Milestone[] milestones;

    // Flag telling no more milestone changes coming
    bool public milestonesSealed = false;

    function addMilestone(uint time, uint price) onlyOwner public {

        if(milestonesSealed) {
            throw;
        }

        if(milestones.length >= MAX_MILESTONES) {
            throw;
        }

        // First milestone must be (0, 0)
        if(milestones.length == 0) {
            if(price != 0 || time != 0) {
                throw;
            }
        }

        milestones.push(Milestone(time, price));

        // Make sure milestones are added in creation order
        if(milestones.length > 1) {
            if(time <= milestones[milestones.length-2].time) {
                throw;
            }
        }
    }

    function getMilestoneCount() public constant returns (uint) {
        return milestones.length;
    }

    function getMilestone(uint n) public constant returns (uint, uint ) {
        return (milestones[n].time, milestones[n].price);
    }

    // After sealing the schedule, don't allow further changes
    function sealMilestones() onlyOwner {

        if(milestonesSealed) {
            throw;
        }

        // Price must be 0 on the terminating milestone
        if(milestones[milestones.length-1].price != 0) {
            throw;
        }

        // No further milestones allowed
        milestonesSealed = true;
    }

    // UNIX timestamp when crowdsale is on
    function getStartTime() requireMilestones public constant returns (uint) {
        return milestones[0].time;
    }

    // UNIX timestamp when crowdsale is on
    function getEndTime() requireMilestones public constant returns (uint) {
        var lastMilestone = milestones[milestones.length-1];
        return lastMilestone.time;
    }


    function hasStarted() requireMilestones public constant returns (bool) {
        return getNow() >= milestones[1].time;
    }

    function hasEnded() requireMilestones public constant returns (bool) {
        return getNow() >= milestones[milestones.length-1].time;
    }

    /**
     * Get the current milestone.
     *
     * Returns (0, 0) milestone if we are before the start.
     * Returns last milestone if we are after the end.
     *
     * @return {[type]} [description]
     */
    function getCurrentMilestone() private constant returns (Milestone) {
        uint now = getNow();
        uint i;

        for(i=milestones.length-1; i>0; i--) {
            if(now >= milestones[i].time) {
                return milestones[i];
            }
        }
    }

    /**
     * Get the current price.
     *
     * @return The current price or 0 if we are outside milestone period
     */
    function getPrice() public requireMilestones constant returns (uint result) {
        return getCurrentMilestone().price;
    }

    // Bail out unless milestones have been set
    modifier requireMilestones() {
        if(!milestonesSealed) {
            throw;
        }

        _;
    }

}