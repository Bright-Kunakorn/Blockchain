// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract PawnContract {
    address public owner;
    
    enum PawnStatus { Open, Locked, Redeemed }
    
    struct Pawn {
        address borrower;
        uint256 loanAmount;
        uint256 collateralValue;
        uint256 lockDuration; 
        uint256 startTime;
        PawnStatus status;
    }
    
    mapping (address => Pawn) public pawns;

    event PawnCreated(address indexed borrower, uint256 loanAmount, uint256 collateralValue);
    event PawnLocked(address indexed borrower);
    event PawnRedeemed(address indexed borrower, uint256 repaymentAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier pawnExists(address borrower) {
        require(pawns[borrower].borrower == borrower, "Pawn not found");
        _;
    }

    modifier pawnNotLocked(address borrower) {
        require(pawns[borrower].status != PawnStatus.Locked, "Pawn is already locked");
        _;
    }

    modifier onlyBorrower(address borrower) {
        require(msg.sender == borrower, "Not the borrower");
        _;
    }

    modifier canRedeem(address borrower) {
        require(pawns[borrower].status == PawnStatus.Locked, "Pawn is not locked");
        require(block.timestamp >= pawns[borrower].startTime + pawns[borrower].lockDuration, "Lock duration not reached");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createPawn(uint256 loanAmount, uint256 collateralValue, uint256 lockDuration) external pawnNotLocked(msg.sender) {
        pawns[msg.sender] = Pawn({
            borrower: msg.sender,
            loanAmount: loanAmount,
            collateralValue: collateralValue,
            lockDuration: lockDuration,
            startTime: 0,
            status: PawnStatus.Open
        });

        emit PawnCreated(msg.sender, loanAmount, collateralValue);
    }

    function lockPawn() external onlyBorrower(msg.sender) pawnNotLocked(msg.sender) {
        pawns[msg.sender].startTime = block.timestamp;
        pawns[msg.sender].status = PawnStatus.Locked;

        emit PawnLocked(msg.sender);
    }

    function redeemPawn() external onlyBorrower(msg.sender) canRedeem(msg.sender) {
        uint256 repaymentAmount = pawns[msg.sender].loanAmount + pawns[msg.sender].collateralValue;

        delete pawns[msg.sender];

        emit PawnRedeemed(msg.sender, repaymentAmount);
    }

}
