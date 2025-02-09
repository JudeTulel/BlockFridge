// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Fridge.sol";
import "../mocks/MockUSDT.sol";

contract FridgeScript is Script {
    Fridge public fridge;
    MockUSDT public usdtToken;

    function run() public {
        vm.startBroadcast();

        // Deploy the MockUSDT contract with an initial supply
        usdtToken = new MockUSDT(1000000 * 10^18); // 1,000,000 USDT with 18 decimals

        // Deploy the Fridge contract with the MockUSDT address
        fridge = new Fridge(address(usdtToken));

        // Set product details
        fridge.setProductDetails(1, "Product 1", 100, 10);

        vm.stopBroadcast();
    }
}
