// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    IERC20 public tokenA;
    address public ownerA;
    uint public amountA;
    IERC20 public tokenB;
    address public ownerB;
    uint public amountB;

    constructor(address _tokenA,address _ownerA, uint _amountA,address _tokenB,address _ownerB, uint _amountB) {
                tokenA = IERC20(_tokenA);
                ownerA = _ownerA;
                amountA = _amountA;
                tokenB = IERC20(_tokenB);
                ownerB = _ownerB;
                amountB = _amountB;
    }

    function swap() public {
        require(msg.sender == ownerA || msg.sender == ownerB, "Not authorized");
        require(
            tokenA.allowance(ownerA, address(this)) >= amountA,
            "Token 1 allowance too low"
        );
        require(
            tokenB.allowance(ownerB, address(this)) >= amountB,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(tokenA, ownerA, ownerB, amountA);
        _safeTransferFrom(tokenB, ownerB, ownerA, amountB);
    }

    function _safeTransferFrom( IERC20 token,  address sender, address receiver,   uint amount) private {
        bool sent = token.transferFrom(sender, receiver, amount);
        require(sent, "Token transfer failed");
    }
}
