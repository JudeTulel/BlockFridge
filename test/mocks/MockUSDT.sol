// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDT is ERC20 {
    constructor() ERC20("Mock USDT", "USDT") {
        // Mint initial supply to deployer
        _mint(msg.sender, 1000000 * 10 ** 6); // 1M USDT with 6 decimals
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
