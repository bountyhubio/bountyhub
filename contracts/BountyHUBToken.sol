pragma solidity ^0.4.25;

import "./token/TRC20/TRC20Capped.sol";
import "./token/TRC20/TRC20Detailed.sol";
import "./ownership/Ownable.sol";

/**
 * @title SimpleToken
 * @dev Very simple TRC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 */
contract BountyHUBToken is TRC20Capped, TRC20Detailed, Ownable {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor (string name, string symbol, uint8 decimals, uint256 cap) public
        TRC20Detailed(name, symbol, decimals)
        TRC20Capped(cap * (10 ** uint256(decimals))) {
    }
}
