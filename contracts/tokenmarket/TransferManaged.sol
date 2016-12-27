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
  * An interface to check if a transfer can clear
  */
 contract TransferClearer {

    function canTransfer(address source, address destination) constant returns (bool);
 }