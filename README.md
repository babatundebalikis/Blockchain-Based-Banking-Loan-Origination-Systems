# Blockchain-Based Banking Loan Origination System

A comprehensive smart contract system built on Stacks blockchain using Clarity language for managing the complete loan origination lifecycle in banking institutions.

## 🏗️ System Architecture

This system consists of five interconnected smart contracts that handle different aspects of the loan origination process:

### 1. Lender Verification Contract (`lender-verification.clar`)
- **Purpose**: Validates and manages lending institutions
- **Key Features**:
    - Lender application and verification process
    - Capital requirement validation (minimum 1M)
    - License number tracking
    - Active/inactive status management
    - Authorization controls

### 2. Application Processing Contract (`application-processing.clar`)
- **Purpose**: Processes loan applications from borrowers
- **Key Features**:
    - Loan application submission
    - Basic validation (amount limits, income verification)
    - Application status tracking
    - Borrower application history
    - Integration with lender verification

### 3. Credit Assessment Contract (`credit-assessment.clar`)
- **Purpose**: Evaluates borrower creditworthiness
- **Key Features**:
    - Credit score management (300-850 range)
    - Debt-to-income ratio calculation
    - Payment history scoring
    - Employment stability assessment
    - Automated risk level determination (low/medium/high)

### 4. Underwriting Automation Contract (`underwriting-automation.clar`)
- **Purpose**: Automates loan underwriting decisions
- **Key Features**:
    - Automated decision making based on predefined criteria
    - Interest rate calculation based on credit score
    - Loan term determination
    - Conditional approval handling
    - Configurable underwriting parameters

### 5. Servicing Management Contract (`servicing-management.clar`)
- **Purpose**: Manages loan servicing and payments
- **Key Features**:
    - Loan origination and activation
    - Payment processing and tracking
    - Principal and interest calculation
    - Payment history maintenance
    - Loan status management

## 🚀 Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd blockchain-loan-system
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## 📋 Usage Examples

### 1. Lender Verification Process

\`\`\`clarity
;; Apply for lender verification
(contract-call? .lender-verification apply-for-verification "LICENSE123" u2000000)

;; Verify a lender (admin only)
(contract-call? .lender-verification verify-lender 'SP1234...)

;; Check if lender is verified
(contract-call? .lender-verification is-verified-lender 'SP1234...)
\`\`\`

### 2. Loan Application Workflow

\`\`\`clarity
;; Submit loan application
(contract-call? .application-processing submit-application
'SP-LENDER...
u500000
"Home Purchase"
"Full-time"
u75000)

;; Create credit assessment
(contract-call? .credit-assessment create-credit-assessment
'SP-BORROWER...
u720
u35
u85
u90)

;; Process underwriting
(contract-call? .underwriting-automation process-underwriting u1)
\`\`\`

### 3. Loan Servicing

\`\`\`clarity
;; Originate approved loan
(contract-call? .servicing-management originate-loan
'SP-BORROWER...
'SP-LENDER...
u500000
u525
u360)

;; Make monthly payment
(contract-call? .servicing-management make-payment u1 u2500)
\`\`\`

## 🔧 Configuration

### Underwriting Criteria
The system uses configurable criteria for automated underwriting:
- Minimum credit score: 650
- Maximum debt-to-income ratio: 40%
- Minimum income multiplier: 3x loan amount
- Maximum loan amount: $5,000,000
- Base interest rate: 5.00%

### Risk Assessment Parameters
- **Low Risk**: Credit score ≥750, Debt ratio ≤30%, Payment score ≥80%
- **Medium Risk**: Credit score ≥650, Debt ratio ≤50%, Payment score ≥60%
- **High Risk**: Below medium risk thresholds

## 🧪 Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
# Run all tests
npm test

# Run specific test file
npm test -- lender-verification.test.js

# Run tests in watch mode
npm run test:watch
\`\`\`

## 📊 Contract Interactions

### Data Flow
1. **Lender Registration** → Lender Verification Contract
2. **Loan Application** → Application Processing Contract
3. **Credit Check** → Credit Assessment Contract
4. **Underwriting** → Underwriting Automation Contract
5. **Loan Servicing** → Servicing Management Contract

### Key Integrations
- Application Processing validates lender verification status
- Underwriting Automation requires credit assessment data
- Servicing Management originates loans from approved applications

## 🔒 Security Features

- **Access Control**: Role-based permissions for different contract functions
- **Input Validation**: Comprehensive validation of all user inputs
- **State Management**: Proper state transitions and consistency checks
- **Error Handling**: Detailed error codes and messages
- **Audit Trail**: Complete transaction and payment history

## 📈 Scalability Considerations

- **Modular Design**: Separate contracts for different concerns
- **Upgradeable Parameters**: Configurable criteria and limits
- **Efficient Storage**: Optimized data structures for gas efficiency
- **Batch Operations**: Support for processing multiple applications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For questions and support:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🔄 Version History

- **v1.0.0**: Initial release with core loan origination functionality
- **v1.1.0**: Enhanced credit assessment and risk calculation
- **v1.2.0**: Improved servicing management and payment processing

---

**Note**: This is a demonstration system. For production use, additional security audits, regulatory compliance checks, and integration with external credit bureaus would be required.
\`\`\`

