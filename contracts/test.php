<!DOCTYPE html>
<html>
<head>
  <title>Web3.js Wallet Sign-In and Account Balance Example</title>
  <script src="https://cdn.jsdelivr.net/npm/web3@1.5.0/dist/web3.min.js"></script>
</head>
<body>

  <h1>Welcome to My DApp</h1>
  
  <button onclick="signIn()">Sign In with Ethereum Wallet</button>
  <button onclick="fetchAccountAndBalance()">Fetch Account and Balance</button>
  <button onclick="createAuction()">Create Auction</button>
  <button onclick="placeBid()">Place Bid</button>
  <button onclick="endAuction()">End Auction</button>
  <button onclick="getAuctionDetails()">Get Auction Details</button>
  <button onclick="fetchMyAuctions()">Fetch My Auctions</button> 
  <button onclick="endMyAuction()">End My Auction</button> 
  <button onclick="fetchAllAuctions()">Fetch All Ongoing Auctions</button>
  <button onclick="placeBidOnAuction()">Place Bid on Specific Auction</button>
  <button onclick="sendEth()"> Send Eth </button>
  <button onclick="endAuction()"> End Auction </button>
  <button onclick="getContractBalanceDirect()"> Get Contract Balance Direct </button>
  <button onclick="checkIfAuctionHasBidders()"> Check If Auction Has Bidders </button>
  <button onclick="listBidders()"> List All Bidders in a Auction </button>

  <div id="accountInfo"></div>
  <div id="auctionInfo"></div>
  <div id="myAuctionsInfo"></div>
  <div id="allAuctionsInfo"></div>

  <script>
    let web3 = new Web3(window.ethereum);
    let auctionContract, auctionManagerContract; // Declare the contract variable here

    // Fetch contract data and initialize AuctionManager contract
    function fetchAuctionManagerContractData() {
      fetch('../build/contracts/AuctionManager.json')
        .then(function(response) {
          return response.json();
        })
        .then(function(data) {
          const abi = data.abi;
          const networkId = '5777'; // Replace with the network ID you're using
          const contractAddress = data.networks[networkId].address;

          // Initialize the contract
          auctionManagerContract = new web3.eth.Contract(abi, contractAddress);
          
          // Debug logs
          console.log("ABI:", abi);
          console.log("Contract Address:", contractAddress);
          console.log(auctionManagerContract.methods);
        })
        .catch(function(error) {
          console.error('Error fetching contract data:', error);
        });
    }    

    // Fetch contract data and initialize Auction contract
    function fetchAuctionContractData() {
      fetch('../build/contracts/Auction.json')
        .then(function(response) {
          return response.json();
        })
        .then(function(data) {
          const abi = data.abi;
          const networkId = '5777'; // Replace with the network ID you're using
          const contractAddress = data.networks[networkId].address;

          // Initialize the contract
          auctionContract = new web3.eth.Contract(abi, contractAddress);
          
          // Debug logs
          console.log("ABI:", abi);
          console.log("Contract Address:", contractAddress);
          console.log(auctionContract.methods);
        })
        .catch(function(error) {
          console.error('Error fetching contract data:', error);
        });
    }

    // Call the function to fetch contract data
    fetchAuctionContractData();
    fetchAuctionManagerContractData();
    
    const message = "Please sign this message to confirm your identity.";

    async function requestAccount() {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      return accounts[0];
    }

    async function signIn() {
      try {
        const account = await requestAccount();
        const signature = await web3.eth.personal.sign(message, account, '');

        const isVerified = await verifySignature(account, signature);
        if (isVerified) {
          alert('Successfully signed in!');
        } else {
          alert('Failed to sign in!');
        }
      } catch (error) {
        console.error(error);
        alert('Error signing in: ' + error.message);
      }
    }

    async function fetchAccountAndBalance() {
      try {
        const account = await requestAccount();
        const balanceWei = await web3.eth.getBalance(account);
        const balanceEther = web3.utils.fromWei(balanceWei, 'ether');

        const accountInfo = `Connected account: ${account}<br>Balance: ${balanceEther} ETH`;
        document.getElementById('accountInfo').innerHTML = accountInfo;
      } catch (error) {
        console.error(error);
        alert('Error fetching account and balance: ' + error.message);
      }
    }

    async function verifySignature(account, signature) {
      const signer = await web3.eth.personal.ecRecover(message, signature);
      return signer.toLowerCase() === account.toLowerCase();
    }

    async function createAuction() {
      try {
        const account = await requestAccount();
        // Create a date object in local time (UTC+8)
        //const localStartTime = new Date('2023-12-05T23:10:15');
        const utcStartTime = new Date('2023-12-05T23:49:15');
        
        // Convert local time to UTC time
        //const utcStartTime = new Date(localStartTime.getTime() - (localStartTime.getTimezoneOffset() * 60000));

        // Get the Unix timestamp (in seconds)
        const startTime = Math.floor(utcStartTime.getTime() / 1000);
        
        // Check if contract and method exist
        if (auctionManagerContract && auctionManagerContract.methods['createAuction']) {
          const weiReservedPrice = web3.utils.toWei('4.12', 'ether');
          const receipt = await auctionManagerContract.methods.createAuction("Test Auction 1", 10, weiReservedPrice, startTime).send({ from: account }); //param: itemname, duration(mins), reserved price 
          const auctionCreatedEvent = receipt.events.AuctionCreated;
          if (auctionCreatedEvent) {
              const newAuctionAddress = auctionCreatedEvent.returnValues.auctionAddress;
              console.log("New Auction Contract Address:", newAuctionAddress);
              alert('Auction created successfully at address: ' + newAuctionAddress);
          } else {
              alert('Auction created, but address not found in events.');
          }
        } else {
            alert('Contract is not initialized or createAuction method does not exist');
        }
      } catch (error) {
          console.error(error);
          alert('Error creating auction: ' + error.message);
      }
    }

    async function placeBid() {
      try {
        const account = await requestAccount();
        await auctionContract.methods.placeBid().send({ from: account, value: web3.utils.toWei("1", "ether") });
        alert('Bid placed successfully!');
      } catch (error) {
        console.error(error);
        alert('Error placing bid: ' + error.message);
      }
    }

    async function endAuction() {
      try {
        const account = await requestAccount();
        await auctionContract.methods.endAuction().send({ from: account });
        alert('Auction ended successfully!');
      } catch (error) {
        console.error(error);
        alert('Error ending auction: ' + error.message);
      }
    }

    async function getAuctionDetails() {
      try {
        const details = await auctionContract.methods.getAuctionDetails().call();
        const auctionInfo = `Item Name: ${details[0]}<br>Owner: ${details[1]}<br>Start Time: ${details[2]}<br>End Time: ${details[3]}<br>Highest Bid: ${details[4]}<br>Highest Bidder: ${details[5]}<br>Auction Ended: ${details[6]}`;
        document.getElementById('auctionInfo').innerHTML = auctionInfo;
      } catch (error) {
        console.error(error);
        alert('Error fetching auction details: ' + error.message);
      }
    }

    // Fetch all auctions for the logged-in user
    async function fetchMyAuctions() {
      try {
        const account = await requestAccount();
        const myAuctions = await auctionManagerContract.methods.getAuctions(account).call();
        let myAuctionsInfo = "My Auctions:<br>";
        myAuctions.forEach((auction, index) => {
          myAuctionsInfo += `Auction ${index + 1}: ${auction}<br>`;
        });
        document.getElementById('myAuctionsInfo').innerHTML = myAuctionsInfo; // Display in new div
      } catch (error) {
        console.error(error);
        alert('Error fetching my auctions: ' + error.message);
      }
    }

    // Fetch all ongoing auctions
    async function fetchAllAuctions() {
      try {
        const allAuctions = await auctionManagerContract.methods.getAllAuctions().call();
        let allAuctionsInfo = "All Ongoing Auctions:<br>";
        allAuctions.forEach((auction, index) => {
          allAuctionsInfo += `Auction ${index + 1}: ${auction}<br>`;
        });
        document.getElementById('allAuctionsInfo').innerHTML = allAuctionsInfo; // Display in new div
      } catch (error) {
        console.error(error);
        alert('Error fetching all auctions: ' + error.message);
      }
    }

    // End a specific auction
    async function endMyAuction() {
      try {
        const account = await requestAccount();
        const auctionAddress = prompt("Enter the auction address you want to end:"); // Get auction address from user
        
        const gasLimit = web3.utils.toHex(3000000); // Example gas limit
        const gasPrice = web3.utils.toHex(web3.utils.toWei('10', 'gwei')); // Example gas price

        // Initialize the specific Auction contract instance
        const specificAuctionContract = new web3.eth.Contract(auctionContract.options.jsonInterface, auctionAddress);
        
        // Call endAuction() on the specific Auction contract
        //uncomment this: const receipt = await specificAuctionContract.methods.endAuction().send({ from: account });
        const receipt = await specificAuctionContract.methods.endAuction().send({
            from: account,
            gas: gasLimit,
            gasPrice: gasPrice
        });
        //const receipt = await auctionManagerContract.methods.endAuction(auctionAddress).send({ from: account });

        const transactionHash = receipt.transactionHash;
        console.log("Transaction Hash:", transactionHash);
        console.log("Receipt:", receipt);

        //await auctionManagerContract.methods.endAuction(auctionAddress).send({ from: account });
        //await auctionContract.methods.endAuction(auctionAddress).send({ from: account });
        alert('Auction ended successfully!');
      } catch (error) {
        console.error(error);
        alert('Error ending auction: ' + error.message);
      }
    }

    // Place a bid on a specific auction
    async function placeBidOnAuction() {
      try {
        const account = await requestAccount();

        //mine empty block
        await mineCurrentTimestampBlock();

        const auctionAddress = prompt("Enter the auction address you want to bid on:"); // Get auction address from user
        const bidAmount = prompt("Enter the amount you want to bid (in ETH):"); // Get bid amount from user

        // Initialize the specific Auction contract instance
        const specificAuctionContract = new web3.eth.Contract(auctionContract.options.jsonInterface, auctionAddress);
        
        // Call placeBid() on the specific Auction contract and get receipt
        const receipt = await specificAuctionContract.methods.placeBid().send({ from: account, value: web3.utils.toWei(bidAmount, "ether") });
        
        //check tx receipt
        console.log("Transaction Receipt:", receipt);
        alert('Bid placed successfully!');
      } catch (error) {
        console.error(error);
        alert('Error placing bid: ' + error.message);
      }
    }
    
    async function mineCurrentTimestampBlock() {
      try {
        await web3.currentProvider.sendAsync({
            method: "evm_mine",
            params: [],
            jsonrpc: "2.0",
            id: new Date().getTime()
        });
        console.log("Block mined");
    } catch (err) {
        console.error("Error mining block: ", err);
    }
  }

  async function sendEth() {
      const toAddress = "0x8BeF62afA592ABEe1B219c320ddA38D66836fEE0";
      const amount = "1";
      const amountInWei = web3.utils.toWei(amount, 'ether');

      const accounts = await web3.eth.getAccounts();
      const transaction = {
        from: accounts[0],
        to: toAddress,
        value: amountInWei,
        gas: 100000,       // Standard gas limit for ETH transfer
        gasPrice: web3.utils.toWei('10', 'gwei') // Example gas price in 'gwei'
    };

      try {
        const txReceipt = await web3.eth.sendTransaction(transaction);
        console.log('Transaction receipt:', txReceipt);
      } catch (error) {
        console.error(error);
      }
  }

  // Function to end the auction
  async function endAuction() {
    
      try {
          
        const account = await requestAccount();
        // // Initialize the specific Auction contract instance
        // //const specificAuctionContract = new web3.eth.Contract(auctionContract.options.jsonInterface, auctionAddress);
        // const auctionAddress = "0xBB84c7f3d96f724c5997A9c029Dfa41F9CfeB178";
        // const specificAuctionContract = new web3.eth.Contract(auctionContract.options.jsonInterface, auctionAddress);
        // // Call endAuction() on the specific Auction contract
        // await specificAuctionContract.methods.endAuction().send({ from: account });

        const auctionAddress = "0x56f10DC6F16633F28718e88fCeCc43F9726B91b5";
        // Define the gas limit and gas price
        const gasLimit = web3.utils.toHex(3000000); // Example gas limit
        const gasPrice = web3.utils.toHex(web3.utils.toWei('10', 'gwei')); // Example gas price

        const receipt = await auctionManagerContract.methods.endAuction(auctionAddress).send({
            from: account,
            gas: gasLimit,
            gasPrice: gasPrice
        });

        //const receipt = await auctionManagerContract.methods.endAuction(auctionAddress).send({ from: account });
        // Get the transaction hash
        const transactionHash = receipt.transactionHash;
        console.log("Transaction Hash:", transactionHash);
        console.log("Receipt:", receipt);

        // Process receipt to find Refund events
        for (let event of receipt.events) {
            if (event.event === 'Refund') {
                console.log(`Refund Event: ${event.returnValues.bidder} refunded ${event.returnValues.amount}`);
            }
        }

          console.log("Auction ended successfully");
      } catch (error) {
          console.error("Error ending auction:", error);
      }
  }

  async function getContractBalanceDirect() {
    try {
        const balance = await web3.eth.getBalance("0x56f10DC6F16633F28718e88fCeCc43F9726B91b5");
        console.log("Contract balance in wei:", balance);
        console.log("Contract balance in ether:", web3.utils.fromWei(balance, 'ether'));
    } catch (error) {
        console.error("Error getting contract balance:", error);
    }
}

async function checkIfAuctionHasBidders() {
    try {
            
        const account = await requestAccount();

        const auctionAddress = "0x56f10DC6F16633F28718e88fCeCc43F9726B91b5";
        // Define the gas limit and gas price

        const receipt = await auctionManagerContract.methods.auctionHasBidders(auctionAddress).call({
            from: account,
        });

        // Get the transaction hash
        const transactionHash = receipt.transactionHash;
        console.log("Transaction Hash:", transactionHash);
        console.log("Receipt:", receipt);

          console.log("Contract has bidder");
      } catch (error) {
          console.error("Error checking auction:", error);
      }
  }

  async function listBidders() {
    try {

        auctionAddress = "0x56f10DC6F16633F28718e88fCeCc43F9726B91b5";
        // Initialize the specific Auction contract instance
        const specificAuctionContract = new web3.eth.Contract(auctionContract.options.jsonInterface, auctionAddress);

        // Get the number of bidders
        const numberOfBidders = await specificAuctionContract.methods.getNumberOfBidders().call();
        console.log(`Number of bidders: ${numberOfBidders}`);

        // Iterate over the bidders and print their addresses
        for (let i = 0; i < numberOfBidders; i++) {
            const bidderAddress = await specificAuctionContract.methods.getBidderByIndex(i).call();
            console.log(`Bidder ${i}: ${bidderAddress}`);
        }
    } catch (error) {
        console.error("Error listing bidders:", error);
    }
}


  </script>

</body>
</html>