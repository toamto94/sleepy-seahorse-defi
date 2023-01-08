// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface iERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface iCurve3Pool {
  event TokenExchange(address indexed buyer, int128 sold_id, uint256 tokens_sold, int128 bought_id, uint256 tokens_bought);
  event TokenExchangeUnderlying(address indexed buyer, int128 sold_id, uint256 tokens_sold, int128 bought_id, uint256 tokens_bought);
  event AddLiquidity(address indexed provider, uint256[3] token_amounts, uint256[3] fees, uint256 invariant, uint256 token_supply);
  event RemoveLiquidity(address indexed provider, uint256[3] token_amounts, uint256[3] fees, uint256 token_supply);
  event RemoveLiquidityOne(address indexed provider, uint256 token_amount, uint256 coin_amount);
  event RemoveLiquidityImbalance(address indexed provider, uint256[3] token_amounts, uint256[3] fees, uint256 invariant, uint256 token_supply);
  event CommitNewAdmin(uint256 indexed deadline, address indexed admin);
  event NewAdmin(address indexed admin);
  event CommitNewFee(uint256 indexed deadline, uint256 fee, uint256 admin_fee, uint256 offpeg_fee_multiplier);
  event NewFee(uint256 fee, uint256 admin_fee, uint256 offpeg_fee_multiplier);
  event RampA(uint256 old_A, uint256 new_A, uint256 initial_time, uint256 future_time);
  event StopRampA(uint256 A, uint256 t);
  function A() external view returns(uint256);
  function A_precise() external view returns(uint256);
  function dynamic_fee(int128 i, int128 j) external view returns(uint256);
  function balances(uint256 i) external view returns(uint256);
  function get_virtual_price() external view returns(uint256);
  function calc_token_amount(uint256[3] calldata _amounts, bool is_deposit) external view returns(uint256);
  function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount) external returns(uint256);
  function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount, bool _use_underlying) external returns(uint256);
  function get_dy(int128 i, int128 j, uint256 dx) external view returns(uint256);
  function get_dy_underlying(int128 i, int128 j, uint256 dx) external view returns(uint256);
  function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns(uint256);
  function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns(uint256);
  function remove_liquidity(uint256 _amount, uint256[3] calldata _min_amounts) external returns(uint256[3] calldata);
  function remove_liquidity(uint256 _amount, uint256[3] calldata _min_amounts, bool _use_underlying) external returns(uint256[3] calldata);
  function remove_liquidity_imbalance(uint256[3] calldata _amounts, uint256 _max_burn_amount) external returns(uint256);
  function remove_liquidity_imbalance(uint256[3] calldata _amounts, uint256 _max_burn_amount, bool _use_underlying) external returns(uint256);
  function calc_withdraw_one_coin(uint256 _token_amount, int128 i) external view returns(uint256);
  function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external returns(uint256);
  function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount, bool _use_underlying) external returns(uint256);
  function ramp_A(uint256 _future_A, uint256 _future_time) external;
  function stop_ramp_A() external;
  function commit_new_fee(uint256 new_fee, uint256 new_admin_fee, uint256 new_offpeg_fee_multiplier) external;
  function apply_new_fee() external;
  function revert_new_parameters() external;
  function commit_transfer_ownership(address _owner) external;
  function apply_transfer_ownership() external;
  function revert_transfer_ownership() external;
  function withdraw_admin_fees() external;
  function donate_admin_fees() external;
  function kill_me() external;
  function unkill_me() external;
  function set_aave_referral(uint256 referral_code) external;
  function set_reward_receiver(address _reward_receiver) external;
  function set_admin_fee_receiver(address _admin_fee_receiver) external;
  function coins(uint256 arg0) external view returns(address);
  function underlying_coins(uint256 arg0) external view returns(address);
  function admin_balances(uint256 arg0) external view returns(uint256);
  function fee() external view returns(uint256);
  function offpeg_fee_multiplier() external view returns(uint256);
  function admin_fee() external view returns(uint256);
  function owner() external view returns(address);
  function lp_token() external view returns(address);
  function initial_A() external view returns(uint256);
  function future_A() external view returns(uint256);
  function initial_A_time() external view returns(uint256);
  function future_A_time() external view returns(uint256);
  function admin_actions_deadline() external view returns(uint256);
  function transfer_ownership_deadline() external view returns(uint256);
  function future_fee() external view returns(uint256);
  function future_admin_fee() external view returns(uint256);
  function future_offpeg_fee_multiplier() external view returns(uint256);
  function future_owner() external view returns(address);
  function reward_receiver() external view returns(address);
  function admin_fee_receiver() external view returns(address);
}

interface iTEURUSDPool {
  event TokenExchange(address indexed buyer, uint256 sold_id, uint256 tokens_sold, uint256 bought_id, uint256 tokens_bought);
  event AddLiquidity(address indexed provider, uint256[2] token_amounts, uint256 fee, uint256 token_supply);
  event RemoveLiquidity(address indexed provider, uint256[2] token_amounts, uint256 token_supply);
  event RemoveLiquidityOne(address indexed provider, uint256 token_amount, uint256 coin_index, uint256 coin_amount);
  event CommitNewAdmin(uint256 indexed deadline, address indexed admin);
  event NewAdmin(address indexed admin);
  event CommitNewParameters(uint256 indexed deadline, uint256 admin_fee, uint256 mid_fee, uint256 out_fee, uint256 fee_gamma, uint256 allowed_extra_profit, uint256 adjustment_step, uint256 ma_half_time);
  event NewParameters(uint256 admin_fee, uint256 mid_fee, uint256 out_fee, uint256 fee_gamma, uint256 allowed_extra_profit, uint256 adjustment_step, uint256 ma_half_time);
  event RampAgamma(uint256 initial_A, uint256 future_A, uint256 initial_gamma, uint256 future_gamma, uint256 initial_time, uint256 future_time);
  event StopRampA(uint256 current_A, uint256 current_gamma, uint256 time);
  event ClaimAdminFee(address indexed admin, uint256 tokens);
  function token() external view returns(address);
  function coins(uint256 i) external view returns(address);
  function A() external view returns(uint256);
  function gamma() external view returns(uint256);
  function fee() external view returns(uint256);
  function get_virtual_price() external view returns(uint256);
  function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external returns(uint256);
  function get_dy(uint256 i, uint256 j, uint256 dx) external view returns(uint256);
  function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external returns(uint256);
  function remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts) external;
  function calc_token_amount(uint256[2] calldata amounts) external view returns(uint256);
  function calc_withdraw_one_coin(uint256 token_amount, uint256 i) external view returns(uint256);
  function remove_liquidity_one_coin(uint256 token_amount, uint256 i, uint256 min_amount) external returns(uint256);
  function claim_admin_fees() external;
  function ramp_A_gamma(uint256 future_A, uint256 future_gamma, uint256 future_time) external;
  function stop_ramp_A_gamma() external;
  function commit_new_parameters(uint256 _new_mid_fee, uint256 _new_out_fee, uint256 _new_admin_fee, uint256 _new_fee_gamma, uint256 _new_allowed_extra_profit, uint256 _new_adjustment_step, uint256 _new_ma_half_time) external;
  function apply_new_parameters() external;
  function revert_new_parameters() external;
  function commit_transfer_ownership(address _owner) external;
  function apply_transfer_ownership() external;
  function revert_transfer_ownership() external;
  function kill_me() external;
  function unkill_me() external;
  function set_admin_fee_receiver(address _admin_fee_receiver) external;
  function price_scale() external view returns(uint256);
  function price_oracle() external view returns(uint256);
  function last_prices() external view returns(uint256);
  function last_prices_timestamp() external view returns(uint256);
  function initial_A_gamma() external view returns(uint256);
  function future_A_gamma() external view returns(uint256);
  function initial_A_gamma_time() external view returns(uint256);
  function future_A_gamma_time() external view returns(uint256);
  function allowed_extra_profit() external view returns(uint256);
  function future_allowed_extra_profit() external view returns(uint256);
  function fee_gamma() external view returns(uint256);
  function future_fee_gamma() external view returns(uint256);
  function adjustment_step() external view returns(uint256);
  function future_adjustment_step() external view returns(uint256);
  function ma_half_time() external view returns(uint256);
  function future_ma_half_time() external view returns(uint256);
  function mid_fee() external view returns(uint256);
  function out_fee() external view returns(uint256);
  function admin_fee() external view returns(uint256);
  function future_mid_fee() external view returns(uint256);
  function future_out_fee() external view returns(uint256);
  function future_admin_fee() external view returns(uint256);
  function balances(uint256 arg0) external view returns(uint256);
  function D() external view returns(uint256);
  function owner() external view returns(address);
  function future_owner() external view returns(address);
  function xcp_profit() external view returns(uint256);
  function xcp_profit_a() external view returns(uint256);
  function virtual_price() external view returns(uint256);
  function is_killed() external view returns(bool);
  function kill_deadline() external view returns(uint256);
  function transfer_ownership_deadline() external view returns(uint256);
  function admin_actions_deadline() external view returns(uint256);
  function admin_fee_receiver() external view returns(address);
}



interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


