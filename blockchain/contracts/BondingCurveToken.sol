pragma solidity ^0.5.0;

import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";

import "./Bancor/BancorFormula.sol";

/**
 * @title Bonding Curve
 * @dev Bonding curve contract based on the Bacor formula
 * inspired by bancor protocol and simondlr and Slava Balasanov and Tarrence van As
 * https://github.com/bancorprotocol/contracts
 * https://github.com/ConsenSys/curationmarkets/blob/master/CurationMarkets.sol
 * https://github.com/relevant-community/bonding-curve/
 * https://github.com/tarrencev/curve-bonded-tokens/
 */
contract BondingCurveToken is Initializable, ERC20Detailed, ERC20Mintable, ERC20Burnable, BancorFormula {
  /*
    reserve ratio, represented in ppm, 1-1000000
    1/3 corresponds to y= multiple * x^2
    1/2 corresponds to y= multiple * x
    2/3 corresponds to y= multiple * x^1/2
    multiple will depends on contract initialization,
    specificallytotalAmount and poolBalance parameters
    we might want to add an 'initialize' function that will allow
    the owner to send ether to the contract and mint a given amount of tokens
  */
  uint32 public reserveRatio;

  /*
    - Front-running attacks are currently mitigated by the following mechanisms:
    TODO - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
    - gas price limit prevents users from having control over the order of execution
  */
  uint256 public gasPrice = 0 wei; // maximum gas price for bancor transactions

  /** verifies that the gas price is lower than the universal limit */
  modifier validGasPrice() {
    assert(tx.gasprice <= gasPrice);
    _;
  }

  event CurvedMint(address indexed _sender, uint256 _amount, uint256 _deposit);
  event CurvedBurn(address indexed _sender, uint256 _amount, uint256 _reimbursement);

  /**
   * @dev Abstract method that returns pool balance
   */
  function reservePoolBalance() public view returns (uint256);

  function initialize(
    uint256 _initialSupply,
    uint32 _reserveRatio,
    uint256 _gasPrice)
    public
    initializer
  {
    reserveRatio = _reserveRatio;
    gasPrice = _gasPrice;

    _mint(msg.sender, _initialSupply);
  }

  function calculateCurvedMintReturn(uint256 _amount) public view returns (uint256) {
    return calculatePurchaseReturn(totalSupply(), reservePoolBalance(), reserveRatio, _amount);
  }

  function calculateCurvedBurnReturn(uint256 _amount) public view returns (uint256) {
    return calculateSaleReturn(totalSupply(), reservePoolBalance(), reserveRatio, _amount);
  }

  /**
   * @dev Mint tokens
   */
  function _curvedMint(uint256 _deposit) internal returns (uint256) {
    return _curvedMintFor(msg.sender, _deposit);
  }

  function _curvedMintFor(
    address _user,
    uint256 _deposit)
    internal
    validGasPrice
    returns (uint256)
  {
    uint256 amount = calculateCurvedMintReturn(_deposit);
    _mint(_user, amount);

    emit CurvedMint(_user, amount, _deposit);
    return amount;
  }

  /**
   * @dev Burn tokens
   * @param _amount Amount of tokens to withdraw
   */
  function _curvedBurn(uint256 _amount) internal returns (uint256) {
    return _curvedBurnFor(msg.sender, _amount);
  }

  function _curvedBurnFor(
    address _user,
    uint256 _amount)
    internal
    validGasPrice
    returns (uint256)
  {
    uint256 reimbursement = calculateCurvedBurnReturn(_amount);
    _burn(_user, _amount);

    emit CurvedBurn(_user, _amount, reimbursement);
    return reimbursement;
  }

}