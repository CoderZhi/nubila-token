// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NubilaNetwork} from "../src/NubilaNetwork.sol";
import {VestingManager} from "../src/VestingManager.sol";
contract NubilaNetworkScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        uint256 tge = uint256(vm.envUint("TGE"));
        console.log("TGE read from env:", tge);
        NubilaNetwork nubilaNetwork = new NubilaNetwork(msg.sender);
        console.log("NubilaNetwork deployed to:", address(nubilaNetwork));
        address[] memory beneficiaries = new address[](12);
        for (uint256 i = 0; i < 12; i++) {
            beneficiaries[i] = msg.sender;
        }
        VestingManager vestingManager = new VestingManager(address(nubilaNetwork), tge, beneficiaries);
        console.log("VestingManager deployed to:", address(vestingManager));
        vm.assertTrue(nubilaNetwork.transfer(address(vestingManager), nubilaNetwork.balanceOf(msg.sender)));

        vm.stopBroadcast();
    }
}
