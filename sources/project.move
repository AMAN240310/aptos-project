module MyModule::SimpleAMM {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing an AMM liquidity pool
    struct Pool has key, store {
        token_x_reserve: u64,  // Reserve of token X (using AptosCoin as example)
        token_y_reserve: u64,  // Reserve of token Y (simplified as u64 amount)
        k: u64                // Constant product (x * y = k)
    }

    /// Creates a new liquidity pool with initial reserves
    public entry fun create_pool(
        owner: &signer,
        initial_x: u64,
        initial_y: u64
    ) {
        // Withdraw initial liquidity from owner
        let x_coins = coin::withdraw<AptosCoin>(owner, initial_x);
        
        // Create pool with initial reserves
        let pool = Pool {
            token_x_reserve: initial_x,
            token_y_reserve: initial_y,
            k: initial_x * initial_y
        };
        
        // Store the pool under owner's address
        move_to(owner, pool);
        
        // Deposit initial X tokens to pool owner (simplified)
        coin::deposit<AptosCoin>(signer::address_of(owner), x_coins);
    }

    /// Swap tokens using constant product formula (x * y = k)
    public entry fun swap_x_to_y(
        trader: &signer,
        pool_owner: address,
        x_amount_in: u64
    ) acquires Pool {
        let pool = borrow_global_mut<Pool>(pool_owner);
        
        // Calculate output amount using constant product formula
        let new_x = pool.token_x_reserve + x_amount_in;
        let new_y = pool.k / new_x;
        let y_amount_out = pool.token_y_reserve - new_y;
        
        // Transfer input tokens from trader to pool
        let x_coins = coin::withdraw<AptosCoin>(trader, x_amount_in);
        coin::deposit<AptosCoin>(pool_owner, x_coins);
        
        // Update pool reserves
        pool.token_x_reserve = new_x;
        pool.token_y_reserve = new_y;

        // In a real implementation, we'd transfer y_amount_out to trader
        // Here we'll just assert it for simplicity (since we only have one coin type)
        assert!(y_amount_out > 0, 1);
    }
}