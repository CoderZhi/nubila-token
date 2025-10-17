// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract NubilaNetwork is ERC20 {
    constructor(address init) ERC20("Nubila Network", "NB") {
        require(init != address(0), "init address is zero");
        _mint(init, 1_000_000_000 ether);
    }
}
