import iERC20 from 'build/polygon-contracts/iERC20.json'
import iCurve3Pool from 'build/polygon-contracts/iCurve3Pool.json'
import iUniswapV2Router2 from 'build/polygon-contracts/IUniswapV2Router02.json'
import iCurve3PoolLP from 'build/polygon-contracts/iCurve3PoolLP.json'
import iCurveUSDR3Pool from 'build/polygon-contracts/iCurveUSDR3Pool.json'

(async () => {
  try {
    const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'build/polygon-contracts/bauch.json'))
    const accounts = await web3.eth.getAccounts()

    const getContract = async (contract_deployment_address, abi) => {
        return new web3.eth.Contract(abi,
            contract_deployment_address);
    };

    const wmatic_address = "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270"
    const dai_address = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"
    const router_address = "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff"
    const usdc_address = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174"
    const curve_3pool_address = "0x445FE580eF8d70FF569aB36e80c647af338db351"
    const usdt_address = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"
    const curve_3pool_lp_address = "0xE7a24EF0C5e95Ffb0f6684b813A78F2a3AD7D171"
    const curve_USDR3pool_address = "0xa138341185a9D0429B0021A11FB717B225e13e1F"
    const rusd_address = "0xb5DFABd7fF7F83BAB83995E72A52B97ABb7bcf63"

    const dai = await getContract(dai_address, iERC20.abi)
    const wmatic = await getContract(wmatic_address, iERC20.abi)
    const usdc = await getContract(usdc_address, iERC20.abi)
    const rusd = await getContract(rusd_address, iERC20.abi)
    const curve_3pool = await getContract(curve_3pool_address, iCurve3Pool.abi)
    const router = await getContract(router_address, iUniswapV2Router2.abi)
    const usdt = await getContract(usdt_address, iERC20.abi)
    const curve_3pool_lp = await getContract(curve_3pool_lp_address, iCurve3PoolLP.abi)
    const curve_USDR3pool = await getContract(curve_USDR3pool_address, iCurveUSDR3Pool.abi)
    let contract = new web3.eth.Contract(metadata.abi)

    contract = contract.deploy({
      data: metadata.bytecode
      //arguments: ["Mask", "N95"]
    })

    newContractInstance = await contract.send({
      from: accounts[0],
      gas: 1500000,
      gasPrice: '30000000000'
    })

    const init_wmatic_amount = "5000000000000000"


    // Get WMATIC to account0
    await web3.eth.sendTransaction({to: wmatic_address, from: accounts[0], value: init_wmatic_amount})
    
    // Approve contract to spend WMATIC
    await wmatic.methods.approve(newContractInstance.options.address, init_wmatic_amount).send({
      from: accounts[0],
      gas: 1500000,
      gasPrice: '30000000000'
    })

  
    // swap WMATIC to USDC and send back to account0
    await newContractInstance.methods.swap_exact_tokens_for_tokens(init_wmatic_amount, "1", wmatic_address, usdc_address, "100000000000000000000000").send({
      from: accounts[0],
      gas: 15000000,
      gasPrice: '30000000000'
    })

    // Approve contract to spend USDC from account0
    const usdc_balance_appprove = await usdc.methods.balanceOf(accounts[0]).call()
    await usdc.methods.approve(newContractInstance.options.address, usdc_balance_appprove).send({
      from: accounts[0],
      gas: 1500000,
      gasPrice: '30000000000'
    })

    await newContractInstance.methods.add_user_deposit(usdc_balance_appprove).send({
      from: accounts[0],
      gas: 3100000,
      gasPrice: '30000000000'
    })

    let usdc_balance = await usdc.methods.balanceOf(newContractInstance.options.address).call()
    console.log("USDC: " + usdc_balance)
    let dai_balance = await dai.methods.balanceOf(newContractInstance.options.address).call()
    console.log("DAI: " + dai_balance)
    let usdt_balance = await usdt.methods.balanceOf(newContractInstance.options.address).call()
    console.log("USDT: " + usdt_balance)
    let curve_3pool_lp_balance = await curve_3pool_lp.methods.balanceOf(newContractInstance.options.address).call()
    console.log("CURVE3POOL: " + curve_3pool_lp_balance)
    let rusd_balance = await rusd.methods.balanceOf(newContractInstance.options.address).call()
    console.log("RUSDC: " + rusd_balance)
    let curve_USDR3pool_balance = await curve_USDR3pool.methods.balanceOf(newContractInstance.options.address).call()
    console.log("RUSD + CURVE3 POOL: " + curve_USDR3pool_balance)
    console.log("------------ WITHDRAW ------------")

    await newContractInstance.methods.withdraw_user_deposit(curve_USDR3pool_balance).send({
      from: accounts[0],
      gas: 3100000,
      gasPrice: '30000000000'
    })

    curve_USDR3pool_balance = await curve_USDR3pool.methods.balanceOf(newContractInstance.options.address).call()
    console.log("RUSD + CURVE3 POOL: " + curve_USDR3pool_balance)
    curve_3pool_lp_balance = await curve_3pool_lp.methods.balanceOf(newContractInstance.options.address).call()
    console.log("CURVE3POOL: " + curve_3pool_lp_balance)
    rusd_balance = await rusd.methods.balanceOf(newContractInstance.options.address).call()
    console.log("RUSDC: " + rusd_balance)
    usdt_balance = await usdt.methods.balanceOf(newContractInstance.options.address).call()
    console.log("USDT: " + usdt_balance)
    usdc_balance = await usdc.methods.balanceOf(newContractInstance.options.address).call()
    console.log("USDC: " + usdc_balance)
    dai_balance = await dai.methods.balanceOf(newContractInstance.options.address).call()
    console.log("DAI: " + dai_balance)

    
  } catch (e) {
    console.log(e.message)
  }
})()