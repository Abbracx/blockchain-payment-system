 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * The Student contract does this and that...
 */
 import "./PaymentProcessor.sol";
 import "@openzeppelin/contracts/access/Ownable.sol";


contract StudentContract is Context{

    uint internal paymentId = 0;

    PaymentProcessor internal paymentProcessorAddress;


    event LogRegistered(address indexed who, string mat_num, uint when);
    event LogUpdated(address indexed by, string mat_num, uint when);
    event LogDeleted(address indexed by, string mat_num, uint when);

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
        uint studentIndex;
        address studentAddress;
        string name;
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



    //create student
    function createStudent (string memory _mat_Number, string memory _name) external returns(uint){

        require (_msgSender() != address(0), "Invalid address.");
        require (_msgSender() != Students[_mat_Number].studentAddress, "Student Already Exist.");
        require (Students[_mat_Number].status != RegisteredStatus.REGISTERED, "Student Already Exist.");

        Student storage student = Students[_mat_Number];

        student.studentIndex = matNumbers.push(_mat_Number);
        student.studentAddress = _msgSender();
        student.name = _name;
        student.status = RegisteredStatus.REGISTERED;
        student._payments = new Payment[](0);

        emit LogRegistered(_msgSender(), _mat_Number, block.timestamp);
        return matNumbers.length
    }

    //Retrieve student record
    function getStudent (string memory _mat_Number) external view returns(uint, address, string memory, RegisteredStatus, Payment[]) {
        require(studentExist(_mat_Number), 'No student Found');
        Student storage student = Students[_mat_Number];
        return(student.studentIndex,
                student.studentAddress,
                student.name,
                student.status,
                student._payments);
    }

    // update student record
    function updateStudent(string memory _mat_Number, string memory _name) external {
        require(studentExist(_mat_Number), 'No student Found');
        Students[_mat_Number].name = _name;
        emit LogUpdated(_msgSender(), _mat_Number, block.timestamp);
    }

    //Delete student. Only Admin can Delete
    function deleteStudent(string memory _mat_Number) external returns(string memory){
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        require(studentExist(_mat_Number), 'Sorry can not delete none existent student.');

        uint valToDel = Students[_mat_Number].studentIndex;
        string memory keyToMove = matNumbers[matNumbers.length];
        matNumbers[valToDel] = keyToMove;
        Students[keyToMove].index = valToDel;
        matNumbers.length--;
        return _mat_Number;
    }

    //Check for student Existence before performing any action
    function studentExist (string memory _mat_Number) internal pure returns(bool){
        if(matNumbers.length == 0) return false;
        return (matNumbers[Students[_mat_Number].studentIndex] == _mat_Number);
    }

    //returns the number of student available unordered array of matNumbers
    function studentCount() external pure returns(uint){
        return matNumbers.length;
    }

    function getStudentAtIndex(uint index) external pure returns(string memory){
        return matNumbers[index];
    }

    //function for student to pay fees
    function payFees(string memory _mat_Number, uint _amount) external payable checkValue(){
      require(studentExist(_mat_Number), "Sorry only valid student can pay fees.");
      require (Students[_mat_Number].studentAddress == _msgSender(), "Invalid Wallet Address...");
      paymentProcessorAddress.makePayment(_msgSender(), _mat_Number, _amount);
    }

}

