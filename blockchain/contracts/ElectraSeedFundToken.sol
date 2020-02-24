pragma solidity ^0.5.0;

import "./TokenPoolManager.sol";

/**
* @title ElectraSeed Fund Token
* @dev ESF Token is an ERC20 fungible token with a bonding curve price function that
* uses an ERC20 based stable coin as its reserve
*/
contract ElectraSeedFundToken is ERC20BondingToken {

  address public owner; //temp for development purposes only

  function initialize(
      ERC20 _reserveToken,
      uint256 _initialPoolBalance,
      uint256 _initialSupply,
      uint32 _reserveRatio,
      uint256 _gasPrice,
      address _investmentPool,
      string memory _name,
      string memory _symbol,
      uint8 _decimals)
      public
      initializer
  {

    ERC20BondingToken.initialize(
        _reserveToken,
        _initialPoolBalance,
        _initialSupply,
        _reserveRatio,
        _gasPrice,
        _investmentPool);

    ERC20Detailed.initialize(
        _name,
        _symbol,
        _decimals
    );

  }

  /**
  * @dev Allows patrons to purchase ESF tokens by depositing an amount of reserve tokens
  * @param _amount The amount of reserve tokens to deposit
  */
  function buy(uint256 _amount) external {
    require(_amount > 0, "Failed: Amount must be greater than zero.");
    require(reserveToken.transferFrom(
        msg.sender,
        address(this),
        _amount),
        "ERC20BondingToken: Failed to transfer tokens for mint.");

    _curvedMint(_amount);
  }

  /**
  * @dev Allows token holders to sell their ESF holdings and collect a reimbursement
  * @param _amount The amount of ESF tokens to burn
  */
  function sell(uint256 _amount) external {
    require(_amount > 0, "Failed: Amount must be greater than zero.");
    require(balanceOf(msg.sender) >= _amount,
      "ERC20BondingToken: Insuficient funds for sale amount.");

    uint256 reimbursement = _curvedBurn(_amount);

    require(reserveToken.transfer(msg.sender, reimbursement),
        "ERC20BondingToken: Failed to transfer tokens for burn.");
  }

  /**
  * @dev Allows tokens holders to donate their own holdings without collecting
  * a reimbursement, ie sponsored burning
  * @param _amount The amount of ESF tokens to burn
  */
  function donate(uint256 _amount) external {
    require(_amount > 0, "Failed: Amount must be greater than zero.");
    require(balanceOf(msg.sender) >= _amount,
      "Failed: Insuficient funds for donation amount.");

    _curvedBurn(_amount);
  }

  /**
  * @dev Allows depositing reserve tokens directly in the reserve pool without minting new tokens.
  * A use case would be the recurring payments energy asset operators will make to ElectraSeed Fund
  * @param _amount The amount of reserve tokens to deposit in the reserve pool
  */
  function refund(uint256 _amount) external {
    require(_amount > 0, "Failed: Amount must be greater than zero.");
    require(reserveToken.transferFrom(
        msg.sender,
        address(this),
        _amount),
        "ERC20BondingToken: Failed to transfer tokens for refund.");
  }


//temp admin functions for development purposes
  /**
  * @dev Allows the owner to update the gas price limit
  * @param _gasPrice The new gas price
  */
  function setGasPrice(uint256 _gasPrice) external {
    require(msg.sender == owner, "This is an admin function");

    gasPrice = _gasPrice;
  }

  /**
  * @dev Allows the owner to update the exit tribute
  * @param _amount The new value for exit tax calculation
  */
  function setExitTribute(uint256 _amount) external {
    require(msg.sender == owner, "This is an admin function");

    exitTribute = _amount;
  }

  /**
  * @dev Allows the owner to update the reserve / investment token pool split amount
  * @param _amount The new value for exit tax calculation
  */
  function setPoolSplit(uint8 _amount) external {
    require(msg.sender == owner, "This is an admin function");

    poolSplit = _amount;
  }

  /**
  * @dev Allows the owner to update the reserve token
  * @param _token The new reserve token contract address
  */
  function setReserveToken(ERC20 _token) external {
    require(msg.sender == owner, "This is an admin function");

    reserveToken = _token;
  }

  /**
  * @dev Allows the owner to update the TCR contract address that serves
  * as the investment pool wallet
  * @param _newPool The new investment pool address
  */
  function setInvestmentPool(address _newPool) external {
    require(msg.sender == owner, "This is an admin function");

    investmentPool = _newPool;
  }

  /**
  * @dev Allows the owner to collect any wei sent to this contract
  */
  function dustCollector() external {
    require(msg.sender == owner, "This is an admin function");

    msg.sender.transfer(address(this).balance);
  }


}