const InvestmentNote = artifacts.require("InvestmentNote");

module.exports = function (deployer, network, accounts) {
    deployer.deploy(
        InvestmentNote,
        accounts[0], // borrowerAddress, assuming the first account is the borrower
        web3.utils.toWei('0.1', 'ether'), // financingAmt, adjust as needed
        60, // Duration in days or blocks as per your contract logic
        web3.utils.toWei('0.2', 'ether'), // repaymentAmt, adjust as needed
        900 // interestRate, e.g., 9%, adjust as needed
    );
};
