pragma solidity ^0.4.25;

import "./math/SafeMath.sol";
import "./ownership/Ownable.sol";
import "./token/TRC20/ITRC20.sol";

/**
 * @title TokenTimelock
 * @dev TokenTimelock is a token holder contract that will allow a
 * beneficiary to extract the tokens after a given release time.
 */
contract TokenTimelock is Ownable {
    using SafeMath for uint256;
    event Released(string message);

    // TRC20 basic token contract being held
    ITRC20 private _token;

    // beneficiary of tokens after they are released
    address private _beneficiary;

    // timestamp when token release is enabled
    uint256 private _startTime;
    uint256 private _period;
    uint256 private _count;

    uint256[] private _calendar;

    constructor (ITRC20 token, address beneficiary, uint256 startTime, uint256 period, uint256 count) public {
        // solhint-disable-next-line not-rely-on-time
        require(startTime > block.timestamp, "TokenTimelock: release time is before current time");
        _token = token;
        _beneficiary = beneficiary;
        _startTime = startTime;
        _period = period;
        _count = count;

        for (uint256 i = count; i > 0; i--) {
            _calendar.push(startTime + i * period);
        }
    }

    /**
     * @return the token being held.
     */
    function token() public view returns (ITRC20) {
        return _token;
    }

    /**
     * @return the beneficiary of the tokens.
     */
    function beneficiary() public view returns (address) {
        return _beneficiary;
    }

    /**
     * @return the time when the tokens are released.
     */
    function startTime() public view returns (uint256) {
        return _startTime;
    }

    /**
     * @return vesting periods list.
     */
    function calendar() public view returns (uint256[] memory) {
        return _calendar;
    }

    /**
     * @return current time
     */
    function getBlockTimestamp() public view returns (uint256) {
      return block.timestamp;
    }

    /**
     * @notice Transfers tokens held by timelock to beneficiary.
     */
    function release() public onlyOwner {
        // solhint-disable-next-line not-rely-on-time
        require(block.timestamp >= _startTime, "TokenTimelock: current time is before release time");

        uint256 amount = _token.balanceOf(address(this));
        require(amount > 0, "TokenTimelock: no tokens to release");

        if (_calendar.length == 0 || block.timestamp > _calendar[0]) {
            _token.transfer(_beneficiary, amount);
            _calendar.length = 0;
        } else {
            uint256 i = 0;
            while (block.timestamp > _calendar[_calendar.length - 1]) {
                i++;
                _calendar.length--;
            }

            require(i > 0, "TokenTimelock: no period(s) to release");

            _token.transfer(_beneficiary, amount.mul(i).div(_count));
            _count = _calendar.length;
        }
    }
}
