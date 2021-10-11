// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EcioSpace is ERC20, ERC20Burnable, Ownable {

    uint256 private constant TOTAL_SUPPLY = 7000 * 10**(6 + 18); // 7000M tokens

    constructor() ERC20("ECIO Space", "ECIO") {}

    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= TOTAL_SUPPLY , "The token amount exceeded the total supply.");
        _mint(to, amount);
    }
}