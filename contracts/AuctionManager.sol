// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Auction.sol";

contract AuctionManager {
    // Mapping from owner address to list of deployed auctions
    mapping(address => Auction[]) public auctions;

    // Array to keep track of all auctions
    Auction[] public allAuctions;

    // Event logging
    event AuctionCreated(address indexed owner, Auction auction, address indexed auctionAddress);
    event BidPlaced(address indexed bidder, address indexed auction, uint256 amount);
    event AuctionEnded(address indexed owner, Auction auction);

    // Create a new auction and store it in the auctions mapping
    function createAuction(string memory _itemName, uint256 _durationMinutes, uint256 _reservedPrice, uint256 _startTimestamp) public {
        Auction newAuction = new Auction(_itemName, _durationMinutes, _reservedPrice, _startTimestamp, msg.sender);
        auctions[msg.sender].push(newAuction);
        allAuctions.push(newAuction);
        emit AuctionCreated(msg.sender, newAuction, address(newAuction));
    }

    // Get details of all auctions for a specific owner
    function getAuctions(address owner) public view returns (Auction[] memory) {
        return auctions[owner];
    }

    // End a specific auction
    function endAuction(Auction auction) public {
        //require(auction.owner() == msg.sender, "You are not the owner of this auction");
        auction.endAuction();
        emit AuctionEnded(msg.sender, auction);
    }

    // Get details of all ongoing auctions
    function getAllAuctions() public view returns (Auction[] memory) {
        return allAuctions;
    }

    // Place a bid on a specific auction
    function placeBidOnAuction(Auction auction, uint256 amount) public payable {
        // Forward the funds and call the placeBid function of the Auction contract
        // (bool success, ) = address(auction).call{value: amount}(abi.encodeWithSignature("placeBid()"));
        // require(success, "Failed to place bid");
        auction.placeBid{value: amount}(msg.sender);
        // Emit the event
        emit BidPlaced(msg.sender, address(auction), amount);
    }

    function auctionHasBidders(Auction auction) public view returns (bool) {
        return auction.hasBidders();
    }

}
