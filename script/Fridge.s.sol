// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Fridge.sol";
import "../test/mocks/MockUSDT.sol";

contract FridgeScript is Script {
    Fridge public fridge;
    MockUSDT public usdtToken;

    function run() public {
        vm.startBroadcast();

        // Deploy the MockUSDT contract with an initial supply (1M USDT with 6 decimals)
        usdtToken = new MockUSDT();

        // Define the base URI and initial owner for the Fridge contract
        string memory baseURI = "https://example.com/api/item/";
        address initialOwner = address(this); // or any other address you want to be the owner

        // Deploy the Fridge contract with the MockUSDT address, base URI, and initial owner
        fridge = new Fridge(address(usdtToken), baseURI, initialOwner);

        // Set product details
        fridge.setProductDetails(1, "Product 1", 100, 10);

        vm.stopBroadcast();
    }
}
