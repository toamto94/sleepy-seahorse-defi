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


  function swap_to_stable_to_curve3(uint256 _amount) external {
    iERC20(USDC).transferFrom(msg.sender, address(this), _amount);
    uint256 fraction = _amount / 4;
    iERC20(USDC).approve(CURVE_3POOL, _amount); 
    iCurveFactory(CURVE_3POOL).exchange_underlying(1, 0, fraction, 1);
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
