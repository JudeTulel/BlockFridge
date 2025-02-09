// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Fridge.sol";
import "./mocks/MockUSDT.sol";

contract FridgeTest is Test {
    Fridge public fridge;
    MockUSDT public mockUsdt;
    address public owner;
    address public shop;
    address public user;

    function setUp() public {
        owner = address(this);
        shop = address(0x1);
        user = address(0x2);

        // Deploy mock USDT
        mockUsdt = new MockUSDT();

        // Deploy Fridge contract
        fridge = new Fridge(address(mockUsdt), "https://azure-vm.com/api/tokens/");

        // Setup test environment
        mockUsdt.mint(user, 1000 * 10 ** 6); // Give user 1000 USDT
        mockUsdt.mint(shop, 100 * 10 ** 6); // Give shop 100 USDT

        // Approve shop
        fridge.setShopApproval(shop, true);
    }

    function testPurchaseTokens() public {
        // Set up product (10 USDT price)
        fridge.setProductDetails(1, "Test Product", 10 * 10 ** 6, 10);

        // Approve USDT spending
        vm.startPrank(user);
        mockUsdt.approve(address(fridge), 10 * 10 ** 6);

        // Purchase tokens as user
        fridge.purchaseTokens(1, 1);
        vm.stopPrank();

        // Assert
        assertEq(fridge.balanceOf(user, 1), 1);
    }

    function testRedeemTokens() public {
        // First purchase a token
        fridge.setProductDetails(1, "Test Product", 10 * 10 ** 6, 10);

        vm.startPrank(user);
        mockUsdt.approve(address(fridge), 10 * 10 ** 6);
        fridge.purchaseTokens(1, 1);

        // Then redeem it
        fridge.redeemTokens(1, 1, shop);
        vm.stopPrank();

        // Assert
        assertEq(fridge.balanceOf(user, 1), 0);
        assertEq(mockUsdt.balanceOf(shop), 110 * 10 ** 6); // Original 100 + 10 from redemption
    }

    function testFailPurchaseWithoutApproval() public {
        fridge.setProductDetails(1, "Test Product", 10 * 10 ** 6, 10);

        vm.prank(user);
        fridge.purchaseTokens(1, 1); // Should fail because no USDT approval
    }

    function testFailPurchaseInsufficientStock() public {
        fridge.setProductDetails(1, "Test Product", 10 * 10 ** 6, 1);

        vm.startPrank(user);
        mockUsdt.approve(address(fridge), 20 * 10 ** 6);
        fridge.purchaseTokens(1, 2); // Should fail because only 1 in stock
        vm.stopPrank();
    }
}
