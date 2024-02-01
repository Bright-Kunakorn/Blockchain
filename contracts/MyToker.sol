// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is Ownable {
    using SafeMath for uint256;

    ERC20 public collateralToken; 
    ERC20 public stablecoinToken;

    struct DeptCollateralRatio {
        uint256 dept;
        uint256 collateral;
    }

    mapping(address => DeptCollateralRatio) public deptCollateralRatios;

    event PositionOpened(address indexed borrower, uint256 deptAmount, uint256 collateralAmount);
    event PositionClosed(address indexed borrower, uint256 deptAmount, uint256 collateralAmount);
    event PositionLiquidated(address indexed borrower, uint256 collateralAmount);

    constructor(address _collateralTokenAddress, address _stablecoinTokenAddress, address _initialOwner) Ownable(_initialOwner) {
        collateralToken = ERC20(_collateralTokenAddress);
        stablecoinToken = ERC20(_stablecoinTokenAddress);
    }

   function _burn(ERC20 token, uint256 value) internal {
        address burner = address(this);
        token.transfer(burner, value);
    }

    function closePosition(uint256 deptAmount, uint256 collateralAmount) external {
        stablecoinToken.transferFrom(msg.sender, address(this), deptAmount);
        _burn(stablecoinToken, deptAmount);
        collateralToken.transfer(msg.sender, collateralAmount);
        deptCollateralRatios[msg.sender].dept = deptCollateralRatios[msg.sender].dept.sub(deptAmount);
        deptCollateralRatios[msg.sender].collateral = deptCollateralRatios[msg.sender].collateral.sub(collateralAmount);
        emit PositionClosed(msg.sender, deptAmount, collateralAmount);
    }

    function getRatio(address borrower) public view returns (uint256) {
        if (deptCollateralRatios[borrower].collateral == 0) {
            return 0;
        }
        return (deptCollateralRatios[borrower].dept * 100) / deptCollateralRatios[borrower].collateral;
    }
}
