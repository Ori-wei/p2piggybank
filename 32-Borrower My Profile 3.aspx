<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="32-Borrower My Profile 3.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm5" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Profile</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
    <link rel="stylesheet" href="table.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form">
        <script>
            let hashHolderAddress;

            // Fetch contract data and initialize hashHolder contract
            async function fetchHashHolderAddress() {
                try {
                    const response = await fetch('../build/contracts/HashHolder.json');
                    const data = await response.json();
                    const abi = data.abi;
                    const networkId = '5777';
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

            async function sendHash(tableNames, hashes, pkeys) {

                if (!isContractInitialized) {
                    console.error('Contracts are not initialized.');
                    return;
                }

                try {
                    const receipt = await hashHolderAddress.methods.setMultipleLatestHashes(tableNames, hashes, pkeys
                    ).send({ from: ethereum.selectedAddress });
                    console.log('Transaction Receipt:', receipt);

                    if (receipt.events.HashUpdated) {
                        console.log('Hash updated event:', receipt.events.HashUpdated.returnValues);

                        // If there's only one event, it may not be an array; handle both cases
                        const hashUpdatedEvents = Array.isArray(receipt.events.HashUpdated
                        ) ? receipt.events.HashUpdated : [receipt.events.HashUpdated];
                        hashUpdatedEvents.forEach((event) => {
                            const tb = event.returnValues.tableName;
                            const hsh = event.returnValues.hash;
                            const pk = event.returnValues.primaryKey;
                            console.log(`Hash for table ${tb} updated. Hash: ${hsh}, Primary key: ${pk}`);
                            alert(`Hash for table ${tb} updated. Hash: ${hsh}, Primary key: ${pk}`);
                        });
                        console.log("page 32, hash sent successfully!");
                    } else {
                        console.log('No HashUpdated events found in receipt.');
                    }

                } catch (error) {
                    console.error(error);
                    console.log("page 32, hash sent fail!");
                    alert('Error sending hash: ' + error.message);
                }
            }

            async function callHash() {
                try {
                    var tableName1 = $('#<%= TableName1.ClientID %>').val();
                    var hash1 = $('#<%= hash1.ClientID %>').val();
                    var pkey1 = $('#<%= pkey1.ClientID %>').val();

                    console.log("page 32, sending client hash");
                    console.log("tableName is: " + tableName1);
                    console.log("hash is: " + hash1);
                    console.log("hash is: " + pkey1);
                    console.log("page 32, sending client hash done");
                
                    console.log("page 32, sending borrower hash");
                    var tableName2 = $('#<%= TableName2.ClientID %>').val();
                    var hash2 = $('#<%= hash2.ClientID %>').val();
                    var pkey2 = $('#<%= pkey2.ClientID %>').val();

                    console.log("tableName is: " + tableName2);
                    console.log("hash is: " + hash2);
                    console.log("hash is: " + pkey2);
                    console.log("page 32, sending borrower hash done");

                    if (hash1 != null) {
                        await sendHash([tableName1, tableName2], [hash1, hash2], [pkey1, pkey2]);
                    } else {
                        await sendHash([tableName2], [hash2], [pkey2]);
                    }

                    window.location.href = "33-Borrower_Lender My Profile 4.aspx";
                } catch (error) {
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

            function ValidateFileUpload(source, arguments) {
                var fileUpload = document.getElementsByClassName('file-upload')[0];
                // Check if any file has been selected.
                arguments.IsValid = fileUpload.value !== '';
            }
        </script>

        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="3/3: Upload Docs"></asp:Label>

        <asp:Label ID="Label2" runat="server" CssClass="formLabel" Text="Business Registration Certificate (e.g., SSM)"></asp:Label>
        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="bizCert" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Label ID="Label3" runat="server" CssClass="formLabel" Text="Latest Utility Bill"></asp:Label>
        <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="utilityBill" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Label ID="Label4" runat="server" CssClass="formLabel" Text="Certificate of Incorportion of Company/ Form 9"></asp:Label>
        <asp:CustomValidator ID="CustomValidator3" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="form9" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Label ID="Label5" runat="server" CssClass="formLabel" Text="6 Months Bank Statement"></asp:Label>
        <asp:CustomValidator ID="CustomValidator4" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="bankStmt" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Label ID="Label6" runat="server" CssClass="formLabel" Text="Owner Identity Card (For Verification)"></asp:Label>
        <asp:CustomValidator ID="CustomValidator5" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="icDoc" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Save >" OnClick="nextBtn_Click" CausesValidation="True" /> <br />
        <asp:Button ID="backBtn" CausesValidation="false" CssClass="formBtn" BackColor="#FFFFFF" runat="server" Text="< Back" ForeColor="#667085" OnClick="backBtn_Click" />
    </div>

    <asp:HiddenField ID="TableName1" runat="server" />
    <asp:HiddenField ID="hash1" runat="server" />
    <asp:HiddenField ID="pkey1" runat="server" />
    <asp:HiddenField ID="TableName2" runat="server" />
    <asp:HiddenField ID="hash2" runat="server" />
    <asp:HiddenField ID="pkey2" runat="server" />
    <asp:HiddenField ID="callScript" runat="server" />
</asp:Content>
