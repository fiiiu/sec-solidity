// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "suave-std/Suapp.sol";

contract SEC {

    struct Job {
        address employer;
        uint maxPay;
        mapping(bytes => bool) candidateRegistered;
        mapping(bytes => uint) candidateMinPays;
    }

    mapping(uint jobID => Job job) private jobs;
    uint private currentJobID;

    function createJob(uint maxPay) public returns (uint jobID) {
        Job storage newJob = jobs[currentJobID];
        newJob.employer = msg.sender;
        newJob.maxPay = maxPay;
        currentJobID++;
        return currentJobID - 1;
    }

    function newCandidate(uint jobID, bytes memory candidateID) public {
        //require sender is jobID creator
        require(msg.sender == jobs[jobID].employer);
        jobs[jobID].candidateRegistered[candidateID] = true;
    }

    function setAndCheckMinPay(uint jobID, bytes memory candidateID, uint minPay) public returns (bool) {
        //require candidate is registered
        require(jobs[jobID].candidateRegistered[candidateID]);
        //register candidate's minPay  
        jobs[jobID].candidateMinPays[candidateID] = minPay;
        //unregister candidate to prevent abuse
        jobs[jobID].candidateRegistered[candidateID] = false;
        return minPay <= jobs[jobID].maxPay;
    }

    function isMatch(uint jobID, bytes memory candidateID) public view returns (bool) {
        //require sender is jobID creator
        require(msg.sender == jobs[jobID].employer);
        return jobs[jobID].candidateMinPays[candidateID] <= jobs[jobID].maxPay;
    }

 }
