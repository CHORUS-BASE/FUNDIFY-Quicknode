// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GovernanceToken is ERC20 {
    constructor() ERC20("Governance Token", "GT") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Minting initial supply of 1 million tokens
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
