# BlockFridge

BlockFridge is a blockchain-powered smart fridge concept that ensures seamless, secure, and conditional payment for goods. With BlockFridge, users prepay for goods, and the funds are only released when the goods are physically taken from participating shops. The platform leverages blockchain technology to ensure transparency, accountability, and a smooth shopping experience.

## Problem Statement

Traditional payment systems for goods often lack transparency, involve high transaction fees, and are prone to disputes. Customers have limited control over their spending once funds are transferred, and shop owners face challenges with fraud and reconciliation. Additionally, current systems do not provide a reliable way to manage prepayments for goods, leading to inefficiencies and trust issues between customers and shops.

## Project Description

BlockFridge addresses these challenges by introducing a blockchain-based platform that:

1. **Empowers Users**: Allows customers to prepay for goods using tokenized credits, ensuring funds are only released upon physical collection of the items.
2. **Enhances Trust**: Builds transparency and accountability into transactions, benefiting both customers and shop owners.
3. **Simplifies Payments**: Utilizes fungible tokens for categories of goods, reducing transaction fees and disputes.
4. **Streamlines Shop Operations**: Provides a QR code-based system for shops to validate and process transactions seamlessly.

By integrating blockchain technology with user-friendly features, BlockFridge creates a secure, efficient, and transparent system for prepaid goods management.

## Example User Workflow

### Redeeming Tokens at Participating Till Numbers

1. **Prepay for Goods**:
   - The user logs into the BlockFridge app and purchases tokenized credits for specific items (e.g., bread tokens, onion tokens).
   - The purchased tokens are stored securely in the user's blockchain wallet.

2. **Visit a Participating Shop**:
   - The user goes to a shop partnered with BlockFridge and selects the desired goods.

3. **Scan QR Code at the Till**:
   - At the till, the shop assistant generates a QR code representing the goods the user is purchasing.
   - The user opens the BlockFridge app, scans the QR code, and confirms the transaction.

4. **Validate and Deduct Tokens**:
   - The app verifies the transaction details and ensures the user has sufficient tokens.
   - The corresponding tokens (e.g., 2 bread tokens, 1 onion token) are deducted from the user's wallet.

5. **Confirm Goods Collection**:
   - Upon successful deduction, the app notifies both the user and the shop.
   - The shop assistant hands over the goods to the user.

6. **Transaction Record**:
   - The blockchain records the transaction, ensuring transparency and providing a receipt for both parties.

## Win-Win Situations for Participating Parties

### **For Users**:
1. **Control and Transparency**:
   - Users prepay for specific goods, ensuring clarity on what they are spending.
   - The blockchain provides a transparent and tamper-proof record of all transactions.

2. **Convenience**:
   - The app allows seamless transactions without the need for physical cash.
   - Real-time notifications confirm successful purchases and wallet balances.

3. **Budget Management**:
   - Tokenization of goods helps users allocate and limit spending to specific categories.

### **For Shop Owners**:
1. **Guaranteed Payments**:
   - Funds are securely transferred upon token redemption, reducing risks of fraud or non-payment.

2. **Simplified Operations**:
   - QR code-based transactions minimize errors and streamline the payment process.

3. **Increased Customer Trust**:
   - Transparent processes build trust with customers, encouraging repeat business.

4. **Access to Credit**:
   - Transaction data can be leveraged to offer microloans for restocking inventory.

### **For Suppliers**:
1. **Better Demand Insights**:
   - BlockFridge provides analytics on token usage, helping suppliers forecast demand and optimize stock levels.

2. **Efficient Payments**:
   - Suppliers can receive payment in tokens or fiat, enabling smooth B2B transactions.

### **For the Ecosystem**:
1. **Reduced Disputes**:
   - Blockchain ensures all parties have access to the same immutable transaction history.

2. **Enhanced Collaboration**:
   - A trusted, transparent system fosters partnerships between users, shopkeepers, and suppliers.

3. **Innovation and Growth**:
   - Features like loan access and demand analytics create opportunities for economic growth within the ecosystem.

## Feature Module: Shopkeeper Loan System

### Overview
The shopkeeper loan system enables shop owners to access microloans for restocking inventory. The loans are based on transaction data, demand insights, and repayment capacity. This module provides a seamless way for shopkeepers to obtain credit without requiring extensive paperwork or financial literacy.

### Workflow

1. **Demand Analysis**:
   - BlockFridge analyzes transaction data, including token redemption rates and item demand.
   - The system identifies shopkeepers with consistent activity and high-demand goods.

2. **Loan Prequalification**:
   - Based on transaction patterns, shopkeepers are prequalified for loans with a credit limit tied to their performance.

3. **Loan Request**:
   - Shopkeepers request loans via the BlockFridge app or USSD interface.
   - The system displays available loan amounts and repayment terms.

4. **Approval and Disbursement**:
   - The loan is approved automatically or after minimal review.
   - Funds are disbursed as tokens or fiat via partners like Kotani Pay.

5. **Repayment**:
   - Repayment is automated, with a percentage deducted from token redemptions.
   - Shopkeepers can view their loan balance and payment history in the app.

### Technical Specifications

1. **Data Analytics**:
   - Collect transaction data (e.g., token usage, redemption rates, item demand).
   - Use machine learning to identify patterns and assess creditworthiness.

2. **Loan Management System**:
   - Maintain a ledger of loan disbursements, repayments, and balances on-chain.
   - Smart contracts enforce loan terms, including interest rates and repayment schedules.

3. **User Interface**:
   - Provide a dashboard for loan requests, approvals, and repayment tracking.
   - Include notifications for loan eligibility, disbursement, and repayment reminders.

4. **Integration with Payment Systems**:
   - Partner with Kotani Pay or similar services for fiat disbursement and repayment.
   - Support both token-based and fiat-based repayment options.

5. **Risk Mitigation**:
   - Cap loan amounts based on shop performance metrics.
   - Implement penalties for late payments or defaults through smart contract logic.

### Benefits

- **For Shopkeepers**: Quick access to credit for restocking inventory, fostering business growth.
- **For BlockFridge**: Increased engagement and transaction volume on the platform.
- **For Suppliers**: Ensures shops can maintain stock levels to meet demand.

## Workflow: Using Kotani Pay for Fiat Onramping and Offramping

### Onramping: Converting Fiat to Tokens

1. **User Wallet Setup**:
   - The user downloads the BlockFridge app and sets up their blockchain wallet.

2. **Fiat Deposit**:
   - The user selects "Buy Tokens" in the app and enters the amount in their local currency.
   - The app redirects the user to Kotani Pay's fiat onramp interface.

3. **Payment Processing**:
   - The user completes the payment via mobile money, bank transfer, or supported local payment methods.
   - Kotani Pay processes the payment and transfers the equivalent amount of tokens to the user's wallet.

4. **Confirmation**:
   - The BlockFridge app notifies the user of the successful token purchase, displaying the updated wallet balance.

### Offramping: Converting Tokens to Fiat

1. **Token Redemption Request**:
   - The shopkeeper selects "Withdraw Earnings" in the BlockFridge app.
   - They specify the amount of tokens to convert to fiat.

2. **Verification and Processing**:
   - The app verifies the token balance and initiates the transaction via Kotani Pay's offramp API.
   - Tokens are deducted from the shopkeeper's wallet.

3. **Fiat Disbursement**:
   - Kotani Pay disburses the fiat equivalent to the shopkeeper's preferred method (mobile money, bank account, etc.).

4. **Transaction Record**:
   - The BlockFridge app updates the shopkeeper's transaction history and confirms the successful withdrawal.

### Technical Integration with Kotani Pay

1. **APIs Used**:
   - **Fiat Onramp API**: For users to convert fiat into tokens.
   - **Fiat Offramp API**: For shopkeepers to convert tokens into fiat.

2. **Authentication**:
   - Secure API keys and user authentication ensure safe and authorized transactions.

3. **Smart Contract Interaction**:
   - The BlockFridge smart contract verifies token balances and facilitates token transfers.

4. **Notification System**:
   - Real-time notifications inform users and shopkeepers about transaction statuses.

5. **Currency Conversion**:
   - Kotani Pay handles exchange rates to ensure accurate conversions between fiat and tokens.

### Benefits of Kotani Pay Integration

- **For Users**:
   - Simplified token purchases without needing prior crypto knowledge.
   - Multiple fiat payment options ensure accessibility.

- **For Shopkeepers**:
   - Seamless conversion of token earnings to fiat for restocking or operational needs.

- **For BlockFridge**:
   - Enhanced user adoption and trust by abstracting crypto complexities.

By integrating Kotani Pay, BlockFridge ensures a user-friendly, inclusive, and accessible ecosystem for all stakeholders.
