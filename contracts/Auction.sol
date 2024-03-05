// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public owner;
    uint256 public auctionEndTime;
    uint256 public auctionStartTime;
    string public itemName;
    uint256 public highestBid;
    address public highestBidder;
    bool public auctionEnded;
    uint256 public reservedPrice;

    //event
    event Refund(address bidder, uint256 amount);

    // New mapping to keep track of all bidders and their bids
    mapping(address => uint256) public bids;
    address[] public bidders;

    constructor(string memory _itemName, uint256 _durationMinutes, uint256 _reservedPrice, uint256 _startTimestamp, address _owner) {
        owner = _owner == address(0) ? msg.sender : _owner;
        auctionStartTime = _startTimestamp;
        auctionEndTime = _startTimestamp + (_durationMinutes * 1 minutes);
        itemName = _itemName;
        reservedPrice = _reservedPrice; // Initialize reserved price
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    // Function to retrieve the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    modifier notOwner() {
        require(msg.sender != owner, "Owner cannot place a bid");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyBeforeEnd() {
        require(!auctionEnded, "Auction has already ended");
        require(block.timestamp < auctionEndTime, "Auction has ended");
        _;
    }

    // Modify existing functions to check for start time
    modifier onlyAfterStart() {
        require(block.timestamp >= auctionStartTime, "Auction has not started yet");
        _;
    }

    modifier onlyAfterEnd() {
        require(auctionEnded || block.timestamp >= auctionEndTime, "Auction is still ongoing");
        _;
    }

    function placeBid(address bidder) public payable onlyAfterStart onlyBeforeEnd notOwner {
        require(msg.value > reservedPrice, "Bid must be higher than the reserved price.");

        // if (highestBidder != address(0)) {
        //     // Refund the previous highest bidder
        //     payable(highestBidder).transfer(highestBid);
        // }

        //bids[msg.sender] += msg.value;  // Add bid to sender's total
        //bidders.push(msg.sender);  // Add sender to bidders array
        // Check if it's a new highest bid
        // if (bids[msg.sender] > highestBid) {
        //     highestBid = bids[msg.sender];
        //     highestBidder = msg.sender;
        // }
        bids[bidder] += msg.value;
        bidders.push(bidder);       
        
        if (bids[bidder] > highestBid) {
            highestBid = bids[bidder];
            highestBidder = bidder;
        }
        // highestBid = msg.value;
        // highestBidder = msg.sender;
    }

    // Function to end the auction and disperse funds
    function endAuction() public {
        require(!auctionEnded, "Auction has already ended");
        auctionEnded = true;
        // Disperse funds to non-winning bidders
        for (uint i = 0; i < bidders.length; i++) {
            if (bidders[i] != highestBidder) {
                uint256 refundAmount = bids[bidders[i]];
                payable(bidders[i]).transfer(refundAmount);
                emit Refund(bidders[i], refundAmount); // Diagnostic event
            }
        }
        // if (highestBidder != address(0)) {
        //     // Transfer the item to the highest bidder
        //     // You can implement your item transfer logic here
        // }
    }

    function hasBidders() public view returns (bool) {
        return bidders.length > 0;
    }

    function getBidderByIndex(uint index) public view returns (address) {
        require(index < bidders.length, "Index out of bounds");
        return bidders[index];
    }

    function getNumberOfBidders() public view returns (uint) {
        return bidders.length;
    }

    function getAuctionDetails() public view returns (
        string memory,
        address,
        uint256,
        uint256,
        uint256,
        address,
        bool
    ) {
        return (itemName, owner, auctionStartTime, auctionEndTime, highestBid, highestBidder, auctionEnded);
    }
}