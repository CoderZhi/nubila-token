// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract NubilaNetwork is ERC20 {
    constructor(address owner) ERC20("Nubila Network", "NUBI") {
        require(owner != address(0), "owner address is zero");
        _mint(owner, 1_000_000_000 ether);
    }
}
