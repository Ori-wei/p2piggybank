<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="41-Borrower Apply for Financing 2.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Apply for Financing</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
    <link rel="stylesheet" href="table.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form">
        <script type="text/javascript">
            let hashHolderAddress;

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

            async function callHash() {
                try {
                    console.log("page 41, sending app hash");
                    var tableName1 = $('#<%= TableName1.ClientID %>').val();
                    var hash1 = $('#<%= hash1.ClientID %>').val();
                    var pkey1 = $('#<%= pkey1.ClientID %>').val();
                    console.log("tableName is: " + tableName1);
                    console.log("hash is: " + hash1);
                    console.log("pkey1 is: " + pkey1);
                    await sendHash(tableName1, hash1, pkey1);
                    console.log("page 41, sending app hash done");

                    window.location.href = "42-Borrower Apply for Financing 3.aspx";
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

        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="2/2: Upload Docs"></asp:Label>

        <asp:Label ID="Label2" runat="server" CssClass="formLabel" Text="Latest 3 Months Bank Statement"></asp:Label>
        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="bankStmtApp" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Label ID="Label3" runat="server" CssClass="formLabel" Text="Existing Ongoing Credit Facilities / Financial Liability"></asp:Label>
        <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="liability" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Label ID="Label4" runat="server" CssClass="formLabel" Text="Latest Management Account"></asp:Label>
        <asp:CustomValidator ID="CustomValidator3" runat="server" ErrorMessage="*"
    ClientValidationFunction="ValidateFileUpload" Display="Dynamic" ForeColor="Red" /><br />
        <asp:FileUpload ID="mgtAcc" CssClass="file-upload" runat="server" /><br /><br />

        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Submit >" OnClick="nextBtn_Click" /> <br />
        <asp:Button ID="backBtn" CausesValidation="false" CssClass="formBtn" BackColor="#FFFFFF" runat="server" Text="< Back" ForeColor="#667085" OnClick="backBtn_Click" />
    </div>

    <asp:HiddenField ID="TableName1" runat="server" />
    <asp:HiddenField ID="hash1" runat="server" />
    <asp:HiddenField ID="pkey1" runat="server" />
    <asp:HiddenField ID="callScript" runat="server" />
</asp:Content>
