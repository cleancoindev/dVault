/**
 *Submitted for verification at Etherscan.io on 2020-07-26
*/

pragma solidity ^0.5.15;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface Controller {
    function withdraw(address, uint) external;
    function balanceOf(address) external view returns (uint);
    function earn(address, uint) external;
    function rewards() external view returns (address);
}


contract yVaultCRV is ERC20 {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;

  IERC20 public token;
  IERC20 public Yfiitoken;
  
  uint public min = 9500;
  uint public constant max = 10000;

  uint public earnLowerlimit = 1e18*10000; //池内空余资金到这个值就自动earn
  
  address public governance;
  address public controller;

    struct Player {
        uint256 stake; // 总质押总数
        uint256 payout; //
        uint256 total_out; // 已经领取的分红
    }
    mapping(address => Player) public plyr_; // (player => data) player data

    struct Global {
        uint256 total_stake; // 总质押总数
        uint256 total_out; //  总分红金额
        uint256 earnings_per_share; // 每股分红
    }
    mapping(uint256 => Global) public global_; // (global => data) global data
    mapping (address => uint256) public deposittime;
    uint256 constant internal magnitude = 10**40;

    address constant public yfii = address(0xa1d0E215a23d7030842FC67cE582a6aFa3CCaB83);




  constructor (address _controller,address _token) public {
      token = IERC20(_token);
      Yfiitoken = IERC20(yfii);
      governance = tx.origin;
      controller = _controller;
  }
  
  function balance() public view returns (uint) {
      return token.balanceOf(address(this))
             .add(Controller(controller).balanceOf(address(token)));
  }
  
  function setMin(uint _min) external {
      require(msg.sender == governance, "!governance");
      min = _min;
  }
  
  function setGovernance(address _governance) public {
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }
  
  function setController(address _controller) public {
      require(msg.sender == governance, "!governance");
      controller = _controller;
  }
  function setEarnLowerlimit(uint256 _earnLowerlimit) public{
      require(msg.sender == governance, "!governance");
      earnLowerlimit = _earnLowerlimit;
  }
  // Custom logic in here for how much the vault allows to be borrowed
  // Sets minimum required on-hand to keep small withdrawals cheap
  function available() public view returns (uint) {
      return token.balanceOf(address(this)).mul(min).div(max);
  }
  
  function earn() public {
      uint _bal = available();
      token.safeTransfer(controller, _bal);
      Controller(controller).earn(address(token), _bal);
  }

  function deposit(uint amount) external {
      token.safeTransferFrom(msg.sender, address(this), amount);
      plyr_[msg.sender].stake = plyr_[msg.sender].stake.add(amount);
        if (global_[0].earnings_per_share == 0) {
            plyr_[msg.sender].payout = plyr_[msg.sender].payout.add(0);
        } else {
            plyr_[msg.sender].payout = plyr_[msg.sender].payout.add(
                global_[0].earnings_per_share.mul(amount).sub(1).div(magnitude).add(1)
            );
        }
        global_[0].total_stake = global_[0].total_stake.add(amount);

      if (token.balanceOf(address(this))>earnLowerlimit){
          earn();
      }
      deposittime[msg.sender] = now;

      
  }

  // No rebalance implementation for lower fees and faster swaps
  function withdraw(uint amount) external {
      claim();
      require(amount<=plyr_[msg.sender].stake,"!balance");
      uint r = amount;

      // Check balance
      uint b = token.balanceOf(address(this));
      if (b < r) { 
          uint _withdraw = r.sub(b);
          Controller(controller).withdraw(address(token), _withdraw);
          uint _after = token.balanceOf(address(this));
          uint _diff = _after.sub(b);
          if (_diff < _withdraw) {
              r = b.add(_diff);
          }
      }

      plyr_[msg.sender].payout = plyr_[msg.sender].payout.sub(
            global_[0].earnings_per_share.mul(amount).div(magnitude)
      );
      plyr_[msg.sender].stake = plyr_[msg.sender].stake.sub(amount);
      global_[0].total_stake = global_[0].total_stake.sub(amount);

      token.safeTransfer(msg.sender, r);
  }

    function make_profit(uint256 amount) public { 
        require(amount>0,"not 0");
        Yfiitoken.safeTransferFrom(msg.sender, address(this), amount);
        global_[0].earnings_per_share = global_[0].earnings_per_share.add(
            amount.mul(magnitude).div(global_[0].total_stake)
        );
        global_[0].total_out = global_[0].total_out.add(amount);
    }
    function cal_out(address user) public view returns (uint256) { 
        uint256 _cal = global_[0].earnings_per_share.mul(plyr_[user].stake).div(magnitude);
        if (_cal < plyr_[user].payout) {
            return 0;
        } else {
            return _cal.sub(plyr_[user].payout);
        }
    }
    function claim() public { 
        uint256 out = cal_out(msg.sender);
        plyr_[msg.sender].payout = global_[0].earnings_per_share.mul(plyr_[msg.sender].stake).div(magnitude);
        plyr_[msg.sender].total_out = plyr_[msg.sender].total_out.add(out);

        if (out > 0) {
            uint256 _depositTime = now - deposittime[msg.sender];
            if (_depositTime < 1 days){ //deposit in 24h
                uint256 actually_out = _depositTime.mul(out).mul(1e18).div(1 days).div(1e18);
                uint256 to_team = out.sub(actually_out);
                Yfiitoken.safeTransfer(Controller(controller).rewards(), to_team);
                out = actually_out;
            }
            Yfiitoken.safeTransfer(msg.sender, out);
        }
    }
    function getName() external pure returns (string memory) {
        return "vaultCurve";
    }

}