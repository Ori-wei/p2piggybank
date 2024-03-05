<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="51-Borrower My Application 2.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm17" Async="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Application Details</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        let investmentNoteAddress, noteFactoryAddress, hashHolderAddress;
        //let web3 = new Web3(window.ethereum);

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

        // Fetch contract data and initialize Note Factory contract
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

        // Fetch contract data and initialize Investment Note contract
        function fetchNoteAddress() {
            return fetch('../build/contracts/InvestmentNote.json')
                .then(function (response) {
                    return response.json();
                })
                .then(function (data) {
                    const abi = data.abi;
                    const networkId = '5777';
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

        async function sendHash(tableNames, hashes, pkeys) {

            if (!isContractInitialized) {
                console.error('Contracts are not initialized.');
                return;
            }

            try {
                const receipt = await hashHolderAddress.methods.setMultipleLatestHashes(tableNames, hashes, pkeys).send({ from: ethereum.selectedAddress });
                console.log('Transaction Receipt:', receipt);

                if (receipt.events.HashUpdated) {
                    console.log('Hash updated event:', receipt.events.HashUpdated.returnValues);

                    // If there's only one event, it may not be an array; handle both cases
                    const hashUpdatedEvents = Array.isArray(receipt.events.HashUpdated) ? receipt.events.HashUpdated : [receipt.events.HashUpdated];
                    hashUpdatedEvents.forEach((event) => {
                        const tb = event.returnValues.tableName;
                        const hsh = event.returnValues.hash;
                        const pk = event.returnValues.primaryKey;
                        console.log(`Hash for table ${tb} updated. Hash: ${hsh}, Primary key: ${pk}`);
                        alert(`Hash for table ${tb} updated. Hash: ${hsh}, Primary key: ${pk}`);
                    });
                    console.log("page 51, hash sent successfully!");
                } else {
                    console.log('No HashUpdated events found in receipt.');
                }

            } catch (error) {
                console.error(error);
                console.log("page 51, hash sent fail!");
                alert('Error sending hash: ' + error.message);
            }
        }

        async function requestAccount() {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            return accounts[0];
        }

        async function signContract() {
            // create message
            var appRecord = document.getElementById('<%= hidden_appRecord.ClientID %>').value;
            let message = 'I acknowledge and accept full responsibility for accepting\n ' +
                appRecord + '\nand hereby give my approval to proceed with note creation for financing purposes.';
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
                            alert('You have signed this contract! You will now proceed to make three transactions:' +
                                '\n1) note creation fee, \n2) Processing fee/ Collateral (3 ETH), \n3) data protection fee.');
                            resolve(signature);
                        }
                    });
                });
            } catch (error) {
                console.error(error);
            }
        }

        async function createNote() {
            // 1 - Sign contract
            const signature = await signContract();

            // 2 - Prepare for note creation
            const financingAmt = parseFloat(document.getElementById('<%= hidden_financingAmt.ClientID %>').value);
            const duration = parseInt(document.getElementById('<%= hidden_Duration.ClientID %>').value, 10);
            const repaymentAmt = parseFloat(document.getElementById('<%= hidden_repaymentAmt.ClientID %>').value);
            const interestRate = parseFloat(document.getElementById('<%= hidden_interestRate.ClientID %>').value);

            // Convert to Solidity format
            const scaledInterestRate = Math.round(interestRate * 100);
            const financingAmtWei = web3.utils.toWei(financingAmt.toString(), 'ether');
            const repaymentAmtWei = web3.utils.toWei(repaymentAmt.toString(), 'ether');

            console.log("After fetching: ", noteFactoryAddress, investmentNoteAddress);

            if (!noteFactoryAddress || !investmentNoteAddress) {
                console.error('Contracts are not initialized.');
                return;
            }

            // 3 - Create a note
            let noteAddress;
            try {
                // Send the transaction using the .send() method
                const txReceipt = await noteFactoryAddress.methods.createNote(
                    financingAmtWei, duration, repaymentAmtWei, scaledInterestRate).send(
                        { from: ethereum.selectedAddress });
                console.log('Transaction Receipt:', txReceipt);

                // If you want to use the receipt to get the transaction hash:
                const txHash = txReceipt.transactionHash;
                console.log('Transaction Hash:', txHash);

                // Logic based on the receipt
                if (txReceipt.events.NoteCreated) {
                    console.log('NoteCreated event:', txReceipt.events.NoteCreated.returnValues);
                    noteAddress = txReceipt.events.NoteCreated.returnValues.noteAddress;
                    console.log('Note Address:', noteAddress);

                    // transfer 3ETH to contract
                    const account = await requestAccount();
                    const amount = "3";
                    const amountInWei = web3.utils.toWei(amount, 'ether');
                    const transaction = {
                        from: account, to: noteAddress, value: amountInWei,
                        gas: 100000, gasPrice: web3.utils.toWei('10', 'gwei')
                    };

                    try {
                        const receipt = await web3.eth.sendTransaction(transaction);
                        console.log('Receipt for sending 3ETH: ' + receipt);
                        alert('Processing Fee/ Collateral (3 ETH) is sent to: ' + noteAddress);
                    } catch (error) {
                        console.error(error);
                    }
                }

                await setNoteAddress(noteAddress, signature);
                await initialize();
                console.log("page 51, sending app and note hash");
                var tableName1 = $('#<%= TableName1.ClientID %>').val();
                var hash1 = $('#<%= hash1.ClientID %>').val();
                var pkey1 = $('#<%= pkey1.ClientID %>').val();
                console.log("tableName is: " + tableName1);
                console.log("hash is: " + hash1);
                console.log("pkey1 is: " + pkey1);

                var tableName2 = $('#<%= TableName2.ClientID %>').val();
                var hash2 = $('#<%= hash2.ClientID %>').val();
                var pkey2 = $('#<%= pkey2.ClientID %>').val();
                console.log("tableName is: " + tableName2);
                console.log("hash is: " + hash2);
                console.log("pkey2 is: " + pkey2);

                console.log("check send array input");
                await sendHash([tableName1, tableName2], [hash1, hash2], [pkey1, pkey2]);
                console.log("page 51, sending app and note hash done");

                alert('Your note is successfully listed to public!');

                window.location.href = '61-Borrower My Financing.aspx';

            } catch (error) {
                console.error('Transaction Error:', error);
            }
        }

        // set Note Address
        function setNoteAddress(noteAddress, signature) {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: "POST",
                    url: "CreateNote.asmx/SetNoteAddress",
                    data: JSON.stringify({
                        noteAddress: noteAddress,
                        signature: signature
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log("Note Address is saved successfully.");
                        console.log("Full response:", response);
                        console.log("Response.d:", response.d);

                        var result = response.d;
                        var tableName1 = result.TableName1;
                        var hashValue1 = result.Hash1;
                        var pkey1 = result.Pkey1;
                        var tableName2 = result.TableName2;
                        var hashValue2 = result.Hash2;
                        var pkey2 = result.Pkey2.trim();

                        console.log("TableName1: ", tableName1);
                        console.log("Hash1: ", hashValue1);
                        console.log("Pkey: ", pkey1);
                        console.log("TableName2: ", tableName2);
                        console.log("Hash2: ", hashValue2);
                        console.log("Pkey2: ", pkey2);

                        // Set the values of hidden fields
                        $('#<%= TableName1.ClientID %>').val(tableName1);
                        $('#<%= hash1.ClientID %>').val(hashValue1);
                        $('#<%= pkey1.ClientID %>').val(pkey1);
                        $('#<%= TableName2.ClientID %>').val(tableName2);
                        $('#<%= hash2.ClientID %>').val(hashValue2);
                        $('#<%= pkey2.ClientID %>').val(pkey2);

                        resolve(response);
                    },
                    error: function (xhr, status, error) {
                        console.error("Error saving Note Address. Status:", status, "Error:", error, "Response:", xhr.responseText);
                        reject(error); // Reject the promise with the error
                    }
                });
            });
        }


        async function callHash() {
            try {
                console.log("page 51, sending app hash");
                var tableName1 = $('#<%= TableName1.ClientID %>').val();
                var hash1 = $('#<%= hash1.ClientID %>').val();
                var pkey1 = $('#<%= pkey1.ClientID %>').val();
                console.log("tableName is: " + tableName1);
                console.log("hash is: " + hash1);
                console.log("pkey1 is: " + pkey1);
                await sendHash([tableName1], [hash1], [pkey1]);
                console.log("page 51, sending app hash done");

                window.location.href = "5-Borrower My Application.aspx";
            }
            catch (error) {
                console.error('Error in retrieving or sending hash:', error);
                throw error;
            }
        }

        document.addEventListener('DOMContentLoaded', async function () {
            await initialize();
            if (document.getElementById('<%= callScript.ClientID %>').value == 'reviewed') {
                callHash();
            }
        });
    </script>

    <!--Main Content-->
    <div class="table-title">Congratulations! Your application is approved.</div>
    <br /><br />
    <!--top-->
    <div class="detail-box">
        <!--top-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail1" runat="server" AutoGenerateRows="False" DataSourceID="AppSource1" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="appID" HeaderText="Application ID" />
                    <asp:BoundField DataField="appDateTime" HeaderText="Application Datetime" />
                    <asp:BoundField DataField="financingAmt" HeaderText="Financing Amount" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                    <asp:BoundField DataField="financingPurpose" HeaderText="Financing Purpose" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>

        <!--top-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail2" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="approvalDate" HeaderText="Approval Date" />
                    <asp:BoundField DataField="creditRating" HeaderText="Credit Rating" />
                    <asp:BoundField DataField="interestRate" HeaderText="Interest Rating" />
                    <asp:BoundField DataField="repaymentAmt" HeaderText="Repayment Amount" />
                </Fields>
            </asp:DetailsView>
        </div>
    </div>

    
    <p>Please read before you make decision: </p>
    <p>1. A digital signature will be created upon accepting this offer. </p>
    <p>2. Three transactions will be made here: note creation fee, processing fee/ collateral (3 ETH), and data protection fee. </p>
    <p>3. Once your note is created, it will be published to the public for fundraising.</p>
    <p>4. The listing will be ended in two months or when your fundraising goal has achieved.</p>
    <p>5. Repayment are encouraged before the maturity date; The remaining processing fee will not be returned in the case of late repayment.</p>

    <div class="label-with-buttons">
        <asp:Label ID="Label3" runat="server" Text="Your Decision: " Width="200px"></asp:Label>
        <div class="buttons">
            <asp:Button ID="Reject" runat="server" Text="Reject" CssClass="aspNetControl tableButton" BackColor="white" ForeColor="#667085" OnClick="Reject_Click"/>
            <asp:Button ID="Accept" runat="server" Text="Accept" CssClass="aspNetControl tableButton" BackColor="#AFBCD5" ForeColor="white" OnClientClick="createNote(); return false;" />
        </div>
    </div>
    <asp:Label ID="appSignature" runat="server" Text="" Width="200px"></asp:Label>

    <br />
    <asp:Button ID="Button1" runat="server" Text="< Back " CssClass="aspNetControl tableButton" OnClick="Back_Click" />

    <!--Area for hidden values-->
    <div>
        <asp:HiddenField ID="hidden_appRecord" runat="server" />
        <asp:HiddenField ID="hidden_financingAmt" runat="server" />
        <asp:HiddenField ID="hidden_Duration" runat="server" />
        <asp:HiddenField ID="hidden_interestRate" runat="server" />
        <asp:HiddenField ID="hidden_repaymentAmt" runat="server" />

        <asp:HiddenField ID="TableName1" runat="server" />
        <asp:HiddenField ID="hash1" runat="server" />
        <asp:HiddenField ID="pkey1" runat="server" />
        <asp:HiddenField ID="callScript" runat="server" />
        <asp:HiddenField ID="TableName2" runat="server" />
        <asp:HiddenField ID="hash2" runat="server" />
        <asp:HiddenField ID="pkey2" runat="server" />
    </div>
</asp:Content>
