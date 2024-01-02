// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { OFTCore } from "./OFTCore.sol";

contract OFT is OFTCore, ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        address _lzEndpoint,
        address _owner
    ) ERC20(_name, _symbol) OFTCore(decimals(), _lzEndpoint, _owner) {}

    // @dev major indicates they shared a compatible msg payload format and CAN communicate between one another
    // @dev minor indicates a varying version, eg. OFTAdapter vs. OFT
    function oftVersion() external pure returns (uint64 major, uint64 minor) {
        return (1, 1);
    }

    function token() external view virtual returns (address) {
        return address(this);
    }

    // @dev burn the tokens from the users specified balance
    function _debitSender(
        uint256 _amountToSendLD,
        uint256 _minAmountToReceiveLD,
        uint32 _dstEid
    ) internal virtual override returns (uint256 amountDebitedLD, uint256 amountToCreditLD) {
        (amountDebitedLD, amountToCreditLD) = _debitView(_amountToSendLD, _minAmountToReceiveLD, _dstEid);

        _burn(msg.sender, amountDebitedLD);
    }

    // @dev burn the tokens that someone has sent into this contract in a push method
    // @dev allows anyone to send tokens that have been sent to this contract
    // @dev similar to how you can push tokens to the endpoint to pay the msg fee, vs the endpoint needing approval
    function _debitThis(
        uint256 _minAmountToReceiveLD,
        uint32 _dstEid
    ) internal virtual override returns (uint256 amountDebitedLD, uint256 amountToCreditLD) {
        (amountDebitedLD, amountToCreditLD) = _debitView(balanceOf(address(this)), _minAmountToReceiveLD, _dstEid);

        _burn(address(this), amountDebitedLD);
    }

    function _credit(
        address _to,
        uint256 _amountToCreditLD,
        uint32 /*_srcEid*/
    ) internal virtual override returns (uint256 amountReceivedLD) {
        _mint(_to, _amountToCreditLD);
        return _amountToCreditLD;
    }
}