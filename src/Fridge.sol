// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Importing the ERC1155 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Fridge is ERC1155, Ownable {
    using SafeMath for uint256;

    // USDT token address (Make sure to set this correctly to the USDT contract address on the respective network)
    IERC20 public usdtToken;

    // Token metadata - could store various products, prices, and inventory details
    mapping(uint256 => string) public tokenNames; // Maps token ID to product name
    mapping(uint256 => uint256) public tokenPrices; // Maps token ID to product price in KES (Kenyan Shillings)
    mapping(uint256 => uint256) public tokenStock; // Maps token ID to available stock of the product
    
    // Mapping of shops (merchants) approved to redeem tokens
    mapping(address => bool) public approvedShops;
    
    // Event to log the purchase of tokens
    event TokensPurchased(address indexed buyer, uint256 tokenId, uint256 quantity, uint256 totalCost);
    
    // Event to log when a store or merchant receives prepaid goods
    event GoodsRedeemed(address indexed user, address indexed shop, uint256 tokenId, uint256 quantity, uint256 totalCost);
    
    // Constructor to initialize the contract with basic URI and USDT token address
    constructor(address _usdtToken) ERC1155("https://api.fridgekenya.com/tokens") Ownable(msg.sender) {
        usdtToken = IERC20(_usdtToken); // Set the USDT token address
    }

    // Function to add or update product details (e.g., for a store manager)
    function setProductDetails(
        uint256 tokenId,
        string memory productName,
        uint256 price,
        uint256 stock
    ) external onlyOwner {
        tokenNames[tokenId] = productName;
        tokenPrices[tokenId] = price;
        tokenStock[tokenId] = stock;
    }

    // Function to register or remove shops (merchants)
    function setShopApproval(address shop, bool approved) external onlyOwner {
        approvedShops[shop] = approved;
    }

    // Function to purchase tokens (prepay for goods) using USDT
    function purchaseTokens(uint256 tokenId, uint256 quantity) external {
        require(tokenPrices[tokenId] > 0, "Product does not exist.");
        require(tokenStock[tokenId] >= quantity, "Not enough stock available.");
        
        uint256 totalPrice = tokenPrices[tokenId].mul(quantity);
        
        // Transfer USDT from the buyer to the contract (escrow)
        require(usdtToken.transferFrom(msg.sender, address(this), totalPrice), "USDT transfer failed.");
        
        // Decrease stock
        tokenStock[tokenId] = tokenStock[tokenId].sub(quantity);
        
        // Mint the tokens to the buyer
        _mint(msg.sender, tokenId, quantity, "");

        // Emit purchase event
        emit TokensPurchased(msg.sender, tokenId, quantity, totalPrice);
    }

    // Function for a user to redeem their tokens at a partner shop (merchant)
    function redeemTokens(uint256 tokenId, uint256 quantity, address shop) external {
        require(balanceOf(msg.sender, tokenId) >= quantity, "Insufficient tokens to redeem.");
        require(approvedShops[shop], "Shop is not approved for redemption.");
        
        uint256 totalCost = tokenPrices[tokenId].mul(quantity);
        
        // Burn the redeemed tokens
        _burn(msg.sender, tokenId, quantity);

        // Transfer the USDT from contract to shop (escrow release)
        require(usdtToken.transfer(shop, totalCost), "USDT transfer to shop failed.");

        // Emit redeem event
        emit GoodsRedeemed(msg.sender, shop, tokenId, quantity, totalCost);
    }

    // Function to check product details by token ID
    function getProductDetails(uint256 tokenId) external view returns (string memory, uint256, uint256) {
        return (tokenNames[tokenId], tokenPrices[tokenId], tokenStock[tokenId]);
    }

    // Function to withdraw USDT balance from the contract (only owner can withdraw funds)
    function withdrawUSDT() external onlyOwner {
        uint256 balance = usdtToken.balanceOf(address(this));
        require(balance > 0, "No USDT available to withdraw.");
        usdtToken.transfer(owner(), balance);
    }

    // Override the uri function to return dynamic token metadata (optional)
    function uri(uint256 tokenId) public pure override returns (string memory) {
        return string(abi.encodePacked("https://api.fridgekenya.com/tokens/", uint2str(tokenId), ".json"));
    }

    // Helper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }
}
