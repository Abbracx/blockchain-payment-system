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

    uint private SCHOOL_FEES_PRICE;

    event PaymentDone(
        address indexed student_payer,
        uint amount,
        uint paymentId,
        uint date
    );

    event LogRecieved(
      address caller,
      uint date
    );




  constructor(address UJTokenAddress, uint _price) {
    UJToken = IERC20(UJTokenAddress);
    SCHOOL_FEES_PRICE = _price;
  }


  /**
 * function for a push payment, though openzeppelin favors pull payment over push
 * payment. To favor a pull payment, make payment to address(this) and write a wthdrawal
 * function so that owner/deployer of contract can make withdrawal at particular token threshold..
 */

  modifier checkAmount() {
    if(msg.value < SCHOOL_FEES_PRICE) revert();
    _;
  }

  function makePayment(address indexed _payer_address, string memory _payer, uint _payer_amount) external payable{
    require (_payer_address != address(0), 'PaymentProcessor: Invalid Address.');
    UJToken.transferFrom(_payer_address, address(this), _payer_amount);
    emit PaymentDone(_payer_address, _amount, _paymentId, block.timestamp);
  }

  function withdrawal() external returns(bool){
    uint balanceBeforeTransfer = address(this).balance;
    (bool success, ) = payable(owner()).call{value:balanceBeforeTransfer}("");
    require(success, "Transfer failed.");
    return true;
  }

  function refund(address payable reciever, uint amount) external{
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


