// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HashHolder{
    struct HashDetails {
        string primaryKey;
        string hash;
    }

    event HashUpdated(string tableName, string primaryKey, string hash);
    mapping(string => HashDetails) private latestHashes;

    function setLatestHash(string memory tableName, string memory hash, string memory primaryKey) public {
        latestHashes[tableName] = HashDetails(primaryKey, hash);
        emit HashUpdated(tableName, primaryKey, hash);
    }

    function setMultipleLatestHashes(string[] memory tableNames, string[] memory hashes, string[] memory primaryKeys) public {
        require(tableNames.length == hashes.length && hashes.length == primaryKeys.length, "Input arrays must be of the same length");

        for (uint i = 0; i < tableNames.length; i++) {
            latestHashes[tableNames[i]] = HashDetails(primaryKeys[i], hashes[i]);
            emit HashUpdated(tableNames[i], primaryKeys[i], hashes[i]);
        }
    }

    function getLatestHash(string memory tableName) public view returns (string memory, string memory) {
        HashDetails memory details = latestHashes[tableName];
        return (details.primaryKey, details.hash);
    }

    // haoming solution
    //string public borrowerPK;
    //string public clientPK;

    // latestHashes[tableName][primaryKey] = hash;
        // if(tableName=="borrower")
        // {
        //     borrowerPK = primaryKey;
        // } else if (tableName=="client") {
        //     clientPK = primaryKey;
        // }

    // haoming solution

    // string public borrower;
    // string public client;
    // string public application;
    // string public investedNote;
    // string public lender;

    // // Setters
    // function setBorrower(string memory _borrower) public {
    //     borrower = _borrower;
    // }

    // function setClient(string memory _client) public {
    //     client = _client;
    // }

    // function setApplication(string memory _application) public {
    //     application = _application;
    // }

    // function setInvestedNote(string memory _investedNote) public {
    //     investedNote = _investedNote;
    // }

    // function setLender(string memory _lender) public {
    //     lender = _lender;
    // }
    
}