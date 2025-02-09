# Technical Document: Azure Express Server for Merchant Approval and Token Creation

## **1. Introduction**

This document outlines the technical specifications and functionalities of used by BlockFridge to facilitate merchant approval and allow for approved mearchants to mint tokens creation using an Azure-hosted Express server. The system integrates with a smart contract on the Ethereum blockchain, enabling merchants to create tokens for prepayment and allowing a frontend application to approve merchants.

## **2. Technologies Used**

### **2.1 Azure**
- **Virtual Machine (VM)**: Hosts the Express server, providing a scalable and secure environment for running the backend services.
- **Azure Monitor**: Used for tracking the health and performance of the VM and Express server.

### **2.2 Node.js and Express**
- **Node.js**: A JavaScript runtime built on Chrome's V8 JavaScript engine, used for building scalable network applications.
- **Express**: A minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications.

### **2.3 Web3.js**
- **Web3.js**: A JavaScript library for interacting with the Ethereum blockchain. It allows the Express server to communicate with the smart contract, enabling functionalities like merchant approval and token creation.

### **2.4 Smart Contract**
- **Solidity**: The smart contract is written in Solidity, a statically-typed programming language designed for developing smart contracts on the Ethereum blockchain.
- **ERC-1155 Standard**: The smart contract implements the ERC-1155 standard, which allows for the creation of fungible and non-fungible tokens within the same contract.

### **2.5 Frontend**
- **React/Vue.js**: The frontend application is built using a modern JavaScript framework like React or Vue.js, providing a dynamic and responsive user interface.
- **Axios/Fetch API**: Used for making HTTP requests to the Express server from the frontend.

### **2.6 Security**
- **HTTPS**: Secure data transmission using SSL/TLS certificates obtained from Let's Encrypt.
- **Authentication**: Implemented to ensure that only authorized users can approve merchants or create tokens.

## **3. Smart Contract Functionalities**

### **3.1 Merchant Approval**
- **Function**: `setShopApproval(address shop, bool approved)`
  - Allows the contract owner or backend admin to approve or remove merchants.
  - **Access Control**: Only the contract owner or backend admin can call this function.
  - **Event**: Emits `GoodsRedeemed` event when a merchant is approved or removed.

### **3.2 Token Creation**
- **Function**: `mintProduct(uint256 tokenId, uint256 quantity)`
  - Allows approved merchants to create new tokens.
  - **Parameters**:
    - `tokenId`: Unique identifier for the token.
    - `quantity`: Number of tokens to mint.
  - **Access Control**: Only approved merchants or the backend admin can call this function.
  - **Metadata**: Token metadata is stored and served from the Azure VM, accessed through the `uri` function using the base URL set during contract deployment.
  - **Prerequisites**: Product details (name, price, stock) must be set using `setProductDetails` before minting.
  fo
### **3.3 Token Purchase**
- **Function**: `purchaseTokens(uint256 tokenId, uint256 quantity)`
  - Allows users to purchase tokens using USDT.
  - **Parameters**:
    - `tokenId`: ID of the product to purchase.
    - `quantity`: Number of tokens to buy.
  - **Event**: Emits `TokensPurchased` event when tokens are purchased.

### **3.4 Token Redemption**
- **Function**: `redeemTokens(uint256 tokenId, uint256 quantity, address shop)`
  - Allows users to redeem their tokens at an approved shop.
  - **Parameters**:
    - `tokenId`: ID of the token to redeem.
    - `quantity`: Amount of tokens to redeem.
    - `shop`: Address of the approved shop.
  - **Event**: Emits `GoodsRedeemed` event when tokens are redeemed.

### **3.5 Metadata Management**
- **Function**: `uri(uint256 tokenId)`
  - Returns the URI for token metadata, using a static IP address hosted on an Azure server.
  - **Dynamic URI**: Constructs the URI based on the token ID.

## **4. System Architecture**

### **4.1 Backend (Express Server)**
- **API Endpoints**:
  - **Merchant Approval**: Endpoint to approve merchants, interacting with the smart contract's `setShopApproval` function.
  - **Token Creation**: Endpoint for merchants to create tokens, calling the smart contract's `mintProduct` function.
- **Web3.js Integration**: The Express server uses Web3.js to interact with the smart contract, handling requests from the frontend application.

### **4.2 Frontend**
- **User Interface**: Provides forms and UI components for merchant approval and token creation.
- **HTTP Requests**: Communicates with the Express server using Axios or Fetch API to handle user interactions.

### **4.3 Security Measures**
- **HTTPS**: Ensures secure data transmission.
- **Authentication**: Ensures that only authorized users can perform sensitive actions.
- **Rate Limiting**: Prevents abuse of the API endpoints.

## **5. Conclusion**

This system leverages Azure's robust infrastructure, the flexibility of Node.js and Express, and the decentralized nature of the Ethereum blockchain to create a secure and efficient platform for merchant approval and token creation. The smart contract's functionalities, combined with a user-friendly frontend, provide a comprehensive solution for managing prepaid goods using blockchain technology.
