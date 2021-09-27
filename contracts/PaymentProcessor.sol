 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
// import 'github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

/**
 * The PaymentProcessor contract does this and that...
 */
contract PaymentProcessor is Ownable {

    IERC20 private UJToken;
    uint private SCHOOL_FEES_PRICE = 1 ether;

    event LogPayment(address indexed who,
                      address indexed to,
                      string memory payer,
                      uint amount,
                      uint date);

    event LogRefund(address indexed to, uint amount);
    event LogWidrawal(address indexed by, uint amount);
    event LogFeeAmount(address indexed by, uint amount)



  constructor(address UJTokenAddress, uint _price) {
    UJToken = IERC20(UJTokenAddress);
    SCHOOL_FEES_PRICE = _price;
  }


  /**
 * function for a push payment, though openzeppelin favors pull payment over push
 * payment. To favor a pull payment, make payment to address(this) and write a wthdrawal
 * function so that owner/deployer of contract can make withdrawal at particular token threshold..
 */

  modifier checkAmount(uint _payer_amount) {
    if(_payer_amount < SCHOOL_FEES_PRICE) revert('Insufficient funds.');
    _;
  }

  function makePayment(address indexed _payer_address, string memory _payer, uint _payer_amount) external payable{
    require (_payer_address != address(0), 'PaymentProcessor: Invalid Address.');
    if(_payer_amount >= SCHOOL_FEES_PRICE){
      UJToken.transferFrom(_payer_address, payable(address(this)), _payer_amount);
      emit LogPayment(_payer_address, address(this), _payer, _amount, block.timestamp);
    }
    revert('Insufficient payment fee.');
  }

  function setSchoolfFees(uint _amount) external {
    require(owner() == _msgSender(), 'Ownable: Only owner can initiate transaction.');
    SCHOOL_FEES_PRICE = _amount;
    emit LogFeeAmount(_msgSender(), _amount);
  }

  function getSchoolFees() external view returns(uint){ return SCHOOL_FEES_PRICE; }

  function withdrawal() external returns(bool){
    require(owner() == _msgSender(), 'Ownable: Only owner can initiate transaction.');
    require(address(this).balance > 0, "Cant withdraw 0 UJT")
    uint balanceBeforeTransfer = address(this).balance;
    (bool success, ) = payable(_msgSender()).call{value:balanceBeforeTransfer}(""); //Read About these again

    if(success){
      emit LogWidrawal(_msgSender(), balanceBeforeTransfer);
      return true;
    }
    return false;
  }

  function refund(address payable reciever, uint amount) external{
    require(owner() == _msgSender(), 'Ownable: Only owner can initiate transaction.');
    reciever.transfer(amount);
    emit Refunded(reciever, block.timestamp);
  }

  // call back functions for plain ether transfer to avoid sending to address zero
  fallback() external payable {
      emit LogRecieved(_msgSender(), block.timestamp);
      }

  receive() external payable {
    emit LogRecieved(_msgSender(), block.timestamp);
  }
}


