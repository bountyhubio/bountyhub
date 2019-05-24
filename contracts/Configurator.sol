pragma solidity ^0.4.25;

import "./math/SafeMath.sol";
import "./BountyHUBToken.sol";
import "./TokenTimelock.sol";

contract Configurator is Ownable {
    using SafeMath for uint256;

    BountyHUBToken private _token;

    // Token Distribution
    uint256 public platformLaunchPercentage       = 1;
    uint256 public marketingAndAirdropsPercentage = 4;
    uint256 public teamPercentage                 = 10;
    uint256 public foundationPercentage           = 15;
    uint256 public launchpadSalePercentage        = 17;
    uint256 public ecosystemPercentage            = 18;
    uint256 public platformRewardsPercentage      = 35;

    // Token timelocks
    TokenTimelock private _teamTimelock;
    TokenTimelock private _foundationTimelock;

    // Token funds
    address private _platformLaunchFund;
    address private _marketingAndAirdropsFund;
    address private _teamFund;
    address private _foundationFund;
    address private _launchpadSaleFund;
    address private _ecosystemFund;
    address private _platformRewardsFund;

    address private _manager;

    constructor(
      BountyHUBToken token,
      TokenTimelock teamTimelock,
      TokenTimelock foundationTimelock,
      address platformLaunchFund,
      address marketingAndAirdropsFund,
      address teamFund,
      address foundationFund,
      address launchpadSaleFund,
      address ecosystemFund,
      address platformRewardsFund,
      address manager
    ) public {
      _token = token;
      _teamTimelock = teamTimelock;
      _foundationTimelock = foundationTimelock;

      _platformLaunchFund = platformLaunchFund;
      _marketingAndAirdropsFund = marketingAndAirdropsFund;
      _teamFund = teamFund;
      _foundationFund = foundationFund;
      _launchpadSaleFund = launchpadSaleFund;
      _ecosystemFund = ecosystemFund;
      _platformRewardsFund = platformRewardsFund;

      _manager = manager;
    }

    function deploy() public onlyOwner {
      uint256 tokenCap = BountyHUBToken(_token).cap();

      _token.mint(address(_platformLaunchFund),       tokenCap.mul(platformLaunchPercentage).div(100));
      _token.mint(address(_marketingAndAirdropsFund), tokenCap.mul(marketingAndAirdropsPercentage).div(100));
      _token.mint(address(_teamTimelock),             tokenCap.mul(teamPercentage).div(100));
      _token.mint(address(_foundationTimelock),       tokenCap.mul(foundationPercentage).div(100));
      _token.mint(address(_launchpadSaleFund),        tokenCap.mul(launchpadSalePercentage).div(100));
      _token.mint(address(_ecosystemFund),            tokenCap.mul(ecosystemPercentage).div(100));
      _token.mint(address(_platformRewardsFund),      tokenCap.mul(platformRewardsPercentage).div(100));
    }

    function token() public view returns (ITRC20) {
        return _token;
    }

    function teamTimelock() public view returns (address) {
        return _teamTimelock;
    }

    function foundationTimelock() public view returns (address) {
        return _foundationTimelock;
    }

    function platformLaunchFund() public view returns (address) {
        return _platformLaunchFund;
    }

    function marketingAndAirdropsFund() public view returns (address) {
        return _marketingAndAirdropsFund;
    }

    function teamFund() public view returns (address) {
        return _teamFund;
    }

    function foundationFund() public view returns (address) {
        return _foundationFund;
    }

    function launchpadSaleFund() public view returns (address) {
        return _launchpadSaleFund;
    }

    function ecosystemFund() public view returns (address) {
        return _ecosystemFund;
    }

    function platformRewardsFund() public view returns (address) {
        return _platformRewardsFund;
    }

    function manager() public view returns (address) {
        return _manager;
    }
}
