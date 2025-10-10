// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NubilaNetwork} from "../src/NubilaNetwork.sol";
import {VestingManager} from "../src/VestingManager.sol";

contract VestingManagerTest is Test {
    VestingManager public manager;
    NubilaNetwork public token;
    address[] public beneficiaries;

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
        manager = new VestingManager(address(token), uint64(block.timestamp + 1 minutes), beneficiaries);
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
        assertEq(terms.length, 2);
        assertEq(terms[0].percentage, 50_000);
        assertEq(terms[0].cliff, 0);
        assertEq(terms[0].period, 0);
        assertEq(terms[0].num, 1);
        assertEq(terms[1].percentage, 950_000);
        assertEq(terms[1].cliff, 30 days);
        assertEq(terms[1].period, 30 days);
        assertEq(terms[1].num, 60);
        }
        {
        (address beneficiary, uint256 totalAmount, uint256 vestedAmount, uint256 termIndex, VestingManager.Term[] memory terms) = manager.getSchedule(1);
        assertEq(beneficiary, address(0x2));
        assertEq(totalAmount, 200_000_000 ether);
        assertEq(vestedAmount, 0);
        assertEq(termIndex, 0);
        assertEq(terms.length, 2);
        assertEq(terms[0].percentage, 50_000);
        assertEq(terms[0].cliff, 0);
        assertEq(terms[0].period, 0);
        assertEq(terms[0].num, 1);
        assertEq(terms[1].percentage, 950_000);
        assertEq(terms[1].cliff, 30 days);
        assertEq(terms[1].period, 30 days);
        assertEq(terms[1].num, 60);
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
        assertEq(terms[0].period, 30 days);
        assertEq(terms[0].num, 36);
        }
    }

    function testBeforeTGE() public {
        vm.warp(block.timestamp + 30 seconds);
        for (uint i = 0; i < 12; ++i) {
            assertEq(manager.claimable(i), 0);
        }
    }

    function testSchedule0AfterTGE() public {
        vm.warp(block.timestamp + 2 minutes);
        // schedule 0
        assertEq(manager.claimable(0), 10_500_000 ether);
        manager.claim(0);
        assertEq(token.balanceOf(beneficiaries[0]), 10_500_000 ether);
        assertEq(manager.claimable(0), 0);
        vm.warp(block.timestamp + 31 days);
        assertEq(manager.claimable(0), 3_325_000 ether);
        vm.prank(beneficiaries[0]);
        manager.claim(0);
        assertEq(token.balanceOf(beneficiaries[0]), 13_825_000 ether);
        assertEq(manager.claimable(0), 0);
        vm.warp(block.timestamp + 30 days);
        assertEq(manager.claimable(0), 3_325_000 ether);
        vm.prank(beneficiaries[0]);
        manager.claim(0);
        assertEq(token.balanceOf(beneficiaries[0]), 17_150_000 ether);
        assertEq(manager.claimable(0), 0);
    }

    function testSchedule1AfterTGE() public {
        vm.warp(block.timestamp + 2 minutes);
        // schedule 1
        assertEq(manager.claimable(1), 10_000_000 ether);
        manager.claim(1);
        assertEq(token.balanceOf(beneficiaries[1]), 10_000_000 ether);
        assertEq(manager.claimable(1), 0);
        vm.warp(block.timestamp + 31 days);
        assertEq(manager.claimable(1), 3_166_666 ether + 666666666666666666);
        manager.claim(1);
        assertEq(token.balanceOf(beneficiaries[1]), 13_166_666 ether + 666666666666666666);
        assertEq(manager.claimable(1), 0);
        vm.warp(block.timestamp + 30 days);
        assertEq(manager.claimable(1), 3_166_666 ether + 666666666666666666);
        manager.claim(1);
        assertEq(token.balanceOf(beneficiaries[1]), 16_333_333 ether + 333333333333333332);
        assertEq(manager.claimable(1), 0);
    }

    function testSchedule2AfterTGE() public {
        vm.warp(block.timestamp + 2 minutes);
        assertEq(manager.claimable(2), 0);
        vm.warp(block.timestamp + 12 * 30 days);
        assertEq(manager.claimable(2), 1_736_111 ether + 111111111111111111);
        manager.claim(2);
        assertEq(token.balanceOf(beneficiaries[2]), 1_736_111 ether + 111111111111111111);
        assertEq(manager.claimable(2), 0);
        vm.warp(block.timestamp + 30 days);
        assertEq(manager.claimable(2), 1_736_111 ether + 111111111111111111);
        manager.claim(2);
        assertEq(token.balanceOf(beneficiaries[2]), 3_472_222 ether + 222222222222222222);
        assertEq(manager.claimable(2), 0);
        vm.warp(block.timestamp + 30 days);
        assertEq(manager.claimable(2), 1_736_111 ether + 111111111111111111);
        manager.claim(2);
        assertEq(token.balanceOf(beneficiaries[2]), 5_208_333 ether + 333333333333333333);
        assertEq(manager.claimable(2), 0);
    }
}
