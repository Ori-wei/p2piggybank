<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="2-Note Detail.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Note Detail</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        let investmentNoteAddress, noteFactoryAddress, hashHolderAddress;

        // Fetch contract data and initialize hashHolder contract
        async function fetchHashHolderAddress() {
            try {
                const response = await fetch('../build/contracts/HashHolder.json');
                const data = await response.json();
                const abi = data.abi;
                const networkId = '5777'; // Replace with the network ID you're using
                const contractAddress = data.networks[networkId].address;

                // Initialize the contract
                hashHolderAddress = new web3.eth.Contract(abi, contractAddress);

                // Debug logs
                console.log("ABI:", abi);
                console.log("Hash Holder Address:", contractAddress);
                console.log(hashHolderAddress.methods);
            } catch (error) {
                console.error('Error fetching contract data:', error);
                throw error;
            }
        }
        let isContractInitialized = false;

        async function initialize() {
            await fetchHashHolderAddress();
            isContractInitialized = true;
        }

        // Fetch contract data and initialize AuctionManager contract
        function fetchNoteFactoryAddress() {
            return fetch('../build/contracts/NoteFactory.json')
                .then(function (response) {
                    return response.json();
                })
                .then(function (data) {
                    const abi = data.abi;
                    const networkId = '5777';
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

        async function sendHash(tableName, hash, pkey) {

            if (!isContractInitialized) {
                console.error('Contracts are not initialized.');
                return;
            }

            try {
                const receipt = await hashHolderAddress.methods.setLatestHash(tableName, hash, pkey).send({ from: ethereum.selectedAddress });
                console.log('Transaction Receipt:', receipt);

                if (receipt.events.HashUpdated) {
                    console.log('Hash updated event:', receipt.events.HashUpdated.returnValues);
                    const tb = receipt.events.HashUpdated.returnValues.tableName;
                    const hsh = receipt.events.HashUpdated.returnValues.hash;
                    const pk = receipt.events.HashUpdated.returnValues.primaryKey;
                    alert('The hash for table ' + tb + ' is updated as ' + hsh + '. Primary key is ' + pk);
                    console.log("page 32, hash sent successfully!");
                } else {
                    console.log('no receipt');
                }

            } catch (error) {
                console.error(error);
                console.log("page 32, hash sent fail!");
                alert('Error sending hash: ' + error.message);
            }
        }

        async function signContract() {
            // create message
            var noteRecord = document.getElementById('<%= hidden_noteRecord.ClientID %>').value;
            let message = 'I acknowledge and accept full risks for investing in\n ' +
                noteRecord + '\nand hereby give my approval to proceed with investment.';
            let hexMessage = web3.utils.utf8ToHex(message); // Convert message to hex

            // sign the message
            let signer = ethereum.selectedAddress;
            try {
                // Return a promise that resolves with the signature or rejects with an error
                return new Promise((resolve, reject) => {
                    web3.eth.personal.sign(hexMessage, signer, (err, signature) => {
                        if (err) {
                            console.error(err);
                            reject(err);
                        } else {
                            console.log('Signature:', signature);
                            alert('You have signed this contract! You will now proceed to make two transactions:' +
                                '\n1) your investment, \n2) data protection fee.');
                            resolve(signature);
                        }
                    });
                });
            } catch (error) {
                console.error(error);
            }
        }

        async function investNote() {
            // 1- Sign Contract
            const signature = await signContract();
            
            // 2 - Invest in Note
            try {
                const account = await requestAccount();
                const amount = document.getElementById('TextBox1').value;
                const noteAddress = $('#<%= HiddenField1.ClientID %>').val();
                console.log(account);
                console.log(amount);
                console.log(noteAddress);

                // Call invest() on the specific Note contract and get receipt
                const receipt = await noteFactoryAddress.methods.investOnNote(
                    noteAddress, web3.utils.toWei(amount, "ether")).send(
                        { from: account, value: web3.utils.toWei(amount, "ether") });
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

                        console.log('investedNote info to be passed: ' + amount);
                        insertInvestedNote(noteAddress, amount, signature);

                        console.log('funded info to be passed: ' + fundedToDate);
                        result = await passFundedToDate(noteAddress, fundedToDate);

                        var tableName1 = $('#<%= TableName1.ClientID %>').val();
                        var hash1 = $('#<%= hash1.ClientID %>').val();
                        console.log("tableName1 at investNote: " + tableName1);
                        console.log("hash1 at investNote: " + hash1);

                        var tableName2;
                        var hash2;
                        if (fundsDisbursedEvent) {
                            const listedEndDateUnix = receipt.events.noteInvested.returnValues.updatedlistedEndDate;
                            const listedEndDate = new Date(listedEndDateUnix * 1000);
                            const listedEndDateForDb = listedEndDate.toISOString();

                            const repaymentDateUnix = receipt.events.noteInvested.returnValues.updatedRepaymentDate;
                            const repaymentDate = new Date(repaymentDateUnix * 1000);
                            const repaymentDateForDb = repaymentDate.toISOString();

                            console.log('disb info to be passed:' + listedEndDateForDb + repaymentDateForDb);
                            result = await updateDisbursement(noteAddress, listedEndDateForDb, repaymentDateForDb);
                            tableName2 = $('#<%= TableName2.ClientID %>').val();
                            hash2 = $('#<%= hash2.ClientID %>').val();
                            console.log("tableName2 is: " + tableName2);
                            console.log("hash2 is: " + hash2);
                        }

                        await initialize();
                        if (hash2 != null) {
                            await sendHash(tableName2, hash2, noteAddress);
                        } else {
                            await sendHash(tableName1, hash1, noteAddress);
                        }

                        // Redirect to homepage
                        window.location.href = "71-Lender My Notes.aspx";
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

        function insertInvestedNote(noteAddress, amount, signature) {
            // Return a new Promise
            return $.ajax({
                url: '2-Note Detail.asmx/insertInvestedNote',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    noteAddress: noteAddress,
                    amount: amount,
                    signature: signature
                }),
                success: function (response) {
                    console.log('Invested note data sent to C# successfully:', response);
                },
                error: function (error) {
                    console.error('Error sending invested note data to C#:', error);
                    // Reject the promise with the error object
                    reject(error);
                }
            });
        }

        function passFundedToDate(noteAddress, fundedToDate) {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: "POST",
                    url: '2-Note Detail.asmx/updateFundedAmt',
                    data: JSON.stringify({
                        noteAddress: noteAddress,
                        fundedToDate: fundedToDate
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log('funding data sent to C# successfully:', response);

                        var result = response.d;
                        var tableName = result.TableName;
                        var hashValue = result.Hash;

                        console.log("TableName at passFundedAmt: ", tableName);
                        console.log("Hash at passFundedAmt: ", hashValue);

                        // Set the values of hidden fields
                        $('#<%= TableName1.ClientID %>').val(tableName);
                        $('#<%= hash1.ClientID %>').val(hashValue);

                        resolve(response);
                    },
                    error: function (xhr, status, error) {
                        console.error('Error sending funding data to C#:. Status:', status, 'Error: ', error, 'Response: ', xhr.responseText);
                        reject(error); // Reject the promise with the error
                    }
                });
            });
        }

        function updateDisbursement(noteAddress, listedEndDateForDb, repaymentDateForDb) {
            return $.ajax({
                url: '2-Note Detail.asmx/updateDisbursement',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    noteAddress: noteAddress,
                    listedEndDateForDb: listedEndDateForDb,
                    repaymentDateForDb: repaymentDateForDb
                }),
                success: function (response) {
                    console.log('Disbursement data sent to C# successfully:', response);

                    var result = response.d;
                    var tableName = result.TableName;
                    var hashValue = result.Hash;

                    console.log("TableName: ", tableName);
                    console.log("Hash: ", hashValue);

                    // Set the values of hidden fields
                    $('#<%= TableName2.ClientID %>').val(tableName);
                    $('#<%= hash2.ClientID %>').val(hashValue);
                },
                error: function (error) {
                    console.error('Error sending disbursement data to C#:', error);
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
                    <asp:BoundField DataField="noteAddress" HeaderText="Note Address" />
                    <asp:BoundField DataField="financingAmt" HeaderText="Financing Amount" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                    <asp:BoundField DataField="interestRate" HeaderText="Profit Rate" />
                    <asp:BoundField DataField="creditRating" HeaderText="Credit Rating" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="NoteSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>

        <div class="details">
            <asp:DetailsView ID="NoteDetail2" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="financingPurpose" HeaderText="Financing Purpose" />
                    <asp:BoundField DataField="listedDate" HeaderText="Listed Date" />
                    <asp:BoundField DataField="listedEndDate" HeaderText="Listed End Date" />
                    <asp:BoundField DataField="fundedToDate" HeaderText="Funded To Date" />
                    <asp:BoundField DataField="remainingAmt" HeaderText="Remaining Amount" />
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

    <br />
    <asp:Button ID="Button1" runat="server" Text="< Back " CssClass="aspNetControl tableButton" OnClick="Back_Click" />

    <div>
        <asp:HiddenField ID="HiddenField1" runat="server" />
        <asp:HiddenField ID="hidden_noteRecord" runat="server" />
        <asp:HiddenField ID="TableName1" runat="server" />
        <asp:HiddenField ID="hash1" runat="server" />
        <asp:HiddenField ID="TableName2" runat="server" />
        <asp:HiddenField ID="hash2" runat="server" />
    </div>
</asp:Content>
