<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="testHashWithMaster.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm22" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Note Detail</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        let investmentNoteAddress, noteFactoryAddress, hashHolderAddress;

        // Fetch contract data and initialize hashHolder contract
        function fetchHashHolderAddress() {
            return fetch('../build/contracts/HashHolder.json')
                .then(function (response) {
                    return response.json();
                })
                .then(function (data) {
                    const abi = data.abi;
                    const networkId = '5777'; // Replace with the network ID you're using
                    const contractAddress = data.networks[networkId].address;

                    // Initialize the contract
                    hashHolderAddress = new web3.eth.Contract(abi, contractAddress);

                    // Debug logs
                    console.log("ABI:", abi);
                    console.log("Hash Holder Address:", contractAddress);
                    console.log(hashHolderAddress.methods);
                })
                .catch(function (error) {
                    console.error('Error fetching contract data:', error);
                    throw error;
                });
        }

        // Fetch contract data and initialize AuctionManager contract
        function fetchNoteFactoryAddress() {
            return fetch('../build/contracts/NoteFactory.json')
                .then(function (response) {
                    return response.json();
                })
                .then(function (data) {
                    const abi = data.abi;
                    const networkId = '5777'; // Replace with the network ID you're using
                    const contractAddress1 = data.networks[networkId].address;

                    // Initialize the contract
                    noteFactoryAddress = new web3.eth.Contract(abi, contractAddress1);

                    // Debug logs
                    console.log("ABI:", abi);
                    console.log("Note Factory Address:", contractAddress1);
                    console.log(noteFactoryAddress.methods);
                })
                .catch(function (error) {
                    console.error('Error fetching contract data:', error);
                    throw error;
                });
        }

        // Fetch contract data and initialize Auction contract
        function fetchNoteAddress() {
            return fetch('../build/contracts/InvestmentNote.json')
                .then(function (response) {
                    return response.json();
                })
                .then(function (data) {
                    const abi = data.abi;
                    const networkId = '5777'; // Replace with the network ID you're using
                    const contractAddress2 = data.networks[networkId].address;

                    // Initialize the contract
                    investmentNoteAddress = new web3.eth.Contract(abi, contractAddress2);

                    // Debug logs
                    console.log("ABI:", abi);
                    console.log("Investment Note Address:", contractAddress2);
                    console.log(investmentNoteAddress.methods);
                })
                .catch(function (error) {
                    console.error('Error fetching contract data:', error);
                });
        }

        fetchNoteFactoryAddress();
        fetchNoteAddress();
        fetchHashHolderAddress();

        async function sendHash(tableName, hash) {

            if (!hashHolderAddress) {
                console.error('Contracts are not initialized.');
                return;
            }

            try {
                const receipt = await hashHolderAddress.methods.setLatestHash(tableName, hash).send({ from: ethereum.selectedAddress });
                console.log('Transaction Receipt:', receipt);

                if (receipt.events.HashUpdated) {
                    console.log('Hash updated event:', receipt.events.HashUpdated.returnValues);
                    const tb = receipt.events.HashUpdated.returnValues.tableName;
                    const hsh = receipt.events.HashUpdated.returnValues.hash;
                    alert('The hash for table' + tb + ' is updated as ' + hsh);
                } else {
                    console.log('no receipt');
                }

            }catch (error) {
                console.error(error);
                alert('Error sending hash: ' + error.message);
            }
        }

        async function retrieveLatestHash(tableName) {
            try {
                const hashReturnedFromContract = await hashHolderAddress.methods.getLatestHash(tableName).call();
                console.log("The latest hash for " + tableName + " is: " + hashReturnedFromContract);
            } catch (error) {
                console.error("Error in retrieving hash: ", error);
            }
        }

        async function investNote() {
            try {
                const account = await requestAccount();
                const amount = document.getElementById('TextBox1').value;
                const noteAddress = $('#<%= HiddenField1.ClientID %>').val();
                console.log(account);
                console.log(amount);
                console.log(noteAddress);

                // Initialize the specific Auction contract instance
                const specificNoteAddress = new web3.eth.Contract(investmentNoteAddress.options.jsonInterface, noteAddress);

                // Call invest() on the specific Note contract and get receipt
                const receipt = await noteFactoryAddress.methods.investOnNote(noteAddress, web3.utils.toWei(amount, "ether")).send({ from: account, value: web3.utils.toWei(amount, "ether") });
                const noteInvestedEvent = receipt.events.noteInvested;
                const fundsDisbursedEvent = receipt.events.fundsDisbursed;
                // Get the transaction hash
                const transactionHash = receipt.transactionHash;
                console.log("Transaction Hash:", transactionHash);

                // Get the block timestamp using the block number
                const block = await web3.eth.getBlock(receipt.blockNumber);
                const blockTimestamp = block.timestamp;
                console.log("Block Timestamp:", new Date(blockTimestamp * 1000));

                //check tx receipt
                console.log("Transaction Receipt:", receipt);
                console.log("noteInvestedEvent:", noteInvestedEvent);
                alert('Note invested successfully!');
                if (noteInvestedEvent) {
                    console.log('Note invested on Note Address: ', noteAddress);
                    try {
                        let result;
                        console.log('Use ajax to update fundedToDate in c#');
                        // Data to send to c#
                        const fundedToDateWei = receipt.events.noteInvested.returnValues.fundedToDate;
                        const fundedToDate = web3.utils.fromWei(fundedToDateWei, 'ether');

                        /*console.log('investedNote info to be passed: ' + amount);
                        result = await insertInvestedNote(noteAddress, amount);
                        let { tableName, hash } = result;
                        await sendHash(tableName, hash);*/

                        console.log('funded info to be passed: ' + fundedToDate);
                        result = await passFundedToDate(noteAddress, fundedToDate);
                        var tableName = $('#<%= hiddenFieldTableName.ClientID %>').val();
                        var hash = $('#<%= hiddenFieldHash.ClientID %>').val();
                        console.log("tableName is: " + tableName);
                        console.log("hash is: " + hash);
                        await sendHash(tableName, hash);

                        // retrieve hash from contract
                        await retrieveLatestHash(tableName);
                        
                        if (fundsDisbursedEvent) {
                            const listedEndDateUnix = receipt.events.noteInvested.returnValues.updatedlistedEndDate;
                            const listedEndDate = new Date(listedEndDateUnix * 1000);
                            const listedEndDateForDb = listedEndDate.toISOString();

                            const repaymentDateUnix = receipt.events.noteInvested.returnValues.updatedRepaymentDate;
                            const repaymentDate = new Date(repaymentDateUnix * 1000);
                            const repaymentDateForDb = repaymentDate.toISOString();

                            console.log('disb info to be passed:' + listedEndDateForDb + repaymentDateForDb);
                            ({ tableName, hash } = await updateDisbursement(noteAddress, listedEndDateForDb, repaymentDateForDb));
                            await sendHash(tableName, hash);
                            alert('Fund disbursed!');

                        }

                        // Redirect to homepage
                        //window.location.href = "71-Lender My Notes.aspx";
                        window.location.href = "Admin Integrity Check.aspx";

                    } catch (error) {
                        console.error('Error sending data to c#:', error);
                    }
                } else {
                    alert('Note is not invested.');
                }
            } catch (error) {
                console.error(error);
                alert('Error investing note: ' + error.message);
            }
        }

        

        function passFundedToDate(noteAddress, fundedToDate) {
            return $.ajax({
                url: '2-Note Detail.asmx/updateFundedAmt',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    noteAddress: noteAddress,
                    fundedToDate: fundedToDate
                }),
                success: function (response) {
                    var result = response.d;
                    var tableName = result.TableName;
                    var hashValue = result.Hash;

                    console.log("TableName: ", tableName);
                    console.log("Hash: ", hashValue);

                    // Set the values of hidden fields
                    $('#<%= hiddenFieldTableName.ClientID %>').val(tableName);
                    $('#<%= hiddenFieldHash.ClientID %>').val(hashValue);

                    // Further processing or indication of success
                    console.log("Hidden fields updated with TableName and Hash.");
                },
                error: function (error) {
                    console.error('Error sending funding data to C#:', error);
                }
            });
        }

        function fetchMaxInvestmentAmount(noteAddress) {
            return $.ajax({
                type: "POST",
                url: "2-Note Detail.asmx/GetMaxInvestmentAmount",
                data: JSON.stringify({ noteAddress: noteAddress }),
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            });
        }

        function validateInvestmentAmount() {
            var address = $('#<%= HiddenField1.ClientID %>').val();
            console.log(address);
            fetchMaxInvestmentAmount(address).done(function (response) {
                var maxAmount = response.d; // Assuming response is the max amount
                var userAmount = parseFloat(document.getElementById('TextBox1').value);
                if (userAmount > maxAmount) {
                    alert('The invested amount should not exceed ' + maxAmount + '!');
                    document.getElementById('TextBox1').value = "";
                    document.getElementById('TextBox2').value = "";
                } else if (userAmount <= 0) {
                    alert('The invested amount should not smaller than 0.01');
                    document.getElementById('TextBox1').value = "";
                    document.getElementById('TextBox2').value = "";
                }
            }).fail(function (error) {
                console.error('Error fetching max investment amount:', error);
            });
        }

        function fetchReturnAmount(noteAddress, amount) {
            return $.ajax({
                type: "POST",
                url: "2-Note Detail.asmx/CalculateReturn",
                data: JSON.stringify({ noteAddress: noteAddress, amount: amount }),
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            });
        }

        function calReturn() {
            var address = $('#<%= HiddenField1.ClientID %>').val();
            var amount = $('#TextBox1').val();
            console.log(address, amount);

            fetchReturnAmount(address, amount).done(function (response) {
                var returnValue = response.d; // Assuming response contains the return value
                console.log(returnValue);
                document.getElementById('TextBox2').value = returnValue; // Set value to TextBox2
            }).fail(function (error) {
                console.error('Error fetching return amount:', error);
            });
        }
    </script>

    <!-- Financial Information Section -->
    <div class="detail-box">
        <div class="details">
            <asp:DetailsView ID="NoteDetail1" runat="server" AutoGenerateRows="False" DataSourceID="NoteSource1" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                    <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                    <asp:BoundField DataField="Duration" HeaderText="DURATION" />
                    <asp:BoundField DataField="interestRate" HeaderText="PROFIT RATE" />
                    <asp:BoundField DataField="creditRating" HeaderText="CREDIT RATING" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="NoteSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>

        <div class="details">
            <asp:DetailsView ID="NoteDetail2" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="financingPurpose" HeaderText="FINANCING PURPOSE" />
                    <asp:BoundField DataField="listedDate" HeaderText="LISTED DATE" />
                    <asp:BoundField DataField="listedEndDate" HeaderText="LISTED END DATE" />
                    <asp:BoundField DataField="fundedToDate" HeaderText="FUNDED TO DATE" />
                    <asp:BoundField DataField="remainingAmt" HeaderText="REMAINING AMOUNT" />
                </Fields>
            </asp:DetailsView>
        </div>
    </div>
    
    <br /><br />
    <!-- Bottom Section -->
    <div class="detail-box">
        <!--bottom-left-->
        <div class="form-row">
            <div class="form-field">
                <asp:Label ID="Label1" runat="server" Text="INVESTMENT AMOUNT" Width="150px"></asp:Label>
                <asp:TextBox ID="TextBox1" ClientIDMode="Static" runat="server" CssClass="aspNetControl" onchange="calReturn(); validateInvestmentAmount();"></asp:TextBox>
            </div>
            <div class="form-field">
                <asp:Label ID="Label2" runat="server" Text="EXPECTED TO RECEIVE" Width="150px"></asp:Label>
                <asp:TextBox ID="TextBox2" ClientIDMode="Static" runat="server" CssClass="aspNetControl" Enabled="false"></asp:TextBox>
            </div>
            <div class="form-field">
                <asp:Label ID="Label3" runat="server" Text="" Width="150px"></asp:Label>
                <asp:Button ID="Invest" runat="server" Text="Invest" CssClass="aspNetControl tableButton" OnClientClick="investNote(); return false;" />
                <asp:Label ID="Label4" runat="server" Text="" Width="250px"></asp:Label>
            </div>
        </div>
        
        <div class="form-row" style="padding-top: 25px; padding-left: 80px;">
            <b>Credit Rating Guidance</b> <br />
            RATE A: 5% (Low Risk) <br /><br />
            RATE B: 9% (Moderate Risk) <br /><br />
            RATE C: 13% (High Risk)
        </div>
    </div>

    <div>
        <asp:HiddenField ID="HiddenField1" runat="server" /> <!--biisan use-->
        <asp:HiddenField ID="hiddenFieldTableName" runat="server" />
        <asp:HiddenField ID="hiddenFieldHash" runat="server" />
    </div>
</asp:Content>
