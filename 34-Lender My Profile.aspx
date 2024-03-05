<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="34-Lender My Profile.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm10" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Profile</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
    <link rel="stylesheet" href="table.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form" runat="server" id="CreateProfileForm">
        <script>
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

            async function callHash() {
                try {
                    var tableName1 = $('#<%= TableName1.ClientID %>').val();
                    var hash1 = $('#<%= hash1.ClientID %>').val();
                    var pkey1 = $('#<%= pkey1.ClientID %>').val();

                    console.log("page 34, sending client hash");
                    console.log("tableName is: " + tableName1);
                    console.log("hash is: " + hash1);
                    console.log("pkey is: " + pkey1);
                    console.log("page 34, sending client hash done");
                    
                
                    console.log("page 34, sending lender hash");
                    var tableName2 = $('#<%= TableName2.ClientID %>').val();
                    var hash2 = $('#<%= hash2.ClientID %>').val();
                    var pkey2 = $('#<%= pkey2.ClientID %>').val();
                    console.log("tableName is: " + tableName2);
                    console.log("hash is: " + hash2);
                    console.log("pkey is: " + pkey2);
                    console.log("page 34, sending lender hash done");

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

            function validateIC() {
                PageMethods.CheckICExists(document.getElementById('<%= ic.ClientID %>').value, onCheckComplete);
            }

            function onCheckComplete(result) {
                if (result === "exists") {
                    document.getElementById('<%= lblICValidation.ClientID %>').innerText = "IC exists in database.";
                } else {
                    document.getElementById('<%= lblICValidation.ClientID %>').innerText = "";
                    document.getElementById('<%= dob.ClientID %>').value = result;
                }
            }
        </script>
        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="Complete Profile"></asp:Label>

        <asp:Label ID="Label2" runat="server" CssClass="formLabel" Text="Full Name"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fullName" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="fullName" CssClass="formTxtBox" runat="server" placeholder="e.g., Adam Smith"></asp:TextBox> <br />

        <asp:Label ID="Label3" runat="server" CssClass="formLabel" Text="Identity Card/ Passport Number"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ic" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:Label ID="lblICValidation" runat="server" ForeColor="#FF3300" />
        <asp:TextBox ID="ic" CssClass="formTxtBox" runat="server" placeholder="e.g., 901118438856"></asp:TextBox> <br />

        <asp:Label ID="Label4" runat="server" CssClass="formLabel" Text="Date of Birth"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="dob" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="dob" ForeColor="#FF3300" ErrorMessage="Date must be in the format DD-MM-YYYY" ValidationExpression="^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$" ></asp:RegularExpressionValidator>
        <asp:TextBox ID="dob" CssClass="formTxtBox" runat="server" placeholder="e.g., 18-11-1990"></asp:TextBox> <br />

        <asp:Label ID="Label5" runat="server" CssClass="formLabel" Text="Gender"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="gender" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="gender" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Male</asp:ListItem>
            <asp:ListItem>Female</asp:ListItem>
        </asp:DropDownList>

        <asp:Label ID="Label6" runat="server" CssClass="formLabel" Text="Contact Number"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="contactNo" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="contactNo" CssClass="formTxtBox" runat="server" placeholder="e.g., 012-345 6789"></asp:TextBox> <br />

        <asp:Label ID="Label7" runat="server" CssClass="formLabel" Text="Identity Verification Document (PDF only)"></asp:Label><br />
        <asp:FileUpload ID="icDocUpload" CssClass="file-upload" runat="server" />
        <br /><br />

        <asp:Label ID="Label8" runat="server" CssClass="formLabel" Text="Annual Income"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="annualIncome" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="annualIncome" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Below RM30,000</asp:ListItem>
            <asp:ListItem>RM30,001 - RM50,000</asp:ListItem>
            <asp:ListItem>RM50,001 - RM70,000</asp:ListItem>
            <asp:ListItem>RM70,001 - RM100,000</asp:ListItem>
            <asp:ListItem>Above RM100,000</asp:ListItem>
        </asp:DropDownList>

        <asp:Label ID="Label9" runat="server" CssClass="formLabel" Text="Risk Tolerance"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="riskTolerance" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="riskTolerance" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Conservative</asp:ListItem>
            <asp:ListItem>Moderately Conservative</asp:ListItem>
            <asp:ListItem>Moderate</asp:ListItem>
            <asp:ListItem>Moderately Aggressive</asp:ListItem>
            <asp:ListItem>Aggressive</asp:ListItem>
        </asp:DropDownList>

        <asp:CheckBox ID="riskAck" runat="server" Text="By proceeding, I acknowledge that all investments carry inherent risks, including the potential loss of principal." />

        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Next >" OnClick="nextBtn_Click" CausesValidation="True" /> <br />
        <asp:Button ID="backBtn" CausesValidation="false" CssClass="formBtn" BackColor="#FFFFFF" runat="server" Text="< Back" ForeColor="#667085" OnClick="backBtn_Click"  />
    </div>

    <asp:HiddenField ID="TableName1" runat="server" />
    <asp:HiddenField ID="hash1" runat="server" />
    <asp:HiddenField ID="pkey1" runat="server" />
    <asp:HiddenField ID="TableName2" runat="server" />
    <asp:HiddenField ID="hash2" runat="server" />
    <asp:HiddenField ID="pkey2" runat="server" />
    <asp:HiddenField ID="callScript" runat="server" />
</asp:Content>
