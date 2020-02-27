pragma solidity ^0.5.0;
/**
 * Standard ERC20 token
 * with Bancor Bonding Curve lib
 */
import "./utils/SafeMath.sol";
import "./interfaces/IBancorFormula.sol";

contract MyERC20Token {
    using SafeMath for uint256;

    bytes32 public constant name = "ElecraSeedBCToken";
    bytes32 public constant symbol = "esBCT";
    uint256 public constant decimals = 8;
    address public constant BANCOR_LIBRARY = address(0x00); //point to previously deployed version to save gas

    uint256 public tokenSupply; //how many tokens are in circulation
    uint256 public poolBalance; //how much eth does the contract have
    uint32 public reserveRatio; //in ppm, this is the backing in eth for totalSupply
    uint256 public gasPrice; // maximum gas price for bancor transactions
    address public owner;

    mapping(address => uint256) public Balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Mint(address indexed _who, uint256 _tokenAmount, uint256 _ethAmount);
    event Burn(address indexed _who, uint256 _tokenAmount, uint256 _ethAmount);

    constructor(
        address _owner,
        uint32 _reserveRatio,
        uint256 _initialSupply,
        uint256 _gasPrice)
        public
        payable
    {
        owner = _owner;
        poolBalance = msg.value;
        reserveRatio = _reserveRatio;
        tokenSupply = _initialSupply;
        gasPrice = _gasPrice;

        emit Mint(msg.sender, _initialSupply, msg.value);
    }

    function totalSupply() external view returns (uint256 currentSupply) {
        return tokenSupply;
    }

    function balanceOf(address _who) external view returns (uint256 balance) {
        return Balances[_who];
    }

    function transfer(address _to, uint256 _value) external returns (bool ok) {
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool ok) {
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool ok) {
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function buy() public payable {
        //mint _amount of tokens for x price
        //validate msg.value is x price
        uint tokenAmt = _calculatePurchaseReturn(msg.value);

        Balances[msg.sender] = Balances[msg.sender].add(tokenAmt);
        poolBalance = poolBalance.add(msg.value);
        tokenSupply = tokenSupply.add(tokenAmt);

        emit Mint(msg.sender, tokenAmt, msg.value);
    }
    function sell(uint256 _saleAmt) public {
        //burn _amount of tokens
        //pay x eth to customer
        uint ethReturn = _calculateSaleReturn(_saleAmt);

        Balances[msg.sender] = Balances[msg.sender].sub(_saleAmt);
        tokenSupply = tokenSupply.sub(_saleAmt);
        poolBalance = poolBalance.sub(ethReturn);
        msg.sender.transfer(ethReturn); //review this bc of new reentrancy risks

        emit Burn(msg.sender, _saleAmt, ethReturn);
    }

    function _calculatePurchaseReturn(uint256 _purchaseAmt) internal view returns (uint256 cost) {
        IBancorFormula bancor = IBancorFormula(BANCOR_LIBRARY);
        cost = bancor.calculatePurchaseReturn(tokenSupply, poolBalance, reserveRatio, _purchaseAmt);
    }

    function _calculateSaleReturn(uint256 _saleAmt) internal view returns (uint256 profit) {
        IBancorFormula bancor = IBancorFormula(BANCOR_LIBRARY);
        profit = bancor.calculateSaleReturn(tokenSupply, poolBalance, reserveRatio, _saleAmt);

    }

}

/**
Bonding Curve Stuff here
//wrappers for calcPurchReturn and calcSaleReturn
    function calculatePurchaseReturn(
        uint256 _supply, //tokenSupply
        uint256 _connectorBalance, //poolBalance
        uint32 _connectorWeight, //reserveRatio
        uint256 _depositAmount)
        public view returns (uint256);

    function calculateSaleReturn(
        uint256 _supply, //tokenSupply
        uint256 _connectorBalance, //poolBalance
        uint32 _connectorWeight, //reserveRatio
        uint256 _sellAmount)
        public view returns (uint256);
*/
