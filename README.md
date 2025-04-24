# TransferETH
A basic contract for learning how to transfer ETH tokens using ganache, truffle.


We have two contract ( SenderReviver.sol and SendingTokens.sol).
The first one:
When you deploy and call it you can call it like this (*amountOfETH,AddressOwner,AddressSender).
The second is actully my training case , witch is having 4 level i started to figure out step by step how they are working.
Here is the log that you should see after compile:

```
 truffle migrate --reset --compile-all

Compiling your contracts...
===========================
> Compiling .\contracts\SenderReciver.sol
> Compiling .\contracts\SendingTokens.sol
> Compilation warnings encountered:

    Warning: Source file does not specify required compiler version! Consider adding "pragma solidity ^0.8.24;"
--> project:/contracts/SenderReciver.sol


> Artifacts written to C:\Users\mopc\Desktop\Swap\SendToken\build\contracts
> Compiled successfully using:
   - solc: 0.8.24+commit.e11b9ed9.Emscripten.clang


Starting migrations...
======================
> Network name:    'development'
> Network id:      5777
> Block gas limit: 6721975 (0x6691b7)


2_deploy_transfer.js
====================

   Deploying 'Transfer'
   --------------------
   > transaction hash:    0xc3a9f7958a804ebc755bc6f94606ed081436410a135438147e902193e9745b3c
   > Blocks: 0            Seconds: 0
   > contract address:    0x618442c13E82164C168140f2bFCDb84CaA679E2A
   > block number:        1
   > block timestamp:     1745506491
   > account:             0x814EabE6C22a4ba2B7658702cd9cB56155DbD34f
   > balance:             99.999542736
   > gas used:            228632 (0x37d18)
   > gas price:           2 gwei
   > value sent:          0 ETH
   > total cost:          0.000457264 ETH

   > Saving artifacts
   -------------------------------------
   > Total cost:         0.000457264 ETH

Summary
=======
> Total deployments:   1
> Final cost:          0.000457264 ETH

```
Use my test script for running it and send 1 ETH to another account:
```
PS C:\Users\mopc\Desktop\Swap\SendToken> truffle test
Using network 'development'.


Compiling your contracts...
===========================
> Compiling .\contracts\SenderReciver.sol
> Compiling .\contracts\SendingTokens.sol
> Compilation warnings encountered:

    Warning: Source file does not specify required compiler version! Consider adding "pragma solidity ^0.8.24;"
--> project:/contracts/SenderReciver.sol


> Artifacts written to C:\Users\mopc\AppData\Local\Temp\test--13728-09HGVqFPaz5b
> Compiled successfully using:
   - solc: 0.8.24+commit.e11b9ed9.Emscripten.clang


]
Contract deployed at: 0x4939e5c71b4406A66BAf720e003C49D6425473AA
Transaction Hash: 0x82271540d842188727372e612b895c7dbc811c446b717ead9cdef945251241d3
FundsTransferred Event: {
  event: 'FundsTransferred',
  from: '0x28B41B01aC86A44EF878C830ccD9e0c237363B01',
  to: '0x814EabE6C22a4ba2B7658702cd9cB56155DbD34f',
  amount: '1000000000000000000'
}
    ✔ should deploy and transfer ETH to owner


  1 passing (90ms)
```


