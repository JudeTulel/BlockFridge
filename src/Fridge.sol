// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Fridge is ERC1155, Ownable {
    IERC20 public usdt;
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

    constructor(address _usdt, string memory _baseURI, address initialOwner) ERC1155(_baseURI) Ownable(initialOwner) {
        usdt = IERC20(_usdt);
        baseURI = _baseURI;
    }

    function setBaseURI(string memory _newBaseURI) external {
        require(msg.sender == owner() || msg.sender == backendAdmin, "Not authorized to update URI");
        baseURI = _newBaseURI;
        emit BaseURIUpdated(_newBaseURI);
    }

    function purchaseTokens(uint256 tokenId, uint256 quantity) external {
        require(tokenPrices[tokenId] > 0, "Product does not exist");
        require(tokenStock[tokenId] >= quantity, "Not enough stock available");

        uint256 totalPrice = tokenPrices[tokenId] * quantity;
        require(usdt.transferFrom(msg.sender, address(this), totalPrice), "USDT transfer failed");

        tokenStock[tokenId] = tokenStock[tokenId] - quantity;
        _mint(msg.sender, tokenId, quantity, "");

        emit TokensPurchased(msg.sender, tokenId, quantity, totalPrice);
    }

    function redeemTokens(uint256 tokenId, uint256 quantity, address shop) external {
        require(balanceOf(msg.sender, tokenId) >= quantity, "Insufficient tokens to redeem");
        require(approvedShops[shop], "Shop is not approved for redemption");

        uint256 totalCost = tokenPrices[tokenId] * quantity;
        _burn(msg.sender, tokenId, quantity);

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
