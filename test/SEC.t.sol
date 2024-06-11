// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/SEC.sol";

contract SECTest is Test {
    SEC private sec;

    address private employer = address(0x123);
    bytes private candidateID = "candidate1";
    uint private maxPay = 1000;

    function setUp() public {
        sec = new SEC();
    }

    function testCreateJob() public {
        vm.prank(employer);
        uint jobID = sec.createJob(maxPay);
        assertEq(jobID, 0);
    }

    function testNewCandidate() public {
        vm.prank(employer);
        uint jobID = sec.createJob(maxPay);

        vm.prank(employer);
        sec.newCandidate(jobID, candidateID);

        //TODO
        // Check if the candidate is registered
        // Note: This requires adding a public function or modifying the contract to access the private mapping
    }

    function testMatch() public {
        uint minPay = 500;
        
        vm.prank(employer);
        uint jobID = sec.createJob(maxPay);

        vm.prank(employer);
        sec.newCandidate(jobID, candidateID);

        bool isValid = sec.setAndCheckMinPay(jobID, candidateID, minPay);
        assertTrue(isValid);

        vm.prank(employer);
        bool isMatch = sec.isMatch(jobID, candidateID);
        assertTrue(isMatch);
    }

    function testNoMatch() public {
        uint minPay = 2000;

        vm.prank(employer);
        uint jobID = sec.createJob(maxPay);

        vm.prank(employer);
        sec.newCandidate(jobID, candidateID);

        bool isValid = sec.setAndCheckMinPay(jobID, candidateID, minPay);
        assertTrue(!isValid);

        vm.prank(employer);
        bool isMatch = sec.isMatch(jobID, candidateID);
        assertTrue(!isMatch);
    }
}
