import iERC20 from 'build/polygon-contracts/iERC20.json'
import iCurveFactory from 'build/polygon-contracts/iCurveFactory.json'
import iUniswapV2Router2 from 'build/polygon-contracts/IUniswapV2Router02.json'

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
    const curve_factory_address = "0x445FE580eF8d70FF569aB36e80c647af338db351"
    const usdt_address = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F"

    const dai = await getContract(dai_address, iERC20.abi)
    const wmatic = await getContract(wmatic_address, iERC20.abi)
    const usdc = await getContract(usdc_address, iERC20.abi)
    const curve_factory = await getContract(curve_factory_address, iCurveFactory.abi)
    const router = await getContract(router_address, iUniswapV2Router2.abi)
    const usdt = await getContract(usdt_address, iERC20.abi)
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

    const init_wmatic_amount = "180000000000000000000"


    // Get WMATIC to account0
    await web3.eth.sendTransaction({to: wmatic_address, from: accounts[0], value: init_wmatic_amount})
    
    // Approve contract to spend WMATIC
    await wmatic.methods.approve(newContractInstance.options.address, init_wmatic_amount).send({
      from: accounts[0],
      gas: 1500000,
      gasPrice: '30000000000'
    })

  
    // swap WMATIC to USDC and send back to account0
    await newContractInstance.methods.swap_exact_tokens_for_tokens("60000000000000000000", "1", wmatic_address, usdc_address, "100000000000000000000000").send({
      from: accounts[0],
      gas: 15000000,
      gasPrice: '30000000000'
    })

    // swap WMATIC to USDC and send back to account0
    await newContractInstance.methods.swap_exact_tokens_for_tokens("60000000000000000000", "1", wmatic_address, usdt_address, "100000000000000000000000").send({
      from: accounts[0],
      gas: 15000000,
      gasPrice: '30000000000'
    })

    // swap WMATIC to USDC and send back to account0
    await newContractInstance.methods.swap_exact_tokens_for_tokens("60000000000000000000", "1", wmatic_address, dai_address, "100000000000000000000000").send({
      from: accounts[0],
      gas: 15000000,
      gasPrice: '30000000000'
    })


    const usdc_balance = await usdc.methods.balanceOf(accounts[0]).call()
    console.log(usdc_balance)
    const dai_balance = await dai.methods.balanceOf(accounts[0]).call()
    console.log(dai_balance)
    const usdt_balance = await usdt.methods.balanceOf(accounts[0]).call()
    console.log(usdt_balance)






    
  } catch (e) {
    console.log(e.message)
  }
})()