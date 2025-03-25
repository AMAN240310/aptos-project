# SimpleAMM - Automated Market Maker on Aptos

## Description
SimpleAMM is a basic implementation of an Automated Market Maker (AMM) protocol built using the Move programming language for the Aptos blockchain. This contract provides core functionality for creating a liquidity pool and performing token swaps using the constant product formula (x * y = k).

## Vision
The vision of SimpleAMM is to demonstrate a minimal yet functional AMM concept on Aptos, serving as an educational example for developers learning Move and DeFi concepts. It aims to provide a clear, concise starting point for understanding decentralized exchange mechanics while maintaining simplicity within 40-50 lines of code.

## Future Scope
- Add support for proper dual-token pairs (beyond simplified u64 amounts)
- Implement liquidity provision and withdrawal functions
- Include trading fees for liquidity providers
- Add safety checks and error handling
- Implement events for better tracking of pool activities
- Support multiple pool instances
- Add price oracle functionality

## Contract Details
### Module
- **Name**: `MyModule::SimpleAMM`
- **Dependencies**: 
  - `aptos_framework::signer`
  - `aptos_framework::coin`
  - `aptos_framework::aptos_coin::AptosCoin`

### Structs
- **`Pool`**
  - `token_x_reserve: u64` - Reserve of token X (AptosCoin)
  - `token_y_reserve: u64` - Reserve of token Y (simplified as u64)
  - `k: u64` - Constant product (x * y = k)
  - Capabilities: `key, store`

### Functions
1. **`create_pool`**
   - **Signature**: `public entry fun create_pool(owner: &signer, initial_x: u64, initial_y: u64)`
   - **Description**: Initializes a new liquidity pool with initial reserves of tokens X and Y
   - **Parameters**:
     - `owner`: Pool creator's signer
     - `initial_x`: Initial amount of token X
     - `initial_y`: Initial amount of token Y

2. **`swap_x_to_y`**
   - **Signature**: `public entry fun swap_x_to_y(trader: &signer, pool_owner: address, x_amount_in: u64)`
   - **Description**: Swaps token X for token Y using constant product formula
   - **Parameters**:
     - `trader`: Trader's signer
     - `pool_owner`: Address of pool owner
     - `x_amount_in`: Amount of token X to swap
   - **Modifies**: `Pool` (requires `acquires Pool`)

### Notes
- Current implementation uses AptosCoin as token X and a simplified u64 for token Y
- Token Y output is calculated but not transferred (uses assertion instead)
- Designed as a minimal example rather than production-ready code
