<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Admin Background Verification 2.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm14" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>User Profile</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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

        async function requestAccount() {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            return accounts[0];
        }

        async function sendHash(tableName, hash, pkey) {

            if (!isContractInitialized) {
                console.error('Contracts are not initialized.');
                return;
            }

            try {
                const account = await requestAccount();
                ethereum.selectedAddress = account;
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
                console.log("page admin bgv2, sending app hash");
                var tableName1 = $('#<%= TableName1.ClientID %>').val();
                var hash1 = $('#<%= hash1.ClientID %>').val();
                var pkey1 = $('#<%= pkey1.ClientID %>').val();
                console.log("tableName is: " + tableName1);
                console.log("hash is: " + hash1);
                console.log("pkey1 is: " + pkey1);
                await sendHash(tableName1, hash1, pkey1);
                console.log("page admin bgv2, sending app hash done");

                window.location.href = "Admin Background Verification 2.aspx";
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
    
    <!--top-->
    <div class="table-title">Client Details</div>
    <div class="detail-box">
        <!--top-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail1" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="icNo" HeaderText="IC Number" />
                    <asp:BoundField DataField="fullName" HeaderText="Full Name" />
                    <asp:BoundField DataField="DoB" HeaderText="Date of Birth" />
                    <asp:BoundField DataField="Gender" HeaderText="Gender" />
                </Fields>
            </asp:DetailsView>
        </div>
        <!--top-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail2" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10" OnDataBound="AppDetail2_DataBound">
                <Fields>
                    <asp:BoundField DataField="contactNo" HeaderText="Contact Number" />
                    <asp:TemplateField HeaderText="IC Document">
                        <ItemTemplate>
                            <asp:LinkButton ID="icDoc" runat="server" Text="Download" CssClass="tableButton" CommandArgument='<%# Eval("icDoc") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="publicKey" HeaderText="Public Key" />
                    <asp:BoundField DataField="status" HeaderText="Status" />
                </Fields>
            </asp:DetailsView>
            <asp:LinkButton ID="verifyButton" runat="server" Text="Verify" OnClick="verifyButton_Click" CssClass="tableButton" />
        </div>
    </div>

    <br /><br />
    <!--middle-->
    <div class="table-title" id="borrowerTitle" runat="server">Borrower Details</div>
    <div class="detail-box" id="detailContainer1" runat="server">
        <!--middle-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail3" runat="server" AutoGenerateRows="False" DataSourceID="AppSource3" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="borrowerID" HeaderText="Borrower ID" />
                    <asp:BoundField DataField="bizName" HeaderText="Business Name" />
                    <asp:BoundField DataField="bizRegNo" HeaderText="Business Registration No" />
                    <asp:BoundField DataField="bizAdd" HeaderText="Business Address" />
                    <asp:BoundField DataField="bizContact" HeaderText="Business Contact" />
                    <asp:BoundField DataField="bizIndustry" HeaderText="Business Industry" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
        <!--middle-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail4" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="entityType" HeaderText="Entity Type" />
                    <asp:TemplateField HeaderText="Business Cert">
                        <ItemTemplate>
                            <asp:LinkButton ID="bizCert" runat="server" Text="Download" CssClass="tableButton" CommandArgument='bizCert,<%# Eval("bizCert") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Utility Bill">
                        <ItemTemplate>
                            <asp:LinkButton ID="utilityBill" runat="server" Text="Download" CssClass="tableButton" CommandArgument='utilityBill,<%# Eval("utilityBill") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Form 9">
                        <ItemTemplate>
                            <asp:LinkButton ID="form9" runat="server" Text="Download" CssClass="tableButton" CommandArgument='form9,<%# Eval("form9") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bank Statement">
                        <ItemTemplate>
                            <asp:LinkButton ID="bankStmt" runat="server" Text="Download" CssClass="tableButton" CommandArgument='bankStmt,<%# Eval("bankStmt") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
        </div>
    </div>

    <br /><br />
    <!--bottom-->
    <div class="table-title" id="lenderTitle" runat="server">Lender Details</div>
    <div class="detail-box" id="detailContainer2" runat="server">
        <!--bottom-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail5" runat="server" AutoGenerateRows="False" DataSourceID="AppSource5" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="lenderID" HeaderText="Lender ID" />
                    <asp:BoundField DataField="annualIncome" HeaderText="Annual Income" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource5" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
        <!--bottom-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail6" runat="server" AutoGenerateRows="False" DataSourceID="AppSource6" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="riskTolerance" HeaderText="Risk Tolerance" />
                    <asp:BoundField DataField="riskAck" HeaderText="Risk Acknowledgement" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource6" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
    </div>

    <br />
    <asp:Button ID="Button1" runat="server" Text="< Back " CssClass="aspNetControl tableButton" OnClick="Back_Click" />

    <asp:HiddenField ID="TableName1" runat="server" />
    <asp:HiddenField ID="hash1" runat="server" />
    <asp:HiddenField ID="pkey1" runat="server" />
    <asp:HiddenField ID="callScript" runat="server" />
</asp:Content>
