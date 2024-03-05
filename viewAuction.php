<?php
    include_once 'header.php';
    include ('dataconnection.php');
?>


<!--Body Content-->
<div id="page-content">
    	<!--Page Title-->
    	<div class="page section-header text-center">
			<div class="page-title">
        		<div class="wrapper"><h1 class="page-width">My Auctions</h1></div>
      		</div>
		</div>
        <!--End Page Title-->
        
        <div class="container">
        	<div class="row">
                <div class="col-xl-12 col-lg-12 col-md-6 col-sm-12 mb-3">
                    <div class="customer-box returning-customer">
                    <?php
                        if(isset($_SESSION["userID"])) 
                        {
                            //fetch all auctions related to active auctions (haven't start and ongoing)
                            $sql = "SELECT * from auction WHERE SellerUserID = '".$_SESSION["userID"]."' AND (CONVERT_TZ(NOW(), @@session.time_zone, '+08:00') < starttime
                            OR CONVERT_TZ(NOW(), @@session.time_zone, '+08:00') BETWEEN starttime AND endtime) AND status = 'active'"; 
                            $result = mysqli_query($connect, $sql);                            
                            echo "<h3><i class='icon anm anm-user-al'></i> Active Auctions <a class='text-white text-decoration-underline' data-toggle='collapse'></a></h3>";
                            while ($row = mysqli_fetch_assoc($result))
                            {
                            ?>
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12">
                                <div class="your-order-payment">
                                    <div class="your-order">
                                        <h2 class="order-title mb-4">Auction <?php echo $row['auctionID']; ?> [Status: <?php echo $row['status']; ?>]</h2>

                                        <div class="table-responsive-sm order-table"> 
                                            <table id="cartTable" class="bg-white table table-bordered table-hover text-center">
                                                <thead>
                                                    <tr>
                                                        <th class="text-left">Product Name</th>
                                                        <th>Front Image</th>
                                                        <th>Back Image</th>
                                                        <th>Condition</th>
                                                        <th>Description</th>
                                                        <th>Reserved Price</th>
                                                        <th>Winning Bid</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php 
                                                        $sqll = "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid FROM auction WHERE AuctionID = '".$row['AuctionID']."'";
                                                        $resultt = mysqli_query($connect, $sqll);
                                                        
                                                        while ($row2 = mysqli_fetch_assoc($resultt))
                                                        {

                                                            $prodResult = mysqli_query($connect, "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid FROM auction WHERE AuctionID = '".$row['AuctionID']."'");
                                                            $prodRow = mysqli_fetch_assoc($prodResult);
                                                    ?>
                                                    <tr>
                                                        <td class="text-left"><a href="<?php printf('%s?auctionID=%s', 'product-layout.php',  $prodRow['auctionID']); ?>"><?php echo $prodRow['ItemName'];  ?></a><input name="auction_contract_address" class="auction_contract_address" type="hidden" data-auction-id="<?php echo $prodRow['auctionID']; ?>" value="<?php echo $prodRow['auction_contract_address']; ?>"></a></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_front_image']; ?>" width="100" height="100"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_back_image']; ?>" width="100" height="100"></td>
                                                        <td><?php echo $row2['product_condition']; ?></td>
                                                        <td><?php echo $row2['description']; ?></td>
                                                        <td><?php echo $prodRow['reserved_price']; ?> ETH</td>
                                                        <td><?php echo $prodRow['highest_bid_bidid']; ?></td>
                                                    </tr>
                                                <?php } ?>
                                                </tbody>
                                                <tfoot class="font-weight-600">
                                                    <tr>
                                                        <!--
                                                        <td colspan="4" class="text-right">Shipping </td>
                                                        <td>RM 50.00</td>
                                                    </tr>
                                                        -->
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>          
                                </div>
                                <div class="order-button-payment">
                                    
                                </div>
                            </div>
                        </div>
                            <br />
                            <?php }
                            //fetch all auctions related to ended (ended. to proceed to settlement)
                            $sql = "SELECT * from auction WHERE SellerUserID = '".$_SESSION["userID"]."' AND (CONVERT_TZ(NOW(), @@session.time_zone, '+08:00') > endtime) AND status = 'active'";  
                            $result = mysqli_query($connect, $sql);
                            
                            echo "<h3><i class='icon anm anm-user-al'></i> Ended Auctions <a class='text-white text-decoration-underline' data-toggle='collapse'></a></h3>";
                            while ($row = mysqli_fetch_assoc($result))
                            {
                            ?>
                            <div>
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12">
                                <div class="your-order-payment">
                                    <div class="your-order">
                                        <h2 class="order-title mb-4">Auction <?php echo $row['auctionID']; ?> [Status: <?php echo $row['status']; ?>]</h2>

                                        <div class="table-responsive-sm order-table"> 
                                            <table id="cartTable" class="bg-white table table-bordered table-hover text-center">
                                                <thead>
                                                    <tr>
                                                        <th class="text-left">Product Name</th>
                                                        <th>Front Image</th>
                                                        <th>Back Image</th>
                                                        <th>Condition</th>
                                                        <th>Description</th>
                                                        <th>Reserved Price</th>
                                                        <th>Winning Bid</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php 
                                                        $sqll = "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid, auction_contract_address FROM auction WHERE AuctionID = '".$row['AuctionID']."'";
                                                        $resultt = mysqli_query($connect, $sqll);
                                                        
                                                        while ($row2 = mysqli_fetch_assoc($resultt))
                                                        {

                                                            $prodResult = mysqli_query($connect, "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid, auction_contract_address FROM auction WHERE AuctionID = '".$row['AuctionID']."'");
                                                            $prodRow = mysqli_fetch_assoc($prodResult);
                                                    ?>
                                                    <tr>
                                                        <td class="text-left"><a href="<?php printf('%s?auctionID=%s', 'product-layout.php',  $prodRow['auctionID']); ?>"><?php echo $prodRow['ItemName'];  ?></a><input name="auction_contract_address" class="auction_contract_address" type="hidden" data-auction-id="<?php echo $prodRow['auctionID']; ?>" value="<?php echo $prodRow['auction_contract_address']; ?>"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_front_image']; ?>" width="100" height="100"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_back_image']; ?>" width="100" height="100"></td>
                                                        <td><?php echo $row2['product_condition']; ?></td>
                                                        <td><?php echo $row2['description']; ?></td>
                                                        <td><?php echo $prodRow['reserved_price']; ?> ETH</td>
                                                        <td><?php echo $prodRow['highest_bid_bidid']; ?></td>
                                                    </tr>
                                                <?php } ?>
                                                </tbody>
                                                <tfoot class="font-weight-600">
                                                    <tr>
                                                        <!--
                                                        <td colspan="4" class="text-right">Shipping </td>
                                                        <td>RM 50.00</td>
                                                    </tr>
                                                        -->
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>          
                                </div>
                                <div class="order-button-payment">
                                    <button class="btn" value="End Auction" type="button" onclick="endAuction('<?php echo $prodRow['auctionID']; ?>');" >End Auction</button>
                                </div>
                            </div>
                        </div>
                            <br />
                            <?php }
                            //fetch all auctions related to settlement (ended. to proceed to refund and escrow)
                            $sql = "SELECT * from auction WHERE SellerUserID = '".$_SESSION["userID"]."' AND (CONVERT_TZ(NOW(), @@session.time_zone, '+08:00') > endtime) AND status = 'settlement'";  
                            $result = mysqli_query($connect, $sql);
                            
                            echo "<h3><i class='icon anm anm-user-al'></i> Settlement Auctions <a class='text-white text-decoration-underline' data-toggle='collapse'></a></h3>";
                            while ($row = mysqli_fetch_assoc($result))
                            {
                            ?>
                            <div>
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12">
                                <div class="your-order-payment">
                                    <div class="your-order">
                                        <h2 class="order-title mb-4">Auction <?php echo $row['auctionID']; ?> [Status: <?php echo $row['status']; ?>]</h2>

                                        <div class="table-responsive-sm order-table"> 
                                            <table id="cartTable" class="bg-white table table-bordered table-hover text-center">
                                                <thead>
                                                    <tr>
                                                        <th class="text-left">Product Name</th>
                                                        <th>Front Image</th>
                                                        <th>Back Image</th>
                                                        <th>Condition</th>
                                                        <th>Description</th>
                                                        <th>Reserved Price</th>
                                                        <th>Winning Bid</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php 
                                                        $sqll = "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid, auction_contract_address FROM auction WHERE AuctionID = '".$row['AuctionID']."'";
                                                        $resultt = mysqli_query($connect, $sqll);
                                                        
                                                        while ($row2 = mysqli_fetch_assoc($resultt))
                                                        {
                                                            $prodResult = mysqli_query($connect, "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid, auction_contract_address FROM auction WHERE AuctionID = '".$row['AuctionID']."'");
                                                            $prodRow = mysqli_fetch_assoc($prodResult);
                                                    ?>
                                                    <tr>
                                                        <td class="text-left"><a href="<?php printf('%s?auctionID=%s', 'product-layout.php',  $prodRow['auctionID']); ?>"><?php echo $prodRow['ItemName'];  ?></a><?php echo $prodRow['ItemName'];  ?></a><input name="auction_contract_address" class="auction_contract_address" type="hidden" data-auction-id="<?php echo $prodRow['auctionID']; ?>" value="<?php echo $prodRow['auction_contract_address']; ?>"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_front_image']; ?>" width="100" height="100"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_back_image']; ?>" width="100" height="100"></td>
                                                        <td><?php echo $row2['product_condition']; ?></td>
                                                        <td><?php echo $row2['description']; ?></td>
                                                        <td><?php echo $prodRow['reserved_price']; ?> ETH</td>
                                                        <td><?php echo $prodRow['highest_bid_bidid']; ?></td>
                                                    </tr>
                                                <?php } ?>
                                                </tbody>
                                                <tfoot class="font-weight-600">
                                                    <tr>
                                                        <!--
                                                        <td colspan="4" class="text-right">Shipping </td>
                                                        <td>RM 50.00</td>
                                                    </tr>
                                                        -->
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>          
                                </div>
                                <div class="order-button-payment">
                                    <button class="btn" value="View Delivery Address" type="submit" onclick="endAuction('<?php echo $prodRow['auctionID']; ?>');" >View Delivery Address</button>
                                    <button class="btn" value="Order Shipped" type="submit" onclick="endAuction('<?php echo $prodRow['auctionID']; ?>');" >Order Shipped</button>
                                    <button class="btn" value="Dispute" type="submit" onclick="endAuction('<?php echo $prodRow['auctionID']; ?>');" >Dispute</button>
                                </div>
                            </div>
                        </div>
                            <br />
                            <?php }
                            //fetch all auctions related to Completed (Completed. Ended, refund and escrow completed)
                            $sql = "SELECT * from auction WHERE SellerUserID = '".$_SESSION["userID"]."' AND (CONVERT_TZ(NOW(), @@session.time_zone, '+08:00') > endtime) AND status = 'completed'";  
                            $result = mysqli_query($connect, $sql);
                            
                            echo "<h3><i class='icon anm anm-user-al'></i> Completed Auctions <a class='text-white text-decoration-underline' data-toggle='collapse'></a></h3>";
                            while ($row = mysqli_fetch_assoc($result))
                            {
                            ?>
                            <div>
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12">
                                <div class="your-order-payment">
                                    <div class="your-order">
                                        <h2 class="order-title mb-4">Auction <?php echo $row['auctionID']; ?> [Status: <?php echo $row['status']; ?>]</h2>

                                        <div class="table-responsive-sm order-table"> 
                                            <table id="cartTable" class="bg-white table table-bordered table-hover text-center">
                                                <thead>
                                                    <tr>
                                                        <th class="text-left">Product Name</th>
                                                        <th>Front Image</th>
                                                        <th>Back Image</th>
                                                        <th>Condition</th>
                                                        <th>Description</th>
                                                        <th>Reserved Price</th>
                                                        <th>Winning Bid</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php 
                                                        $sqll = "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid FROM auction WHERE AuctionID = '".$row['AuctionID']."'";
                                                        $resultt = mysqli_query($connect, $sqll);
                                                        
                                                        while ($row2 = mysqli_fetch_assoc($resultt))
                                                        {

                                                            $prodResult = mysqli_query($connect, "SELECT auctionID, ItemName, product_front_image, product_back_image, product_condition, description, reserved_price, highest_bid_bidid FROM auction WHERE AuctionID = '".$row['AuctionID']."'");
                                                            $prodRow = mysqli_fetch_assoc($prodResult);
                                                    ?>
                                                    <tr>
                                                        <td class="text-left"><a href="<?php printf('%s?auctionID=%s', 'product-layout.php',  $prodRow['auctionID']); ?>"><?php echo $prodRow['ItemName'];  ?></a><?php echo $prodRow['ItemName'];  ?></a><input name="auction_contract_address" class="auction_contract_address" type="hidden" data-auction-id="<?php echo $prodRow['auctionID']; ?>" value="<?php echo $prodRow['auction_contract_address']; ?>"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_front_image']; ?>" width="100" height="100"></td>
                                                        <td><img src="./assets/images/productimg/<?php echo $prodRow['product_back_image']; ?>" width="100" height="100"></td>
                                                        <td><?php echo $row2['product_condition']; ?></td>
                                                        <td><?php echo $row2['description']; ?></td>
                                                        <td><?php echo $prodRow['reserved_price']; ?> ETH</td>
                                                        <td><?php echo $prodRow['highest_bid_bidid']; ?></td>
                                                    </tr>
                                                <?php } ?>
                                                </tbody>
                                                <tfoot class="font-weight-600">
                                                    <tr>
                                                        <!--
                                                        <td colspan="4" class="text-right">Shipping </td>
                                                        <td>RM 50.00</td>
                                                    </tr>
                                                        -->
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>          
                                </div>
                                <div class="order-button-payment">
             
                               </div>
                            </div>
                        </div>
                            <br />
                            <?php }
                            
                        }
                        else{
                           echo "<h3><i class='icon anm anm-user-al'></i> Please login to view order. <a href='login.php' id='customer' class='text-white text-decoration-underline' >Click here to login</a></h3>";
                        }
                      ?>
                        
                    </div>
                </div>
        </div>   
</div>
    <!--End Body Content-->
<!-- JavaScript files-->
<script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>
   	<script src="js/front.js"></script>
	<!-- Including Jquery -->
	<script src="assets/js/vendor/jquery-3.3.1.min.js"></script>
	<script src="assets/js/vendor/jquery.cookie.js"></script>
	<script src="assets/js/vendor/modernizr-3.6.0.min.js"></script>
	<script src="assets/js/vendor/wow.min.js"></script>
	<!-- Including Javascript -->
	<script src="assets/js/bootstrap.min.js"></script>
	<script src="assets/js/plugins.js"></script>
	<script src="assets/js/popper.min.js"></script>
	<script src="assets/js/lazysizes.js"></script>
	<script src="assets/js/main.js"></script>
    <!-- Javascript functions -->
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

        async function requestAccount() {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            return accounts[0];
        }

      // Function to end the auction
        async function endAuction(auctionID) {
            // Use the auctionID to find the corresponding auction contract address
            const auctionAddressInput = document.querySelector('.auction_contract_address[data-auction-id="' + auctionID + '"]');
            const auctionAddress = auctionAddressInput.value;
            console.log(auctionID);
            console.log('Auction Contract Address: ' + auctionAddress);
            try {
                const account = await requestAccount();
                // Define the gas limit and gas price
                const gasLimit = web3.utils.toHex(3000000); // Example gas limit
                const gasPrice = web3.utils.toHex(web3.utils.toWei('10', 'gwei')); // Example gas price

                const receipt = await auctionManagerContract.methods.endAuction(auctionAddress).send({
                    from: account,
                    gas: gasLimit,
                    gasPrice: gasPrice
                });

                // Get the transaction hash
                const transactionHash = receipt.transactionHash;
                const auctionEndedEvent = receipt.events.AuctionEnded;
                console.log("Transaction Hash:", transactionHash);
                console.log("Receipt:", receipt);
                console.log("bidPlacedEvent:", auctionEndedEvent);
                console.log("Auction ended successfully");
                alert('Auction ended successfully.');
                if(auctionEndedEvent) {
                    try {
						// Data to send to PHP
						let formData = new FormData();
						formData.append('auctionID', auctionID);
                        formData.append('auction_contract_address', auctionAddress);
                        formData.append('transactionHash', transactionHash);
						
						// Send data to PHP script
						const response = await $.ajax({
							url: 'endAuctionDatabase.php',
							type: 'POST',
							data: formData, 
							contentType: false, // Do not set content type header
							processData: false, // Do not process data
							success: function(response) {
								console.log("Success:", response);
								alert('Auction ended successfully.');
								location.reload()
							},
							error: function(xhr, status, error) {
								console.error("Error:", error);
								alert('End auction failed. ' + error );
								location.reload()
							}
						});
					} catch (error) {
						console.error('Error sending data to PHP:', error);
					}

                }
                else
                {
                    console.error('auctionEndedEvent is not found.');
                }
            } catch (error) {
                console.error("Error ending auction:", error);
                alert('Error ending auction.');
            }
        }
    </script>
</script>
<?php
    include("footer.php");
?>

