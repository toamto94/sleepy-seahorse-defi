import './interfaces.sol';

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract bauch {

  event Response(bool success, bytes data);
  address constant WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
  address constant USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
  address constant DAI = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
  address constant USDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
  address constant CURVE_3POOL = 0x445FE580eF8d70FF569aB36e80c647af338db351;
  address constant UniswapV2Router02 = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
  address constant CURVE_3POOL_LP = 0xE7a24EF0C5e95Ffb0f6684b813A78F2a3AD7D171;
  address constant CURVE_USDR3POOL = 0xa138341185a9D0429B0021A11FB717B225e13e1F;
  address constant RUSD = 0xb5DFABd7fF7F83BAB83995E72A52B97ABb7bcf63;

  uint256 public deposit;
  mapping(address => uint256) user_deposit;

  constructor() {

  }

  //modifiers
  modifier check_token_approval(address _token_address, address _token_sender, address _token_receiver, uint256 _amount) {
      require(iERC20(_token_address).allowance(_token_sender, _token_receiver) >= _amount,
      "ERC20 contract has not given permission to this address.");
      _;
  }

  //send ERC20 token to this contract
  function transfer_token_to_contract(address _token_in, uint256 _amount) public {
          iERC20(_token_in).transferFrom(msg.sender, address(this), _amount);
      }


  function add_user_deposit(uint256 _amount) external {
    iERC20(USDC).transferFrom(msg.sender, address(this), _amount);
    iERC20(USDC).approve(CURVE_3POOL, _amount);
    uint256[3] memory _amount_3pool;
    _amount_3pool[0] = 0;
    _amount_3pool[1] = _amount;
    _amount_3pool[2] = 0;
    uint256 liquidity_amount = iCurve3Pool(CURVE_3POOL).add_liquidity(_amount_3pool, 1, true);
    iCurve3PoolLp(CURVE_3POOL_LP).approve(CURVE_USDR3POOL, liquidity_amount);
    uint256 rusd_amount = iCurveUSDR3Pool(CURVE_USDR3POOL).exchange(1, 0, liquidity_amount / 2, 1);
    uint256[2] memory _amounts_RUSD3Pool;
    _amounts_RUSD3Pool[0] = rusd_amount;
    _amounts_RUSD3Pool[1] = liquidity_amount / 2;
    iERC20(RUSD).approve(CURVE_USDR3POOL, rusd_amount);
    user_deposit[msg.sender] += iCurveUSDR3Pool(CURVE_USDR3POOL).add_liquidity(_amounts_RUSD3Pool, 1);
  }

  function withdraw_user_deposit(uint256 _amount) external {
    iCurveUSDR3Pool(CURVE_USDR3POOL).approve(CURVE_USDR3POOL, _amount);
    uint256 curve_3pool_amount = iCurveUSDR3Pool(CURVE_USDR3POOL).remove_liquidity_one_coin(_amount, 1, 1);
    iCurve3PoolLp(CURVE_3POOL_LP).approve(CURVE_3POOL, curve_3pool_amount);
    //uint256 withdraw_amount = iCurve3Pool(CURVE_3POOL).remove_liquidity_one_coin(curve_3pool_amount, 2, 1);





  }

    //developer function to get WMATIC to an address for testing reasons
    function receive_wmatic() external payable {
            (bool success, bytes memory data) = WMATIC.call{value: msg.value}(abi.encodeWithSignature(""));
            iERC20(WMATIC).transferFrom(address(this), msg.sender, msg.value);
            emit Response(success, data);
        }


    //swap exact tokens for tokens
    function swap_exact_tokens_for_tokens(uint256 _amount_in, uint256 _amount_out_min, address _token_in,
        address _token_out, uint256 deadline) external {
        transfer_token_to_contract(_token_in, _amount_in);
        address[] memory path = new address[](2);
        path[0] = _token_in;
        path[1] = _token_out;
        iERC20(_token_in).approve(UniswapV2Router02, _amount_in);     
        IUniswapV2Router02(UniswapV2Router02).swapExactTokensForTokens(
          _amount_in,
          _amount_out_min,
          path,
          msg.sender,
          deadline);
    }


}
