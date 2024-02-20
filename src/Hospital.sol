// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Hospital {
    address public owner;
    address public factory;
    string public hospitalName;

    struct Patient {
        string name;
        string disease;
        string joining_time;
        string medicationUsedToTreat;
    }

    constructor(string memory _hosiptalName, address _owner) {
        owner = _owner;
        hospitalName = _hosiptalName;
        factory = msg.sender;
    }

    modifier onlyowner() {
        require(msg.sender == owner, "Only Owner Can Access");
        _;
    }

    modifier onlyFactory() {
        require(msg.sender == factory, "Only Factory Can Access");
        _;
    }

    Patient[] public patient_submission;

    mapping(address => Patient[]) public Patient_details;

    //function to check the hospital name
    function getHospitalName() public view returns (string memory) {
        return hospitalName;
    }

    //Function to add the Patient Details to the hospital.
    function add_patient(
        address _patientAddress,
        string memory _name,
        string memory _disease,
        string memory monthAndYear,
        string memory medicationUsedToTreat
    ) public onlyowner {
        require(_patientAddress != address(0), "PatientAddress Cant be Zero");

        Patient memory newpatient = Patient({
            name: _name,
            disease: _disease,
            joining_time: monthAndYear,
            medicationUsedToTreat: medicationUsedToTreat
        });
        Patient_details[_patientAddress].push(newpatient);
    }

    //Function to get the Patient Details
    function getPatientDetails(address _patientAddress) public view returns (Patient[] memory) {
        return Patient_details[_patientAddress];
    }

    //function to get the total number of patients in the hospital
    function getTotalPatients() public view returns (uint256) {
        return patient_submission.length;
    }

    //function to check wheather the patient joined in the hospital or not
    function checkPatientJoined(address _patientAddress) public view returns (bool) {
        if (Patient_details[_patientAddress].length > 0) {
            return true;
        } else {
            return false;
        }
    }
}
