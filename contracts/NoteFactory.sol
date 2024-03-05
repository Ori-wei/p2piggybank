// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvestmentNote.sol";
import "../node_modules/@ganache/console.log/console.sol";

contract NoteFactory{
    // Array to keep track of all notes
    mapping(address => InvestmentNote[]) public notes;
    InvestmentNote[] public allNotes;

    // Event logging
    event NoteCreated(address indexed owner, address indexed noteAddress, uint256 listedEndDate, uint256 Duration, uint256 financingAmt, uint256 repaymentDate, uint256 repaymentAmt);
    event noteInvested(address investor, address note, uint256 amount, uint256 fundedToDate, uint256 updatedlistedEndDate, uint256 updatedRepaymentDate);
    event fundsDisbursed(uint256 amountToDisburse);
    event refunded(address indexed owner, address note, uint256 fundedToDate);
    event fundRepaid(address indexed owner, address note, uint256 repayAmt);

    // Create a new investmentNote and store it in the array
    function createNote(
        uint256 _financingAmt,
        uint256 _Duration,
        uint256 _repaymentAmt,
        uint256 _interestRate
    ) public{
        InvestmentNote newNote = new InvestmentNote (msg.sender, _financingAmt, _Duration, _repaymentAmt, _interestRate);

        // Store the investmentNote in sender's list of notes and the overall list
        notes[msg.sender].push(newNote);
        allNotes.push(newNote);

        // Emit an event with the relevant info
        emit NoteCreated(
            msg.sender, 
            address(newNote),
            newNote.listedEndDate(),
            newNote.Duration(),
            newNote.financingAmt(),
            newNote.repaymentDate(),
            newNote.repaymentAmt()
        );
        
    }

    // Invest on a specific investmentnote
    function investOnNote(InvestmentNote investmentNote, uint256 amount) public payable {
        console.log("note factory function triggered");
        
        (uint256 updatedFundedToDate, uint256 updatedlistedEndDate, uint256 updatedRepaymentDate, bool disbursed) 
        = investmentNote.invest{value: amount}(msg.sender);

        console.log("call funded event");

        emit noteInvested(msg.sender, address(investmentNote), amount, 
        updatedFundedToDate, updatedlistedEndDate, updatedRepaymentDate);

        // Check if disburse was called
        console.log("call disburse event");
        if (disbursed) {
            emit fundsDisbursed(updatedFundedToDate);
        }
    }

    function refundToInvestors(InvestmentNote investmentNote, uint256 fundedToDate) public payable{
        console.log("repay factory function triggered");
        investmentNote.refund{value: fundedToDate}();
        console.log("emit event");
        emit refunded(msg.sender, address(investmentNote), fundedToDate);
        console.log("event emitted");
    }

    function repayFund(InvestmentNote investmentNote, uint256 repayAmt) public payable{
        console.log("repay factory function triggered");
        investmentNote.repay{value: repayAmt}();
        console.log("emit event");
        emit fundRepaid(msg.sender, address(investmentNote), repayAmt);
        console.log("event emitted");
    }
}