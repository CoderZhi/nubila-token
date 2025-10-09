// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NubilaNetwork is ERC20 {
    constructor(address vestingManager) ERC20("Nubila Network", "NUBI") {
        require(vestingManager != address(0), "vesting manager address is zero");
        _mint(vestingManager, 1_000_000_000 ether);
    }
}
