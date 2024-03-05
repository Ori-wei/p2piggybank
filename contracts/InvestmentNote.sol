// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

import "../node_modules/@ganache/console.log/console.sol";

contract InvestmentNote {
    address public borrowerAddress;
    uint256 public listedDate;
    uint256 public listedEndDate;
    uint256 public financingAmt;
    uint256 public fundedToDate;
    uint256 public Duration;
    uint256 public repaymentDate;
    uint256 public repaymentAmt;
    uint256 public interestRate;
    
    // New mapping to keep track of all investors and their investments
    mapping(address => uint256) public investments;
    address[] public investors;

    //uint constant SECONDS_PER_DAY = 24 * 60 * 60; // 86400
    //uint constant DAYS_PER_MONTH = 30; // Approximation

    // Constructor for creating an investmentNote
    constructor(
        address _borrowerAddress,
        uint256 _financingAmt,
        uint256 _Duration,
        uint256 _repaymentAmt,
        uint256 _interestRate
    ) {
        borrowerAddress = _borrowerAddress;
        listedDate = block.timestamp;
        listedEndDate = listedDate + 5 minutes;
        financingAmt = _financingAmt;
        fundedToDate = 0;
        Duration = _Duration * 60;
        repaymentDate = listedEndDate + Duration;
        repaymentAmt = _repaymentAmt;
        interestRate = _interestRate / 100;
    }

    // Event logging
    event loanRepaid(address borrowerAddress, uint256 repaymentAmt);
    event fundSufficiencyChecked();
    event reminderSent(address borrowerAddress);

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
    

    modifier onlyBeforeEnd() {
        require(block.timestamp < listedEndDate, "The note has ended listing");
        _;
    }

    // Modify existing functions to check for start time
    modifier onlyAfterStart() {
        require(block.timestamp >= listedDate, "The note has not listed yet");
        _;
    }

    function invest(address investor) public payable onlyAfterStart onlyBeforeEnd returns (uint256, uint256, uint256, bool) {
        console.log("invest function triggered");
        bool disbursed = false;

        // Ensure the invested amount does not exceed financingAmt
        require(msg.value <= (financingAmt - fundedToDate), "Investment amount must not exceed financing amount");

        console.log("update investor and the investments");
        investments[investor] += msg.value;
        investors.push(investor);
        
        console.log("update funded to date");
        fundedToDate += msg.value;

        // Check if funding is complete
        if (fundedToDate == financingAmt) {
            listedEndDate = block.timestamp;
            repaymentDate = listedEndDate + Duration;
            fundedToDate = disburse(); // trigger disburse function
            disbursed = true;
        }

        return (fundedToDate, listedEndDate, repaymentDate, disbursed);
    }

    function disburse() internal returns (uint256) {
        console.log("disburse method triggered.");
        require(fundedToDate >= financingAmt, "Funding goal not reached.");
        console.log("condition pass");

        console.log("transfer start");
        payable(borrowerAddress).transfer(fundedToDate);
        console.log("transfer end, return value");
        return fundedToDate;
    }

    function refund() public payable{
        uint256 refundAmt = msg.value;

        // Ensure the contract has enough balance to cover all refunds
        require(address(this).balance >= refundAmt, "Contract does not have enough funds to refund");

        for (uint i = 0; i < investors.length; i++) {
            uint256 investorRefund = investments[investors[i]];
            payable(investors[i]).transfer(investorRefund);
        }
    }

    // =======================================================
    // =================== repayment stage ===================
    // =======================================================

    function repay() public payable {
        console.log("Repay function triggered");
        uint256 repayAmt = msg.value;
        console.log("value passed to repayAmt");

        // Ensure the contract has enough balance to cover the repayment
        require(address(this).balance >= repayAmt, "Contract does not have enough funds to repay");
        console.log("balance check passed");

        uint256 totalPaidToInvestors = 0;

        for (uint i = 0; i < investors.length; i++) {
            // Calculate each investor's share of the total investment
            uint256 investorShare = investments[investors[i]] * repayAmt / financingAmt;
            totalPaidToInvestors += investorShare;
            payable(investors[i]).transfer(investorShare);
        }
        console.log("repaid done");

        // Calculate remaining amount after paying investors
        //int256 remainingAmount = int256(repayAmt) - int256(totalPaidToInvestors) - 4600;
        int256 remainingAmount = int256(address(this).balance);

        if (remainingAmount > 0) {
            if (block.timestamp <= repaymentDate) {
                payable(borrowerAddress).transfer(uint256(remainingAmount));
                console.log("return collateral");
            }
            else{
                console.log("late repayment, collateral will not be returned");
            }
        }
        else{
            console.log("no more balance to return collateral");
        }
    }


    // function repay() public payable {
    //     console.log("Repay function triggered");
    //     uint256 repayAmt = msg.value;
    //     console.log("value passed to repayAmt");

    //     // Ensure the contract has enough balance to cover the repayment
    //     require(address(this).balance >= repayAmt, "Contract does not have enough funds to repay");
    //     console.log("balance check passed");

    //     uint256 totalPaidToInvestors = 0;
    //     uint256 totalRepayAmount = repayAmt > repaymentAmt ? repayAmt : repaymentAmt;

    //     for (uint i = 0; i < investors.length; i++) {
    //         // Calculate each investor's share of the total investment, accounting for potential extra repayment
    //         uint256 investorShare = investments[investors[i]] * totalRepayAmount / financingAmt;
    //         totalPaidToInvestors += investorShare;
    //         payable(investors[i]).transfer(investorShare);
    //     }
    //     console.log("repaid done");

    //     // Check if there's any remaining balance and transfer it to the borrower
    //     // Only if repayAmt is exactly equal to repaymentAmt
    //     if (repayAmt == repaymentAmt) {
    //         uint256 remainingBalance = address(this).balance - totalPaidToInvestors;
    //         if (remainingBalance > 0) {
    //             payable(borrowerAddress).transfer(remainingBalance);
    //             console.log("Remaining balance transferred to borrower");
    //         }
    //     }
    // }


    // function repay() public payable{
    //     console.log("Repay function triggered");
    //     uint256 repayAmt = msg.value;
    //     console.log("value passed to repayAmt");
    //     // Ensure the contract has enough balance to cover the repayment
    //     require(address(this).balance >= repayAmt, "Contract does not have enough funds to repay");
    //     console.log("balance check passed");
    //     for (uint i = 0; i < investors.length; i++) {
    //         // Calculate each investor's share of the total investment
    //         uint256 investorShare = investments[investors[i]] * repayAmt / financingAmt;
    //         payable(investors[i]).transfer(investorShare);
    //     }
    //     console.log("repaid done");
    // }
}
