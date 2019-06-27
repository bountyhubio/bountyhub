
// File: ~contracts/math/SafeMath.sol

pragma solidity ^0.4.23;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: ~contracts/token/TRC20/ITRC20.sol

pragma solidity ^0.4.23;

/**
 * @title TRC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface ITRC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: ~contracts/token/TRC20/TRC20.sol

pragma solidity ^0.4.23;



/**
 * @title Standard TRC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://eips.ethereum.org/EIPS/eip-20
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
contract TRC20 is ITRC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
     * @dev Total number of tokens in existence.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner The address to query the balance of.
     * @return A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
     * @dev Transfer token to a specified address.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Transfer token for a specified addresses.
     * @param from The address to transfer from.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "TRC20: transfer to the zero address");

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0), "TRC20: mint to the zero address");

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "TRC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Approve an address to spend another addresses' tokens.
     * @param owner The address that owns the tokens.
     * @param spender The address that will spend the tokens.
     * @param value The number of tokens that can be spent.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "TRC20: approve from the zero address");
        require(spender != address(0), "TRC20: approve to the zero address");

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}

// File: ~contracts/access/Roles.sol

pragma solidity ^0.4.23;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: ~contracts/access/roles/MinterRole.sol

pragma solidity ^0.4.23;


contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

// File: ~contracts/token/TRC20/TRC20Mintable.sol

pragma solidity ^0.4.23;



/**
 * @title TRC20Mintable
 * @dev TRC20 minting logic.
 */
contract TRC20Mintable is TRC20, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public onlyMinter returns (bool) {
        _mint(to, value);
        return true;
    }
}

// File: ~contracts/token/TRC20/TRC20Capped.sol

pragma solidity ^0.4.23;


/**
 * @title Capped token
 * @dev Mintable token with a token cap.
 */
contract TRC20Capped is TRC20Mintable {
    uint256 private _cap;

    constructor (uint256 cap) public {
        require(cap > 0, "TRC20Capped: cap is 0");
        _cap = cap;
    }

    /**
     * @return the cap for the token minting.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap, "TRC20Capped: cap exceeded");
        super._mint(account, value);
    }
}

// File: ~contracts/token/TRC20/TRC20Detailed.sol

pragma solidity ^0.4.23;


/**
 * @title TRC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract TRC20Detailed is ITRC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @return the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: ~contracts/ownership/Ownable.sol

pragma solidity ^0.4.23;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: ~contracts/BountyHUBToken.sol

pragma solidity ^0.4.23;




interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, bytes _extraData) external;
}

/**
 * @title SimpleToken
 * @dev Very simple TRC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 */
contract BountyHUBToken is TRC20Capped, TRC20Detailed, Ownable {
  string constant private NAME = "BountyHUBToken";
  string constant private SYMBOL = "BHT";
  uint8 constant private DECIMALS = 18;
  uint256 constant private CAP = 1000000000 * (10 ** uint256(DECIMALS));
  
  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  constructor () public
      TRC20Detailed(NAME, SYMBOL, DECIMALS)
      TRC20Capped(CAP) {
  }
}

// File: ~contracts/TokenTimelock.sol

pragma solidity ^0.4.23;




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
    uint256 private _startTime = 0;
    uint256 private _period;
    uint256 private _count;

    uint256[] private _calendar;

    constructor (ITRC20 token, address beneficiary, uint256 period, uint256 count) public {
        // solhint-disable-next-line not-rely-on-time
        _token = token;
        _beneficiary = beneficiary;
        _period = period;
        _count = count;
    }

    /**
     * Start the token vesting
     * @param startTime uint256 the cliff time of the token vesting
     */
    function startOn(uint256 startTime) public onlyOwner {
        // solhint-disable-next-line not-rely-on-time
        require(startTime > block.timestamp, "TokenTimelock: release time is before current time");
        _startTime = startTime;

        for (uint256 i = _count; i > 0; i--) {
            _calendar.push(_startTime + i * _period);
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
        require(_startTime > 0, "TokenTimelock: not started yet");
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

// File: ~contracts/Configurator.sol

pragma solidity ^0.4.23;




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
