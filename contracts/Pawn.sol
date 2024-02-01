// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

struct collateral {
    uint amount;
    uint ratio;
    bool cannotborrow;
}

contract Borrow {
    mapping (address => collateral) _collateralAsset;
    mapping (address => uint) _borrow;


    function borrow(uint collateralOver) public payable{
        require(_collateralAsset[msg.sender].cannotborrow == false, "you must be return asset that borrow first");
        require(collateralOver >= 150 && collateralOver <= 300, "require collateral between 150 and 300%.");
        require(msg.value >= 100000000000000000, "Ether must greater than equal 0.1");

        _collateralAsset[msg.sender] = collateral(msg.value, 100*(10**2)/collateralOver, true);
        uint borrowAmount = (_collateralAsset[msg.sender].amount * _collateralAsset[msg.sender].ratio) / (10**2);
        _borrow[msg.sender] = borrowAmount;
        payable(msg.sender).transfer(_borrow[msg.sender]);
    }

    function closePosition() external payable{
        require(_borrow[msg.sender] == msg.value, "Repayment amount must be equal your loan");

        payable(msg.sender).transfer(_collateralAsset[msg.sender].amount);
        _collateralAsset[msg.sender].amount = 0;
        _collateralAsset[msg.sender].ratio = 0;
        _collateralAsset[msg.sender].cannotborrow = false;
       
    }
}