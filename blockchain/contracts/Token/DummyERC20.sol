pragma solidity ^0.5.0;


import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Mintable.sol";


contract EurERC20 is Ownable, ERC20Detailed, ERC20Mintable {
    constructor(uint256 _initialSupply) public {
        ERC20Detailed.initialize("EuroToken", "EUR", 18);
        _mint(msg.sender, _initialSupply);
    }

    function faucet(uint256 _amount) public {
        _mint(msg.sender, _amount);
    }
}
