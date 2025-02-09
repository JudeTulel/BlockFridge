// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Fridge
 * @dev ERC1155-based token contract for tokenized prepaid goods using USDT.
 * Modified to use Azure VM for token metadata.
 */
contract Fridge is ERC1155, Ownable {
    using SafeMath for uint256;

    // USDT contract interface
    IERC20 public usdt;

    // Azure VM base URL for token metadata
    string public baseURI;

    mapping(uint256 => string) public tokenNames;
    mapping(uint256 => uint256) public tokenPrices; // Prices in USDT (6 decimals)
    mapping(uint256 => uint256) public tokenStock;
    mapping(address => bool) public approvedShops;

    address public backendAdmin;

    event TokensPurchased(address indexed buyer, uint256 tokenId, uint256 quantity, uint256 totalCost);
    event GoodsRedeemed(
        address indexed user, address indexed shop, uint256 tokenId, uint256 quantity, uint256 totalCost
    );
    event BaseURIUpdated(string newBaseURI);

    /**
     * @dev Constructor initializes with USDT contract and Azure VM base URL
     * @param _usdt Address of the USDT contract on Lisk
     * @param _baseURI Base URL of the Azure VM endpoint
     */
    constructor(address _usdt, string memory _baseURI) ERC1155(_baseURI) {
        usdt = IERC20(_usdt);
        baseURI = _baseURI;
    }

    /**
     * @dev Updates the base URI for token metadata
     * @param _newBaseURI New base URI pointing to Azure VM
     */
    function setBaseURI(string memory _newBaseURI) external {
        require(msg.sender == owner() || msg.sender == backendAdmin, "Not authorized to update URI");
        baseURI = _newBaseURI;
        emit BaseURIUpdated(_newBaseURI);
    }

    /**
     * @dev Purchase tokens using USDT
     * @param tokenId ID of the token to purchase
     * @param quantity Number of tokens to buy
     */
    function purchaseTokens(uint256 tokenId, uint256 quantity) external {
        require(tokenPrices[tokenId] > 0, "Product does not exist");
        require(tokenStock[tokenId] >= quantity, "Not enough stock available");

        uint256 totalPrice = tokenPrices[tokenId].mul(quantity);

        // Transfer USDT from buyer to contract
        require(usdt.transferFrom(msg.sender, address(this), totalPrice), "USDT transfer failed");

        tokenStock[tokenId] = tokenStock[tokenId].sub(quantity);
        _mint(msg.sender, tokenId, quantity, "");

        emit TokensPurchased(msg.sender, tokenId, quantity, totalPrice);
    }

    /**
     * @dev Redeem tokens at an approved shop
     * @param tokenId ID of the token to redeem
     * @param quantity Amount of tokens to redeem
     * @param shop Address of the approved shop
     */
    function redeemTokens(uint256 tokenId, uint256 quantity, address shop) external {
        require(balanceOf(msg.sender, tokenId) >= quantity, "Insufficient tokens to redeem");
        require(approvedShops[shop], "Shop is not approved for redemption");

        uint256 totalCost = tokenPrices[tokenId].mul(quantity);
        _burn(msg.sender, tokenId, quantity);

        // Transfer USDT to shop
        require(usdt.transfer(shop, totalCost), "USDT transfer to shop failed");

        emit GoodsRedeemed(msg.sender, shop, tokenId, quantity, totalCost);
    }

    function setBackendAdmin(address _backendAdmin) external onlyOwner {
        backendAdmin = _backendAdmin;
    }

    function setProductDetails(uint256 tokenId, string memory productName, uint256 price, uint256 stock) external {
        require(approvedShops[msg.sender] || msg.sender == backendAdmin, "Not authorized to set product details");
        tokenNames[tokenId] = productName;
        tokenPrices[tokenId] = price;
        tokenStock[tokenId] = stock;
    }

    function setShopApproval(address shop, bool approved) external {
        require(msg.sender == owner() || msg.sender == backendAdmin, "Not authorized to approve shops");
        approvedShops[shop] = approved;
    }

    function mintProduct(uint256 tokenId, uint256 quantity) external {
        require(approvedShops[msg.sender] || msg.sender == backendAdmin, "Not authorized to mint products");
        _mint(msg.sender, tokenId, quantity, "");
    }

    function getProductDetails(uint256 tokenId) external view returns (string memory, uint256, uint256) {
        return (tokenNames[tokenId], tokenPrices[tokenId], tokenStock[tokenId]);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, uint2str(tokenId)));
    }

    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";
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
