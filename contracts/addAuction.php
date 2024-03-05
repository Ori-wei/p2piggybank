<?php
// Initialize the session
session_start();
 
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Add Product</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="all,follow">
    <link rel="stylesheet" href="css/AdminSidebar.css">
	<link rel="stylesheet" href="css/FormAdm.css">
	<!-- Bootstrap CSS-->
    <link rel="stylesheet" href="vendor/bootstrap/css/bootstrap.min.css">
	<!--icon js-->
	<script src="https://kit.fontawesome.com/a076d05399.js"></script>
    <!-- Favicon-->
    <link rel="shortcut icon" href="img/home.png">
	<!-- Font Awesome CSS-->
    <link rel="stylesheet" href="vendor/font-awesome/css/font-awesome.min.css">
    <!-- Custom Font Icons CSS-->
    <link rel="stylesheet" href="css/font.css">
	<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
		function validateDecimalInput(evt, element) {
			var charCode = (evt.which) ? evt.which : evt.keyCode;
			
			// Allow only one dot and numbers
			if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
				return false;
			}
			
			// Check if dot is already present and the pressed key is dot
			if (element.value.includes('.') && charCode == 46) {
				return false;
			}

			// Check if there are more than two digits after the dot
			var parts = element.value.split('.');
			if (parts.length > 1 && parts[1].length >= 2) {
				return false;
			}

			return true;
		}

		function calculateEndDateTime() {
			var startDateTime = document.getElementById('auctionstartdatetime').value;
			var duration = document.getElementById('auctionduration').value;
			
			if (startDateTime && duration) {
				var startDate = new Date(startDateTime);

				// Add the duration to the start date
				//startDate.setHours(startDate.getHours() + parseInt(duration));
				startDate.setMinutes(startDate.getMinutes() + parseInt(duration));

				// Convert the end date to a local datetime string in 'YYYY-MM-DDTHH:MM' format
				var year = startDate.getFullYear();
				var month = ('0' + (startDate.getMonth() + 1)).slice(-2);
				var day = ('0' + startDate.getDate()).slice(-2);
				var hours = ('0' + startDate.getHours()).slice(-2);
				var minutes = ('0' + startDate.getMinutes()).slice(-2);

				var endDateTime = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
				document.getElementById('auctionenddatetime').value = endDateTime;
			}
		}

		document.getElementById('auctionstartdatetime').addEventListener('change', calculateEndDateTime);
		document.getElementById('auctionduration').addEventListener('input', calculateEndDateTime);
	</script>
</head>
<body>
<?php include("header.php");
	  ?>
	  <div class="d-flex align-items-stretch">
	<!------------------------------------main content start---------------------------->
			<div class="page-content">
        <div class="page-header">
          <div class="container-fluid">
            <h2 class="h5 no-margin-bottom">Create New Auction</h2>
          </div>
		</div>
		  <div class="row">
		<div class="col-md-10 col-xl-10">
			<div class="tab-content">
				<div class="tab-pane fade show active" id="account" role="tabpanel">
					<div class="card">
						<div class="card-header1">
							<h5 class="card-title mb-0">Auction Information</h5>
						</div>
						<div class="card-body">
							<form id="addauctionform" method="post" enctype="multipart/form-data"></form>
								<div class="form-row" form="addauctionform">
									<div class="form-group col-md-12">
										<label for="productname">Product Name</label>
										<input type="text" class="form-control" name="productname" id="productname" placeholder="Product Name" form="addauctionform" value="<?php if (isset($_POST['productname'])) echo $_POST['productname']; else echo ""; ?>"  required>
									</div>
								</div>
								<div class="form-row" form="addauctionform">
								<div class="form-group col-md-6">
									<label for="productcategory">Product Category</label>	
										<select name="productcategory" id="productcategory" class="form-control" form="addauctionform" required>
										<?php 
											// use a while loop to fetch data 
											// from the $all_categories variable 
											// and individually display as an option
											$connect = mysqli_connect("localhost","root","","fyp_auction_marketplace");
											$result = mysqli_query($connect, "select * from category");	
											$count = mysqli_num_rows($result);//used to count number of rows
											while($count = mysqli_fetch_assoc($result))
											{ 
										?>
											<option value="<?php echo $count["category_id"];
											?>">
												<?php 
													echo $count["category_name"];
												?>
												</option>
										<?php 
											}
										?>
										</select>
									</div>
								</div>
								<div class="form-row" form="addauctionform">
									<div class="form-group col-md-6">
										<label for="auctionstartdatetime">Auction Start DateTime</label>
										<input type="datetime-local" class="form-control" id="auctionstartdatetime" name="auctionstartdatetime" placeholder="Auction Start DateTime" form="addauctionform" min="<?php echo date('Y-m-d\TH:i'); ?>" onblur='calculateEndDateTime()' value="<?php if (isset($_POST['auctionstartdatetime'])) echo $_POST['auctionstartdatetime']; ?>" required>								
									</div>
									<div class="form-group col-md-6">
										<label for="auctionduration">Auction Duration (Hour/s)</label>
										<input type="number" class="form-control" id="auctionduration" name="auctionduration" placeholder="Auction Duration (Hour/s)" form="addauctionform" oninput='calculateEndDateTime()' onblur='calculateEndDateTime()' min="0" value="<?php if (isset($_POST['auctionduration'])) echo $_POST['auctionduration']; else echo ""; ?>" required>									
									</div>
									<div class="form-group col-md-6">
										<label for="auctionenddatetime">Auction End DateTime</label>
										<input type="datetime-local" class="form-control" id="auctionenddatetime" name="auctionenddatetime" placeholder="Auction End DateTime" form="addauctionform" readonly>                                  
									</div>
								</div>
								<div class="form-row" form="addauctionform">
									<div class="form-group col-md-6">
										<label for="condition">Condition</label>
										<input type="text" class="form-control" name="condition" id="condition" placeholder="Condition" step="0.01" form="addauctionform" value="<?php if (isset($_POST['condition'])) echo $_POST['condition']; else echo ""; ?>"  required>
									</div>
									<div class="form-group col-md-6">
										<label for="description">Description</label>
										<input type="text" class="form-control" name="description" id="description" placeholder="Description" step="0.01" form="addauctionform" value="<?php if (isset($_POST['description'])) echo $_POST['description']; else echo ""; ?>"  required>
									</div>
								</div>
								<div class="form-row" form="addauctionform">
									<div class="form-group col-md-6">
										<label for="reservedprice">Reserved Price (Eth)</label>
										<input type="text" class="form-control" name="reservedprice" id="reservedprice" placeholder="Reserved Price (Eth)" step="0.01" form="addauctionform" onkeypress='return validateDecimalInput(event, this)' onBlur= "if(this.value != '' ) {this.value = parseFloat(this.value).toFixed(2);}" value="<?php if (isset($_POST['reservedprice'])) echo $_POST['reservedprice']; else echo ""; ?>" required>									
									</div>
								</div>
								<div class="form-row" form="addauctionform">
									<div class="form-group col-md-6">
										<label for="productfrontimg" style="cursor: pointer;" >Product Front Image<i class="fas fa-upload" style="cursor: pointer;" ></i></label>
										<br />
										<img width="80%" src="assets/images/imgholder.png" id="frontimgdisplay" onclick="triggerClick()" />
										<input type="file" name="productfrontimg" id="productfrontimg" onchange="displayImg(this)" style="display: none;" form="addauctionform" required>
										<br/>														
									</div>
									<div class="form-group col-md-6">
										<label for="productbackimg" style="cursor: pointer;" >Product Back Image<i class="fas fa-upload" style="cursor: pointer;" ></i></label>
										<br />
										<img width="80%" src="assets/images/imgholder.png" id="backimgdisplay" onclick="triggerClick2()" />
										<input type="file" name="productbackimg" id="productbackimg" onchange="displayImg2(this)" style="display: none;" form="addauctionform" required>
										<br/>											
									</div>
								</div>
								<button type="submit" name="addauctionbtn" id="addauctionbtn" onclick="createAuction(event)" class="btn btn-primary1" form="addauctionform">Save Changes</button>
						</div>
					</div>
				</div>								
						</div>
					</div>
				</div>
			</div>
		</div>	
	</div>
		<!-----------------------main content end------------------------------------>
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
	<script>
		
		function triggerClick()
		{
			document.querySelector('#productfrontimg').click();
		}
		function displayImg(e)
		{
			if(e.files[0])
			{
				var reader = new FileReader();
				
				reader.onload = function(e)
				{
					document.querySelector('#frontimgdisplay').setAttribute('src', e.target.result);
				}
				reader.readAsDataURL(e.files[0]);
			}
		}
		function triggerClick2()
		{
			document.querySelector('#productbackimg').click();
		}
		function displayImg2(e)
		{
			if(e.files[0])
			{
				var reader2 = new FileReader();
				
				reader2.onload = function(e)
				{
					document.querySelector('#backimgdisplay').setAttribute('src', e.target.result);
				}
				reader2.readAsDataURL(e.files[0]);
			}
		}

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

		async function createAuction(event) 
		{
			// Prevent form from submitting immediately
			event.preventDefault();
			console.log('Button clicked!')
			var productName = document.getElementById('productname').value; 
			var frontImgName ="";
			var backImgName="";
			var durationString = document.getElementById('auctionduration').value; 
			var durationInt = parseInt(durationString, 10);
			var duration = durationInt * 60;
			console.log(productName);
			console.log(durationString);
			console.log(duration);

			//get front image name
			var fileInput = document.getElementById('productfrontimg');
			var file = fileInput.files[0]; // get the first file selected
			// Check if a file is selected
			if (file) {
				frontImgName = file.name; // get the name of the file
				console.log("Selected front file name:", frontImgName);
			} else {
				console.log("No file selected");
			}

			//get back image name
			fileInput = document.getElementById('productbackimg');
			file = fileInput.files[0]; // get the first file selected
			// Check if a file is selected
			if (file) {
				backImgName = file.name; // get the name of the file
				console.log("Selected back file name:", backImgName);
			} else {
				console.log("No file selected");
			}

			try {
				const account = await requestAccount();
				// Get the value from the auctionstartdatetime input field
				var auctionStartDateTimeValue = document.getElementById('auctionstartdatetime').value;
				console.log("Auction Start DateTime:", auctionStartDateTimeValue);

				// Create a Date object from the input value
				var utcStartTime = new Date(auctionStartDateTimeValue);
				console.log("Auction utcStartTime:", utcStartTime);

				// Get the Unix timestamp (in seconds)
				const startTime = Math.floor(utcStartTime.getTime() / 1000);
				console.log("startTime:", startTime);

				// Get reserved price
				const reservedPrice = document.getElementById('reservedprice').value;
				console.log("reserved Price:", reservedPrice);

				// Check if contract and method exist
				if (auctionManagerContract && auctionManagerContract.methods['createAuction']) {
				const weiReservedPrice = web3.utils.toWei(reservedPrice, 'ether');
				const receipt = await auctionManagerContract.methods.createAuction(productName, duration, weiReservedPrice, startTime).send({ from: account }); //param: itemname, duration(mins), reserved price 
				const auctionCreatedEvent = receipt.events.AuctionCreated;
				if (auctionCreatedEvent) {
					const newAuctionAddress = auctionCreatedEvent.returnValues.auctionAddress;
					console.log("New Auction Contract Address:", newAuctionAddress);
					alert('Auction created successfully at address: ' + newAuctionAddress);
					//send 1 eth to the contract to as gas fee 
					const amount = "1";
					const amountInWei = web3.utils.toWei(amount, 'ether');
					const transaction = {
						from: account,
						to: newAuctionAddress,
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
					alert('Sent 1 eth gas fee to: ' + newAuctionAddress);

					try {
						// Data to send to PHP
						let formData = new FormData();
						formData.append('productname', document.getElementById('productname').value);
						formData.append('productcategory', document.getElementById('productcategory').value);
						formData.append('auction_start_datetime', document.getElementById('auctionstartdatetime').value);
						formData.append('auction_duration', document.getElementById('auctionduration').value);
						formData.append('auction_end_datetime', document.getElementById('auctionenddatetime').value);
						formData.append('condition', document.getElementById('condition').value);
						formData.append('description', document.getElementById('description').value);
						formData.append('reserved_price', document.getElementById('reservedprice').value);
						formData.append('auction_contract_address', newAuctionAddress);
						formData.append('frontImgName', frontImgName);
						formData.append('backImgName', backImgName);

						var formData2 = new FormData(document.getElementById('addauctionform'));
						
						//merging the 2  formdata object into 1 formdata
						for (var pair of formData2.entries()) {
							formData.append(pair[0], pair[1]);
						}
						
						// Send data to PHP script
						// const response = await fetch('addAuctionDatabase.php', {
						// 	type: 'POST',
						// 	body: formData
						// });

						const response = await $.ajax({
							url: 'addAuctionDatabase.php',
							type: 'POST',
							data: formData, 
							contentType: false, // Do not set content type header
							processData: false, // Do not process data
							success: function(response) {
								console.log("Success:", response);
								alert('New auction created successfully.');
								location.reload()
							},
							error: function(xhr, status, error) {
								console.error("Error:", error);
								alert('Create new auction unsuccessfully. ' + error );
								location.reload()
							}
						});
					} catch (error) {
						console.error('Error sending data to PHP:', error);
					}
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
</script>

<?php

	// //connect to the database
    // $dbc = mysqli_connect("localhost","root","","fyp_auction_marketplace");
	
	// if(isset($_POST['addauctionbtn'])) { 
	// 	$product_name = $_POST["productname"]; 
	// 	$product_category = $_POST["productcategory"]; 	
	// 	$auction_start_datetime = $_POST["auctionstartdatetime"];
	// 	$auction_duration = $_POST["auctionduration"];
	// 	$auction_end_datetime = $_POST["auctionenddatetime"];
	// 	$condition = $_POST["condition"];
	// 	$description = $_POST["description"];
	// 	$reserved_price = $_POST["reservedprice"];

	// 	echo "<script>console.log('Auction Objects: $product_name + $product_category + $auction_start_datetime + $auction_duration + $auction_end_datetime + $condition + $description + $reserved_price');</script>";		
	// 	$frontImgName = $_FILES["productfrontimg"]["name"];
	// 	// For front image upload
	// 	$target_dir = "assets/images/productimg/";
	// 	$target_file = $target_dir . basename($frontImgName);
		
	// 	$backImgName = $_FILES["productbackimg"]["name"];
	// 	// For image upload
	// 	$target_dir2 = "assets/images/productimg/";
	// 	$target_file2 = $target_dir2 . basename($backImgName);
		
	// 	$Index = 1;
	// 	$auction_id = sprintf("A%04d", $Index);
	// 	$idCheckSQL = "SELECT auctionID from auction ORDER BY auctionID";
	// 	$idQuery = mysqli_query($dbc, $idCheckSQL); 
	
	// 	while ($idResult = mysqli_fetch_assoc($idQuery)) {
	// 		if($idResult['auctionID'] == $auction_id)
	// 		{
	// 			$Index += 1;
	// 			$auction_id = sprintf("A%04d", $Index);
	// 		}
	// 	}
	
	// 	$query = "INSERT INTO auction (auctionID, ItemName, StartTime, duration, EndTime, product_condition, description, reserved_price, category_id, SellerUserID, product_front_image, product_back_image) values ('$auction_id', '$product_name', '$auction_start_datetime', '$auction_duration', '$auction_end_datetime', '$condition', '$description', '$reserved_price', '$product_category', '{$_SESSION['userID']}', '$frontImgName', '$backImgName')";																																																													
	// 	if(mysqli_query($dbc, $query)) {
	// 		?>
	// 		<script>
	// 			Swal.fire('<?= $auction_id ?>', 'added successfully', 'success');
	// 		</script>
	// 		<?php
	// 		// Image upload inside if block
	// 		$uploadBackImg = move_uploaded_file($_FILES["productbackimg"]["tmp_name"], $target_file2);
	// 		$uploadFrontImg = move_uploaded_file($_FILES["productfrontimg"]["tmp_name"], $target_file);
	
	// 		if ($uploadBackImg) {
	// 			echo '<script>alert("Product back image uploaded.");</script>';
	// 		}
	// 		if ($uploadFrontImg) {
	// 			echo '<script>alert("Product front image uploaded.");</script>';
	// 		}
	// 	} else {
	// 		?>
	// 		<script type="text/javascript">
	// 			Swal.fire({ icon: 'error', title: 'Oops...', text: 'Product add failed.' });
	// 			console.log('Error: <?= mysqli_error($dbc); ?>');
	// 		</script>
	// 		<?php
	// 	}
	// }
?>

</body>
</html>

<?php
	include("footer.php");
?>