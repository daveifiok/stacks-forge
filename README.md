# StacksForge Protocol

## Next-Generation Bitcoin Yield Optimization

[![Stacks](https://img.shields.io/badge/Stacks-Layer%202-purple)](https://stacks.co)
[![Clarity](https://img.shields.io/badge/Smart%20Contract-Clarity-blue)](https://clarity-lang.org)
[![sBTC](https://img.shields.io/badge/Powered%20by-sBTC-orange)](https://sbtc.tech)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

StacksForge is a revolutionary DeFi infrastructure that unlocks the earning potential of idle Bitcoin through sophisticated algorithmic yield strategies, seamless sBTC integration, and autonomous reward optimization. Built on Stacks Layer 2, it delivers consistent returns while maintaining full asset custody and transparent risk management across all market conditions.

### Key Features

- 🚀 **Dynamic Yield Optimization**: Adaptive reward rates with algorithmic efficiency
- 🔒 **Secure Asset Custody**: Non-custodial architecture with full user control
- ⚡ **Automated Compounding**: Intelligent position management and yield harvesting
- 📊 **Real-time Analytics**: Comprehensive protocol metrics and performance tracking
- 🏛️ **Decentralized Governance**: Community-driven parameter management
- 💎 **sBTC Integration**: Seamless Bitcoin Layer 2 yield generation

## Architecture

StacksForge leverages Stacks Layer 2 capabilities to create a robust yield generation ecosystem with the following components:

### Core Components

1. **Staking Engine**: Handles sBTC deposits and position management
2. **Reward Calculator**: Time-weighted yield computation with dynamic rates
3. **Treasury Management**: Sustainable reward distribution system
4. **Governance Module**: Decentralized protocol parameter control

### Smart Contract Structure

```clarity
;; Core Data Structures
stakes          : Map of user staking positions
rewards-claimed : Historical reward distribution ledger

;; Protocol Parameters
reward-rate      : Dynamic yield rate (basis points)
reward-pool      : Treasury reserves for distributions
min-stake-period : Security-focused minimum lock duration
total-staked     : Total Value Locked (TVL) tracking
```

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v1.5.0+
- [Node.js](https://nodejs.org/) v16.0.0+
- [Stacks CLI](https://github.com/hirosystems/stacks.js)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/daveifiok/stacks-forge.git
   cd stacks-forge
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Initialize Clarinet environment:**

   ```bash
   clarinet check
   ```

### Local Development

#### Run Contract Validation

```bash
# Validate contract syntax and logic
clarinet check

# Run comprehensive test suite
npm test

# Execute specific test file
clarinet test tests/stacks-forge.test.ts
```

#### Deploy to Local Devnet

```bash
# Start local blockchain
clarinet integrate

# Deploy contracts
clarinet deploy --devnet
```

## API Reference

### Core Functions

#### Staking Operations

**`stake(amount: uint)`**

- Deposits sBTC into yield-generating vaults
- Automatically compounds existing positions
- Updates protocol TVL metrics
- **Parameters**: `amount` - sBTC amount to stake
- **Returns**: `(response bool uint)`

**`unstake(amount: uint)`**

- Withdraws staked assets with automatic yield harvesting
- Enforces minimum staking period for security
- **Parameters**: `amount` - sBTC amount to withdraw
- **Returns**: `(response bool uint)`

**`claim-rewards()`**

- Harvests accumulated yields without unstaking principal
- Resets yield calculation baseline
- **Returns**: `(response bool uint)`

#### Read-Only Functions

**`get-stake-info(staker: principal)`**

- Retrieves comprehensive user staking position data
- **Returns**: `(optional {amount: uint, staked-at: uint})`

**`calculate-rewards(staker: principal)`**

- Advanced time-weighted reward calculation
- **Returns**: `uint` - Pending reward amount

**`get-protocol-stats()`**

- Comprehensive protocol health and performance metrics
- **Returns**: Protocol statistics tuple

### Governance Functions

**`set-reward-rate(new-rate: uint)`**

- Updates dynamic yield rate (owner only)
- **Parameters**: `new-rate` - New rate in basis points (max 1000)

**`set-min-stake-period(new-period: uint)`**

- Adjusts minimum staking duration (owner only)
- **Parameters**: `new-period` - New period in blocks

**`add-to-reward-pool(amount: uint)`**

- Funds treasury for sustainable reward distribution
- **Parameters**: `amount` - sBTC amount to add

## Testing

The protocol includes comprehensive test coverage for all critical functions:

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test suite
npm run test -- --testNamePattern="staking"
```

### Test Categories

- **Unit Tests**: Individual function validation
- **Integration Tests**: End-to-end workflow testing
- **Security Tests**: Attack vector and edge case validation
- **Gas Optimization**: Transaction cost analysis

## Deployment

### Mainnet Deployment

1. **Configure deployment settings:**

   ```toml
   # Clarinet.toml
   [network.mainnet]
   stacks_api = "https://stacks-node-api.mainnet.stacks.co"
   ```

2. **Deploy to mainnet:**

   ```bash
   clarinet deploy --network mainnet
   ```

### Network Configurations

- **Devnet**: Local development and testing
- **Testnet**: Pre-production validation
- **Mainnet**: Production deployment

## Security Considerations

### Security Features

- ✅ **Time-locked withdrawals**: Minimum staking period enforcement
- ✅ **Owner authorization**: Protected administrative functions
- ✅ **Treasury validation**: Reward pool sufficiency checks
- ✅ **Overflow protection**: Safe arithmetic operations
- ✅ **Reentrancy guards**: Secure state management

### Audit Status

- [ ] Internal security review
- [ ] External smart contract audit
- [ ] Formal verification (planned)

## Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u100 | `ERR_NOT_AUTHORIZED` | Unauthorized access attempt |
| u101 | `ERR_ZERO_STAKE` | Invalid zero amount operation |
| u102 | `ERR_NO_STAKE_FOUND` | No staking position exists |
| u103 | `ERR_TOO_EARLY_TO_UNSTAKE` | Minimum period not met |
| u104 | `ERR_INVALID_REWARD_RATE` | Rate exceeds maximum threshold |
| u105 | `ERR_NOT_ENOUGH_REWARDS` | Insufficient treasury funds |
| u106 | `ERR_INVALID_PERIOD` | Invalid time period parameter |
| u107 | `ERR_OWNER_UNCHANGED` | Owner already set to target |

## Economic Model

### Yield Generation

- **Base Rate**: 0.5% (500 basis points default)
- **Compounding**: Automatic on new stakes
- **Distribution**: Time-weighted calculation
- **Sustainability**: Treasury-backed rewards

### Fee Structure

- **Staking Fee**: 0% (gas only)
- **Unstaking Fee**: 0% (gas only)
- **Management Fee**: Built into reward rate
- **Performance Fee**: None (community-first approach)

## Roadmap

### Phase 1: Core Protocol ✅

- [x] Basic staking functionality
- [x] Reward calculation engine
- [x] Treasury management
- [x] Governance framework

### Phase 2: Advanced Features 🚧

- [ ] Multi-tier staking pools
- [ ] Automated strategy optimization
- [ ] Cross-chain yield aggregation
- [ ] Advanced analytics dashboard

### Phase 3: Ecosystem Expansion 📋

- [ ] Governance token launch
- [ ] Community proposals
- [ ] Partner integrations
- [ ] Mobile application

## Contributing

We welcome contributions from the community! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Implement changes with tests
4. Submit pull request with detailed description

### Code Standards

- Follow Clarity best practices
- Maintain test coverage >90%
- Include comprehensive documentation
- Optimize for gas efficiency

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
