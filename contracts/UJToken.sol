 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol';
// import 'github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol';

/**
 * The UJToken contract does this and that...
 */
contract UJToken is ERC20PresetMinterPauser {
  constructor() ERC20PresetMinterPauser('UJToken Stablecoin', 'UJT')  {}

  function faucet(address to, uint amount) external{
    mint(to, amount * 10 ** uint256(decimals()));
  }
}

