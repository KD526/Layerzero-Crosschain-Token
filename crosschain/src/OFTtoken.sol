// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OFT} from "@layerzerolabs/solidity-examples/contracts/token/oft/v1/OFT.sol";

contract APEToken is OFT {
    constructor(
        string memory _name, // token name
        string memory _symbol, // token symbol
        address _lzEndpoint // LayerZero Endpoint address
    ) OFT(_name, _symbol, _lzEndpoint) {
        // your contract logic here
        _mint(_msgSender(), 100 * 10 * decimals()); // mints 100 tokens to the deployer
    }
}