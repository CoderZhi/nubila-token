// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NubilaNetwork} from "../src/NubilaNetwork.sol";
import {VestingManager} from "../src/VestingManager.sol";

contract VestingManagerTest is Test {
    VestingManager public manager;
    NubilaNetwork public token;
    address[] public beneficiaries;
    uint256 public tge;

    function setUp() public {
        beneficiaries.push(address(0x1));
        beneficiaries.push(address(0x2));
        beneficiaries.push(address(0x3));
        beneficiaries.push(address(0x4));
        beneficiaries.push(address(0x5));
        beneficiaries.push(address(0x6));
        beneficiaries.push(address(0x7));
        beneficiaries.push(address(0x8));
        beneficiaries.push(address(0x9));
        beneficiaries.push(address(0xA));
        beneficiaries.push(address(0xB));
        beneficiaries.push(address(0xC));
        token = new NubilaNetwork(address(this));
        tge = block.timestamp + 1 minutes;
        manager = new VestingManager(address(token), tge, beneficiaries);
        assertTrue(token.transfer(address(manager), token.totalSupply()));
    }

    function testNumOfSchedules() public view {
        assertEq(manager.numOfSchedules(), 12);
    }

    function testGetSchedule() public view {
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(0);
            assertEq(beneficiary, address(0x1));
            assertEq(totalAmount, 210_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 90 days);
            assertEq(terms[0].num, 20);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(1);
            assertEq(beneficiary, address(0x2));
            assertEq(totalAmount, 200_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 90 days);
            assertEq(terms[0].num, 20);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(2);
            assertEq(beneficiary, address(0x3));
            assertEq(totalAmount, 62_500_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 12 * 30 days);
            assertEq(terms[0].period, 90 days);
            assertEq(terms[0].num, 12);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(3);
            assertEq(beneficiary, address(0x4));
            assertEq(totalAmount, 80_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 12 * 30 days);
            assertEq(terms[0].period, 90 days);
            assertEq(terms[0].num, 8);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(4);
            assertEq(beneficiary, address(0x5));
            assertEq(totalAmount, 5_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 0);
            assertEq(terms[0].num, 1);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(5);
            assertEq(beneficiary, address(0x6));
            assertEq(totalAmount, 65_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 2);
            assertEq(terms[0].percentage, 250_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 0);
            assertEq(terms[0].num, 1);
            assertEq(terms[1].percentage, 750_000);
            assertEq(terms[1].cliff, 90 days);
            assertEq(terms[1].period, 90 days);
            assertEq(terms[1].num, 20);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(6);
            assertEq(beneficiary, address(0x7));
            assertEq(totalAmount, 78_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 2);
            assertEq(terms[0].percentage, 400_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 0);
            assertEq(terms[0].num, 1);
            assertEq(terms[1].percentage, 600_000);
            assertEq(terms[1].cliff, 90 days);
            assertEq(terms[1].period, 90 days);
            assertEq(terms[1].num, 4);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(7);
            assertEq(beneficiary, address(0x8));
            assertEq(totalAmount, 120_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 12 * 30 days);
            assertEq(terms[0].period, 90 days);
            assertEq(terms[0].num, 12);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(8);
            assertEq(beneficiary, address(0x9));
            assertEq(totalAmount, 20_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 12 * 30 days);
            assertEq(terms[0].period, 90 days);
            assertEq(terms[0].num, 12);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(9);
            assertEq(beneficiary, address(0xA));
            assertEq(totalAmount, 22_500_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 0);
            assertEq(terms[0].num, 1);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(10);
            assertEq(beneficiary, address(0xB));
            assertEq(totalAmount, 75_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 3);
            assertEq(terms[0].percentage, 250_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 0);
            assertEq(terms[0].num, 1);
            assertEq(terms[1].percentage, 250_000);
            assertEq(terms[1].cliff, 3 * 30 days);
            assertEq(terms[1].period, 0);
            assertEq(terms[1].num, 1);
            assertEq(terms[2].percentage, 500_000);
            assertEq(terms[2].cliff, 6 * 30 days);
            assertEq(terms[2].period, 0);
            assertEq(terms[2].num, 1);
        }
        {
            (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(11);
            assertEq(beneficiary, address(0xC));
            assertEq(totalAmount, 62_000_000 ether);
            assertEq(vestedAmount, 0);
            assertEq(termIndex, 0);
            assertEq(terms.length, 1);
            assertEq(terms[0].percentage, 1_000_000);
            assertEq(terms[0].cliff, 0);
            assertEq(terms[0].period, 0);
            assertEq(terms[0].num, 1);
        }
    }

    function testBeforeTGE() public {
        vm.warp(tge - 30 seconds);
        uint256 totalAmount = 0;
        for (uint i = 0; i < 12; ++i) {
            assertEq(manager.claimable(i), 0);
            totalAmount += token.balanceOf(beneficiaries[i]);
        }
        assertEq(totalAmount, 0);
    }

    function testScheduleAfterTGE() public {
        {// tge
            vm.warp(tge + 1 minutes);
            assertEq(manager.claimable(0), 10_500_000 ether);
            assertEq(manager.claimable(1), 10_000_000 ether);
            assertEq(manager.claimable(2), 0 ether);
            assertEq(manager.claimable(3), 0 ether);
            assertEq(manager.claimable(4), 5_000_000 ether);
            assertEq(manager.claimable(5), 16_250_000 ether);
            assertEq(manager.claimable(6), 31_200_000 ether);
            assertEq(manager.claimable(7), 0 ether);
            assertEq(manager.claimable(8), 0 ether);
            assertEq(manager.claimable(9), 22_500_000 ether);
            assertEq(manager.claimable(10), 18_750_000 ether);
            assertEq(manager.claimable(11), 62_000_000 ether);
            manager.claim(0);
            manager.claim(1);
            manager.claim(4);
            manager.claim(5);
            manager.claim(6);
            manager.claim(9);
            manager.claim(10);
            manager.claim(11);
            assertEq(token.balanceOf(beneficiaries[0]), 10_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 10_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[3]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 16_250_000 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 31_200_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 18_750_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            vm.warp(tge + 89 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 3 months
            vm.warp(tge + 92 days);
            assertEq(manager.claimable(0), 10_500_000 ether);
            assertEq(manager.claimable(1), 10_000_000 ether);
            assertEq(manager.claimable(2), 0 ether);
            assertEq(manager.claimable(3), 0 ether);
            assertEq(manager.claimable(4), 0 ether);
            assertEq(manager.claimable(5), 2_437_500 ether);
            assertEq(manager.claimable(6), 11_700_000 ether);
            assertEq(manager.claimable(7), 0 ether);
            assertEq(manager.claimable(8), 0 ether);
            assertEq(manager.claimable(9), 0 ether);
            assertEq(manager.claimable(10), 18_750_000 ether);
            assertEq(manager.claimable(11), 0 ether);
            manager.claim(0);
            manager.claim(1);
            manager.claim(5);
            manager.claim(6);
            manager.claim(10);
            assertEq(token.balanceOf(beneficiaries[0]), 21_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 20_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[3]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 18_687_500 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 42_900_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 37_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            vm.warp(tge + 119 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 6 months
            vm.warp(tge + 180 days);
            assertEq(manager.claimable(0), 10_500_000 ether);
            assertEq(manager.claimable(1), 10_000_000 ether);
            assertEq(manager.claimable(2), 0 ether);
            assertEq(manager.claimable(3), 0 ether);
            assertEq(manager.claimable(4), 0 ether);
            assertEq(manager.claimable(5), 2_437_500 ether);
            assertEq(manager.claimable(6), 11_700_000 ether);
            assertEq(manager.claimable(7), 0 ether);
            assertEq(manager.claimable(8), 0 ether);
            assertEq(manager.claimable(9), 0 ether);
            assertEq(manager.claimable(10), 37_500_000 ether);
            assertEq(manager.claimable(11), 0 ether);
            manager.claim(0);
            manager.claim(1);
            manager.claim(5);
            manager.claim(6);
            manager.claim(10);
            assertEq(token.balanceOf(beneficiaries[0]), 31_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 30_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[3]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 21_125_000 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 54_600_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 0 ether);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 75_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            vm.warp(tge + 269 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 12 months
            vm.warp(tge + 4 * 90 days);
            assertEq(manager.claimable(0), 10_500_000 ether);
            assertEq(manager.claimable(1), 10_000_000 ether);
            assertEq(manager.claimable(2), 5_208_333 ether + 333_333_333_333_333_333);
            assertEq(manager.claimable(3), 10_000_000 ether);
            assertEq(manager.claimable(4), 0 ether);
            assertEq(manager.claimable(5), 2_437_500 ether);
            assertEq(manager.claimable(6), 11_700_000 ether);
            assertEq(manager.claimable(7), 10_000_000 ether);
            assertEq(manager.claimable(8), 1_666_666 ether + 666_666_666_666_666_666);
            assertEq(manager.claimable(9), 0 ether);
            assertEq(manager.claimable(10), 0 ether);
            assertEq(manager.claimable(11), 0 ether);
            manager.claim(0);
            manager.claim(1);
            manager.claim(2);
            manager.claim(3);
            manager.claim(5);
            manager.claim(6);
            manager.claim(7);
            manager.claim(8);
            assertEq(token.balanceOf(beneficiaries[0]), 42_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 40_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 5_208_333 ether + 333_333_333_333_333_333);
            assertEq(token.balanceOf(beneficiaries[3]), 10_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 23_562_500 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 66_300_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 10_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 1_666_666 ether + 666_666_666_666_666_666);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 75_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            assertEq(manager.claimable(0), 10_500_000 ether);
            assertEq(manager.claimable(1), 10_000_000 ether);
            assertEq(manager.claimable(5), 2_437_500 ether);
            assertEq(manager.claimable(6), 11_700_000 ether);
            manager.claim(0);
            manager.claim(1);
            manager.claim(5);
            manager.claim(6);
            assertEq(token.balanceOf(beneficiaries[0]), 52_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 50_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 26_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 78_000_000 ether);
            vm.warp(tge + 449 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 33 months
            vm.warp(tge + 11 * 90 days);
            for (uint i = 5; i < 12; ++i) {
                assertEq(manager.claimable(0), 10_500_000 ether);
                assertEq(manager.claimable(1), 10_000_000 ether);
                assertEq(manager.claimable(2), 5_208_333 ether + 333_333_333_333_333_333);
                assertEq(manager.claimable(3), 10_000_000 ether);
                assertEq(manager.claimable(4), 0 ether);
                assertEq(manager.claimable(5), 2_437_500 ether);
                assertEq(manager.claimable(6), 0 ether);
                assertEq(manager.claimable(7), 10_000_000 ether);
                assertEq(manager.claimable(8), 1_666_666 ether + 666_666_666_666_666_666);
                assertEq(manager.claimable(9), 0 ether);
                assertEq(manager.claimable(10), 0 ether);
                assertEq(manager.claimable(11), 0 ether);
                manager.claim(0);
                manager.claim(1);
                manager.claim(2);
                manager.claim(3);
                manager.claim(5);
                manager.claim(7);
                manager.claim(8);
            }
            assertEq(token.balanceOf(beneficiaries[0]), 126_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 120_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 41_666_666 ether + 666_666_666_666_666_664);
            assertEq(token.balanceOf(beneficiaries[3]), 80_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 43_062_500 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 78_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 80_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 13_333_333 ether + 333_333_333_333_333_328);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 75_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            vm.warp(tge + 1079 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 45 months
            vm.warp(tge + 15 * 90 days);
            for (uint i = 12; i < 16; ++i) {
                assertEq(manager.claimable(0), 10_500_000 ether);
                assertEq(manager.claimable(1), 10_000_000 ether);
                assertEq(manager.claimable(3), 0 ether);
                assertEq(manager.claimable(4), 0 ether);
                assertEq(manager.claimable(5), 2_437_500 ether);
                assertEq(manager.claimable(6), 0 ether);
                assertEq(manager.claimable(7), 10_000_000 ether);
                if (i == 15) {
                    assertEq(manager.claimable(8), 1_666_666 ether + 666_666_666_666_666_666 + 8);
                    assertEq(manager.claimable(2), 5_208_333 ether + 333_333_333_333_333_333 + 4);
                } else {
                    assertEq(manager.claimable(8), 1_666_666 ether + 666_666_666_666_666_666);
                    assertEq(manager.claimable(2), 5_208_333 ether + 333_333_333_333_333_333);
                }
                assertEq(manager.claimable(9), 0 ether);
                assertEq(manager.claimable(10), 0 ether);
                assertEq(manager.claimable(11), 0 ether);
                manager.claim(0);
                manager.claim(1);
                manager.claim(2);
                manager.claim(5);
                manager.claim(7);
                manager.claim(8);
            }
            assertEq(token.balanceOf(beneficiaries[0]), 168_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 160_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 62_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[3]), 80_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 52_812_500 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 78_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 120_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 20_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 75_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            vm.warp(tge + 1439 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 60 months
            vm.warp(tge + 19 * 90 days);
            for (uint i = 16; i < 20; ++i) {
                assertEq(manager.claimable(0), 10_500_000 ether);
                assertEq(manager.claimable(1), 10_000_000 ether);
                assertEq(manager.claimable(2), 0 ether);
                assertEq(manager.claimable(3), 0 ether);
                assertEq(manager.claimable(4), 0 ether);
                assertEq(manager.claimable(5), 2_437_500 ether);
                assertEq(manager.claimable(6), 0 ether);
                assertEq(manager.claimable(7), 0 ether);
                assertEq(manager.claimable(8), 0 ether);
                assertEq(manager.claimable(9), 0 ether);
                assertEq(manager.claimable(10), 0 ether);
                assertEq(manager.claimable(11), 0 ether);
                manager.claim(0);
                manager.claim(1);
                manager.claim(5);
            }
            assertEq(token.balanceOf(beneficiaries[0]), 210_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[1]), 200_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[2]), 62_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[3]), 80_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[4]), 5_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[5]), 62_562_500 ether);
            assertEq(token.balanceOf(beneficiaries[6]), 78_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[7]), 120_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[8]), 20_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[9]), 22_500_000 ether);
            assertEq(token.balanceOf(beneficiaries[10]), 75_000_000 ether);
            assertEq(token.balanceOf(beneficiaries[11]), 62_000_000 ether);
            vm.warp(tge + 1799 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
        }
        {// 61 months
            vm.warp(tge + 1800 days);
            for (uint i = 0; i < 5; i++) {
                assertEq(manager.claimable(i), 0 ether);
            }
            assertEq(manager.claimable(5), 2_437_500 ether);
            for (uint i = 6; i < 12; i++) {
                assertEq(manager.claimable(i), 0 ether);
            }
            manager.claim(5);
            assertEq(token.balanceOf(beneficiaries[5]), 65_000_000 ether);
            vm.warp(tge + 5000 days);
            for (uint i = 0; i < 12; ++i) {
                assertEq(manager.claimable(i), 0);
            }
            uint256 totalAmount = 0;
            for (uint i = 0; i < 12; ++i) {
                totalAmount += token.balanceOf(beneficiaries[i]);
            }
            assertEq(totalAmount, token.totalSupply());
        }
    }

}
