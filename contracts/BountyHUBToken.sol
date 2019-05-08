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
    string private constant NAME = "BountyHUB Token";
    string private constant SYMBOL = "BHT";
    uint8 private constant DECIMALS = 18;
    uint256 private constant CAP = 1000000000 * (10 ** uint256(DECIMALS));

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor () public
        TRC20Detailed(NAME, SYMBOL, DECIMALS)
        TRC20Capped(CAP) {
    }
}
