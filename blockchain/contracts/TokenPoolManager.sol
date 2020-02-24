pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "./BondingCurveToken.sol";


/**
 * @title Token Bonding Curve
 * @dev Token backed Bonding curve contract
 */
contract ERC20BondingToken is Initializable, BondingCurveToken {

  /* Reserve Token */
  ERC20 public reserveToken;

  /* The TCR contract address */
  address public investmentPool;

  /* Exit Tribute is a tax applied on token sellers TODO: how to calc */
  uint256 public exitTribute = 1 wei;

  /* Pool split amount TODO: how to calc */
  uint8 public poolSplit = 3;

  function initialize(
      ERC20 _reserveToken,
      uint256 _initialPoolBalance,
      uint256 _initialSupply,
      uint32 _reserveRatio,
      uint256 _gasPrice,
      address _investmentPool)
      public
      initializer
  {
    reserveToken = _reserveToken;
    investmentPool = _investmentPool;

    require(reserveToken.transferFrom(
        msg.sender,
        address(this),
        _initialPoolBalance),
        "ERC20BondingToken: Failed to transfer tokens for intial pool.");

    BondingCurveToken.initialize(_initialSupply, _reserveRatio, _gasPrice);
  }

  /**
  * @dev Returns the current reserve token balance of the reserve Pool
  */
  function reservePoolBalance() public view returns(uint256) {
    return reserveToken.balanceOf(address(this));
  }

  /**
  * @dev Returns the current reserve token balance of the investment Pool
  */
  function investmentPoolBalance() public view returns(uint256) {
    return reserveToken.balanceOf(investmentPool);
  }

  /**
  * @dev Returns the pool split for a given token amount
  * for amounts below 1 reserve token, splitting isn't worth the gas.
  * since the reserve token has 18 decimals, I'm using the idiomatic 'ether' keyword (i.e: 1e18)
  * @param _amount The amount of reserve tokens received in a purchase
  */
  function _calculatePoolSplit(uint256 _amount)
    internal
    view
    returns(uint256 reserveAmt, uint256 investmentAmt)
  {
    if (_amount < 1 ether) return (_amount, 0);

    // reserveAmt = _amount.div(poolSplit);
    // investmentAmt = _amount.sub(reserveAmt);
    reserveAmt = _amount / poolSplit;
    investmentAmt = _amount - reserveAmt;
  }
}