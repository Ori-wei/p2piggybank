<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="61-Borrower My Financing.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm18" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Financing</title>
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
                    console.log("page admin bgv2, hash sent successfully!");
                } else {
                    console.log('no receipt');
                }

            } catch (error) {
                console.error(error);
                console.log("page admin bgv2, hash sent fail!");
                alert('Error sending hash: ' + error.message);
            }
        }

        async function repayFunds(noteAddress) {
            try {
                console.log('repay funds script triggered for: ' + noteAddress);

                const account = await requestAccount();
                const amount = await setRepayable(noteAddress);
                const NoteAddress = noteAddress;
                console.log(account);
                console.log(noteAddress);

                // Call repay() on the specific Note contract and get receipt
                const receipt = await noteFactoryAddress.methods.repayFund(
                    noteAddress, web3.utils.toWei(amount, "ether")).send(
                        { from: account, value: web3.utils.toWei(amount, "ether") });
                const fundRepaidEvent = receipt.events.fundRepaid;

                // Get the transaction hash
                const transactionHash = receipt.transactionHash;
                console.log("Transaction Hash:", transactionHash);

                //check tx receipt
                console.log("Transaction Receipt:", receipt);
                console.log("noteInvestedEvent:", fundRepaidEvent);
                alert("Note repaid successfully! " + noteAddress);

                if (fundRepaidEvent) {
                    console.log('Note repaid on note Address: ', noteAddress);
                    try {
                        await updateNoteComplete(noteAddress);

                        console.log('page 61, sending note hash');
                        var tableName1 = $('#<%= TableName1.ClientID %>').val();
                        var hash1 = $('#<%= hash1.ClientID %>').val();
                        console.log("tableName is: " + tableName1);
                        console.log("hash is: " + hash1);
                        console.log('page 61, sending note hash done');

                        await initialize();
                        await sendHash(tableName1, hash1, noteAddress);
                        window.location.href = '61-Borrower My Financing.aspx';
                    } catch (error) {
                        console.error('Error sending data to c#:', error);
                    }
                } else {
                    alert('Note is not repaid.');
                }
            } catch (error) {
                console.error('Error fetching note address:', error);
                alert('Error fetching note address: ' + error.message);
            }
        }

        async function setRepayable(noteAddress) {
            try {
                const response = await $.ajax({
                    url: '61-Borrower My Financing.asmx/setRepayable',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ noteAddress: noteAddress })
                });
                console.log('repayable data set to C# successfully:', response);
                return response.d;
            } catch (error) {
                console.error('Error setting repayable data on C#:', error);
            }
        }

        function updateNoteComplete(noteAddress) {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: "POST",
                    url: '61-Borrower My Financing.asmx/updateNoteComplete',
                    data: JSON.stringify({
                        noteAddress: noteAddress
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log('note repaid data sent to C# successfully:', response);

                        var result = response.d;
                        var tableName = result.TableName;
                        var hashValue = result.Hash;

                        console.log("TableName: ", tableName);
                        console.log("Hash: ", hashValue);

                        // Set the values of hidden fields
                        $('#<%= TableName1.ClientID %>').val(tableName);
                        $('#<%= hash1.ClientID %>').val(hashValue);

                        resolve(response);
                    },
                    error: function (xhr, status, error) {
                        console.error('Error sending invested note data to C#. Status:', status, 'Error: ', error, 'Response: ', xhr.responseText);
                        reject(error); // Reject the promise with the error
                    }
                });
            });
        }
    </script>

    <div class="tab-container">
        <asp:LinkButton ID="fundraisingTab" runat="server" CssClass="tab-button" OnClick="FundraisingTab_Click">Fundraising</asp:LinkButton>
        <asp:LinkButton ID="repaymentTab" runat="server" CssClass="tab-button" OnClick="RepaymentTab_Click">Repayment</asp:LinkButton>
        <asp:LinkButton ID="completedTab" runat="server" CssClass="tab-button" OnClick="CompleteTab_Click">Completed</asp:LinkButton>
    </div>

    <br /><br />

    <asp:MultiView ID="MultiView1" runat="server">

        <asp:View ID="View1" runat="server">
            <!-- Content for the Repayment tab -->
            <div class="table-title">My Listed Note</div>
            <div class="tables scrollable-gridview">
                <asp:GridView ID="fundraisingTB" runat="server" AutoGenerateColumns="False" >
                    <Columns>
                        <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                        <asp:BoundField DataField="listedEndDate" HeaderText="LISTED END DATE" />
                        <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                        <asp:BoundField DataField="fundedToDate" HeaderText="FUNDED TO DATE (%)" />
                        <asp:BoundField DataField="remainingAmt" HeaderText="REMAINING AMOUNT" />
                    </Columns>
                </asp:GridView>
            </div>
        </asp:View>

        <asp:View ID="View2" runat="server">
            <!-- Content for the Repayment tab -->
            <div class="table-title">My Repayment</div>
            <div class="tables scrollable-gridview">
                <asp:GridView ID="repaymentTB" runat="server" AutoGenerateColumns="False" >
                    <Columns>
                        <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                        <asp:BoundField DataField="repaymentDate" HeaderText="REPAYMENT DATE" />
                        <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                        <asp:BoundField DataField="interestRate" HeaderText="INTEREST RATE" />
                        <asp:BoundField DataField="repaymentAmt" HeaderText="REPAYMENT AMOUNT" />
                        <asp:TemplateField HeaderText="ACTION">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton2" runat="server" Text="REPAY" CssClass="tableButton" OnClientClick='<%# "repayFunds(\"" + Eval("noteAddress") + "\"); return false;" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:View>

        <asp:View ID="View3" runat="server">
            <!-- Content for the Completed tab -->
            <div class="table-title">My Completed Financing</div>
            <div class="tables scrollable-gridview">
                <asp:GridView ID="completedTB" runat="server" AutoGenerateColumns="False" >
                    <Columns>
                        <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                        <asp:BoundField DataField="repaymentDate" HeaderText="REPAYMENT DATE" />
                        <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                        <asp:BoundField DataField="interestRate" HeaderText="INTEREST RATE" />
                        <asp:BoundField DataField="repaymentAmt" HeaderText="REPAYMENT AMOUNT" />
                        <asp:BoundField DataField="noteStatus" HeaderText="NOTE STATUS" />
                    </Columns>
                </asp:GridView>
            </div>
        </asp:View>
    </asp:MultiView>

    <asp:HiddenField ID="TableName1" runat="server" />
    <asp:HiddenField ID="hash1" runat="server" />
</asp:Content>
