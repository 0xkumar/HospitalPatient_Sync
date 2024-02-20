// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Hospital.sol";

contract HospitalFactory {
    //Mapping to store the hospital address and hospital name
    mapping(address => string) public hospitalList;

    //store the deployed hospitals
    address[] public hospitals;

    //modifier to check the owner of the hospital
    modifier onlyHospitalOwner() {
        bool isOwner = false;
        for (uint256 i = 0; i < hospitals.length; i++) {
            if (hospitals[i] == msg.sender) {
                isOwner = true;
            }
        }
        require(isOwner == true, "Only Hospital Owner Can Access");
        _;
    }

    //function to deploy the hospital
    //Todo : One owner can only deploy one hospital

    function deploy_Hospital(string calldata _name) public returns (address) {
        bytes32 _nameHash = keccak256(abi.encodePacked(_name));

        for (uint256 i = 0; i < hospitals.length; i++) {
            if (keccak256(abi.encodePacked(hospitalList[hospitals[i]])) == _nameHash) {
                revert(
                    "The Hospial name is already in use try different name or add the region name with your hospital name"
                );
            }
        }
        address deployed_hospitalAddress = add_Hospital(_name);
        return deployed_hospitalAddress;
    }

    function add_Hospital(string calldata _name) internal returns (address) {
        Hospital newHospital = new Hospital(_name, msg.sender);
        hospitals.push(address(newHospital));
        hospitalList[address(newHospital)] = _name;
        return address(newHospital);
    }

    //function to get the list of hospitals
    function getHospitals() public view returns (address[] memory) {
        return hospitals;
    }

    //Todo:
    //1.Check wheather the patient joined in the hospital or not
    //2.If joined then get the details of the patient
    //3.Store the details of the patient in a mapping.
    //4.Dispaly all the  patient details in all hospitals that the patient joined.

    function getPatientDetailsInAllHospitalsHeJoined(address _patientAddress)
        external
        view
        onlyHospitalOwner
        returns (Hospital.Patient[] memory)
    {
        Hospital.Patient[] memory allPatientDetails;

        // for(uint i = 0; i < hospitals.length; i++){
        //     Hospital hospital = Hospital(hospitals[i]);

        //     Hospital.Patient[] memory patientDetails = hospital.getPatientDetails(_patientAddress);
        //     for(uint j = 0; j < patientDetails.length; j++){
        //         allPatientDetails[allPatientDetails.length] = patientDetails[j];
        //     }
        // }
        // return allPatientDetails;

        for (uint256 i = 0; i < hospitals.length; i++) {
            Hospital hospital = Hospital(hospitals[i]);

            //check wheather the patient joined in the hospital or not
            bool joined = hospital.checkPatientJoined(_patientAddress);
            if (joined) {
                Hospital.Patient[] memory patientDetails = hospital.getPatientDetails(_patientAddress);
                for (uint256 j = 0; j < patientDetails.length; j++) {
                    allPatientDetails[allPatientDetails.length] = patientDetails[j];
                }
            }
        }
        return allPatientDetails;
    }

    //function to get the patient details in one hospital
    function getPatientDetails(address _hospitalAddress, address _patientAddress)
        public
        view
        returns (Hospital.Patient[] memory)
    {
        Hospital hospital = Hospital(_hospitalAddress);
        return hospital.getPatientDetails(_patientAddress);
    }
}
