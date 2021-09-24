 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * The Student contract does this and that...
 */
 import "./PaymentProcessor.sol";
 import "../../../../utils/Context.sol";


contract StudentContract is Context{

    uint internal paymentId = 0;
    uint internal studentIndex = 0;
    PaymentProcessor internal paymentProcessorAddress;


    event LogRegistered(
        address indexed student,
        string mat_num,
        uint when
        );

    enum RegisteredStatus { NOT_REGISTERED, REGISTERED }
    RegisteredStatus status = RegisteredStatus.NOT_REGISTERED;

    struct Payment {
        uint paymentId;
        bytes32 session;
        uint amount;
        uint paymentDate;
        bool paymentStatus;
    }


    struct Student{
        address studentAddress;
        string name;
        uint studentIndex;
        RegisteredStatus status;
        Payment[] _payments;
    }


    mapping (string => Student) Students;
    string [] matNumbers;

    constructor(PaymentProcessor _paymentProcessorAddress) {
      paymentProcessorAddress = _paymentProcessorAddress;
    }

    //MODIFIERS
     modifier checkValue() {
      if (msg.value <= 0) revert();
      _;
    }



    //FUNCTION TO REGISTER A STUDENT
    function createStudent (string memory _mat_Number, string memory _name) external {

        require (_msgSender() != address(0), "Invalid address.");
        require (_msgSender() != Students[_mat_Number].studentAddress, "Student Already Exist.");
        require (Students[_mat_Number].status != RegisteredStatus.REGISTERED, "Student Already Exist.");


        Student storage student = Students[_mat_Number];

        student.studentAddress = _msgSender();
        student.name = _name;
        student.status = RegisteredStatus.REGISTERED;

        matNumbers.push(_mat_Number)
        emit LogRegistered(_msgSender(), _mat_Number, block.timestamp);
    }

    function getStudent (string memory _mat_Number) external view returns(string memory, string memory, address) {
        //copy the data into memory
        address caller = _msgSender();
        require (matNum_to_address[_mat_Number] == caller, "NOT FOUND...");
        Student memory student = Students[caller];
        return (student.mat_Num, student.name, matNum_to_address[_mat_Number] );
    }

    function getStudentAddress(string memory _mat_Num) external view returns(address){
      return matNum_to_address[_mat_Num];
    }


    function payFees(string memory _mat_Number, uint paymentId) external payable checkValue(){

      require(matNum_to_address[_mat_Number] == _msgSender(), "Only valid student can pay fees...");
      require (_msgSender() != address(0), "Invalid Address...");

      uint amount = msg.value;
      payment_processor.pay(amount, paymentId, matNum_to_address[_mat_Number]);
    }

}

