// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Importing necessary OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Fridge
 * @dev ERC1155-based token contract for tokenized prepaid goods using USDT.
 * Merchants can register, set product details, and users can purchase & redeem tokens.
 */
contract Fridge is ERC1155, Ownable {
    using SafeMath for uint256;

    // ERC20 token used for payment (USDT in this case)
    IERC20 public usdtToken;

    // Mapping of token ID to product details
    mapping(uint256 => string) public tokenNames; // Product names
    mapping(uint256 => uint256) public tokenPrices; // Product prices in KES
    mapping(uint256 => uint256) public tokenStock; // Available stock per product

    // Mapping of approved shops (merchants) allowed to redeem tokens
    mapping(address => bool) public approvedShops;

    // Backend admin address allowed to manage merchant approvals
    address public backendAdmin;

    // Event emitted when tokens are purchased (prepaid goods)
    event TokensPurchased(address indexed buyer, uint256 tokenId, uint256 quantity, uint256 totalCost);

    // Event emitted when tokens are redeemed at a merchant
    event GoodsRedeemed(
        address indexed user, address indexed shop, uint256 tokenId, uint256 quantity, uint256 totalCost
    );

    /**
     * @dev Constructor to initialize the contract.
     * @param _usdtToken Address of the ERC20 USDT token contract.
     */
    constructor(address _usdtToken) ERC1155("ipfs://<YOUR_IPFS_CID>/") Ownable() {
        usdtToken = IERC20(_usdtToken);
    }

    /**
     * @dev Set the backend administrator address for merchant approvals.
     * @param _backendAdmin Address of the backend admin.
     */
    function setBackendAdmin(address _backendAdmin) external onlyOwner {
        backendAdmin = _backendAdmin;
    }

    /**
     * @dev Adds or updates product details (Only accessible by approved merchants or backend admin).
     * @param tokenId Unique identifier for the product.
     * @param productName Name of the product.
     * @param price Price of the product in KES.
     * @param stock Available stock quantity.
     */
    function setProductDetails(uint256 tokenId, string memory productName, uint256 price, uint256 stock) external {
        require(approvedShops[msg.sender] || msg.sender == backendAdmin, "Not authorized to set product details.");
        tokenNames[tokenId] = productName;
        tokenPrices[tokenId] = price;
        tokenStock[tokenId] = stock;
    }

    /**
     * @dev Approves or removes shops (merchants) for token redemption.
     * @param shop Address of the shop.
     * @param approved Boolean flag to approve (true) or remove (false) the shop.
     */
    function setShopApproval(address shop, bool approved) external {
        require(msg.sender == owner() || msg.sender == backendAdmin, "Not authorized to approve shops.");
        approvedShops[shop] = approved;
    }

    /**
     * @dev Allows users to purchase tokens (prepay for goods) using USDT.
     * @param tokenId ID of the product to purchase.
     * @param quantity Number of tokens to buy.
     */
    function purchaseTokens(uint256 tokenId, uint256 quantity) external {
        require(tokenPrices[tokenId] > 0, "Product does not exist.");
        require(tokenStock[tokenId] >= quantity, "Not enough stock available.");

        uint256 totalPrice = tokenPrices[tokenId].mul(quantity);
        require(usdtToken.transferFrom(msg.sender, address(this), totalPrice), "USDT transfer failed.");

        tokenStock[tokenId] = tokenStock[tokenId].sub(quantity);
        _mint(msg.sender, tokenId, quantity, "");
        emit TokensPurchased(msg.sender, tokenId, quantity, totalPrice);
    }

    /**
     * @dev Allows users to redeem their tokens at an approved shop.
     * @param tokenId ID of the token to redeem.
     * @param quantity Amount of tokens to redeem.
     * @param shop Address of the approved shop.
     */
    function redeemTokens(uint256 tokenId, uint256 quantity, address shop) external {
        require(balanceOf(msg.sender, tokenId) >= quantity, "Insufficient tokens to redeem.");
        require(approvedShops[shop], "Shop is not approved for redemption.");

        uint256 totalCost = tokenPrices[tokenId].mul(quantity);
        _burn(msg.sender, tokenId, quantity);
        require(usdtToken.transfer(shop, totalCost), "USDT transfer to shop failed.");
        emit GoodsRedeemed(msg.sender, shop, tokenId, quantity, totalCost);
    }

    /**
     * @dev Returns product details by token ID.
     * @param tokenId ID of the product.
     * @return productName Name of the product.
     * @return price Price of the product in KES.
     * @return stock Available stock of the product.
     */
    function getProductDetails(uint256 tokenId) external view returns (string memory, uint256, uint256) {
        return (tokenNames[tokenId], tokenPrices[tokenId], tokenStock[tokenId]);
    }

    /**
     * @dev Allows merchants to mint new tokens with an IPFS URI for metadata.
     * @param tokenId ID of the token to mint.
     * @param quantity Number of tokens to mint.
     * @param ipfsUri IPFS URI containing metadata.
     */
    function mintProduct(uint256 tokenId, uint256 quantity, string memory ipfsUri) external {
        require(approvedShops[msg.sender] || msg.sender == backendAdmin, "Not authorized to mint products.");
        _mint(msg.sender, tokenId, quantity, ipfsUri);
    }

    /**
     * @dev Returns the URI for token metadata, using IPFS.
     * @param tokenId ID of the token.
     * @return IPFS URI string.
     */
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked("ipfs://<YOUR_IPFS_CID>/", uint2str(tokenId), ".json"));
    }

    /**
     * @dev Helper function to convert uint256 to string.
     * @param _i Integer value.
     * @return str String representation of the integer.
     */
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
