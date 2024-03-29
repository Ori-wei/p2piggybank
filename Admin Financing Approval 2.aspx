<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Admin Financing Approval 2.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm15" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Financing Approval</title>
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

        async function sendHash(tableName, hash, pkey) {

            if (!isContractInitialized) {
                console.error('Contracts are not initialized.');
                return;
            }

            try {
                const fromAddress = ethereum.selectedAddress || sessionStorage.getItem('publicKey');
                console.log("Attempting to send hash from address: ", fromAddress);

                if (!fromAddress) {
                    console.error('No from address available.');
                    alert('Please ensure your wallet is connected.');
                    return;
                }


                const receipt = await hashHolderAddress.methods.setLatestHash(tableName, hash, pkey).send({ from: fromAddress });
                console.log('Transaction Receipt:', receipt);

                if (receipt.events.HashUpdated) {
                    console.log('Hash updated event:', receipt.events.HashUpdated.returnValues);
                    const tb = receipt.events.HashUpdated.returnValues.tableName;
                    const hsh = receipt.events.HashUpdated.returnValues.hash;
                    const pk = receipt.events.HashUpdated.returnValues.primaryKey;
                    alert('The hash for table ' + tb + ' is updated as ' + hsh + '. Primary key is ' + pk);
                    console.log("page admin finapp, hash sent successfully!");
                } else {
                    console.log('no receipt');
                }

            } catch (error) {
                console.error(error);
                console.log("page admin finapp, hash sent fail!");
                alert('Error sending hash: ' + error.message);
            }
        }

        async function callHash() {
            try {
                console.log("page admin finapp, sending app hash");
                var tableName1 = $('#<%= TableName1.ClientID %>').val();
                var hash1 = $('#<%= hash1.ClientID %>').val();
                var pkey1 = $('#<%= pkey1.ClientID %>').val();
                console.log("tableName is: " + tableName1);
                console.log("hash is: " + hash1);
                console.log("pkey1 is: " + pkey1);
                await sendHash(tableName1, hash1, pkey1);
                console.log("page admin finapp, sending app hash done");

                window.location.href = "Admin Financing Approval 1.aspx";
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
    <div class="detail-box">
        <!--top-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail1" runat="server" AutoGenerateRows="False" DataSourceID="AppSource1" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="appID" HeaderText="Application ID" />
                    <asp:BoundField DataField="appDateTime" HeaderText="Application Datetime" />
                    <asp:BoundField DataField="financingAmt" HeaderText="Financing Amount" />
                    <asp:BoundField DataField="Duration" HeaderText="Duration" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
        <!--top-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail2" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="financingPurpose" HeaderText="Financing Purpose" />
                    <asp:TemplateField HeaderText="Bank Statement">
                        <ItemTemplate>
                            <asp:LinkButton ID="bankStmtApp" runat="server" Text="Download" CssClass="tableButton" CommandName="Statement" CommandArgument='<%# Eval("bankStmtApp") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Liability">
                        <ItemTemplate>
                            <asp:LinkButton ID="Liability" runat="server" Text="Download" CssClass="tableButton" CommandName="Liability" CommandArgument='<%# Eval("Liability") %>' OnCommand="DownloadFile" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Management Account">
                        <ItemTemplate>
                            <asp:LinkButton ID="mgtAcc" runat="server" Text="Download" CssClass="tableButton" CommandName="ManagementAccount" CommandArgument='<%# Eval("mgtAcc") %>' OnCommand="DownloadFile" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
        </div>
    </div>

    <br /><br />
    <!--bottom-->
    <div class="detail-box">
        <!--bottom-left-->
        <div class="form-row">
            <div class="form-field">
                <asp:Label ID="Label1" runat="server" Text="CREDIT RATING" Width="150px"></asp:Label>
                <asp:DropDownList ID="creditRatingDropdown" runat="server" CssClass="aspNetControl" AutoPostBack="true" OnSelectedIndexChanged="creditRatingDdl_SelectedIndexChanged" Width="170px">
                    <asp:ListItem Text="Select Credit Rating" Value=""></asp:ListItem>
                    <asp:ListItem Text="CREDIT A" Value="CREDIT A"></asp:ListItem>
                    <asp:ListItem Text="CREDIT B" Value="CREDIT B"></asp:ListItem>
                    <asp:ListItem Text="CREDIT C" Value="CREDIT C"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="creditRatingDropdown" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
            </div>
            <div class="form-field">
                <asp:Label ID="Label2" runat="server" Text="INTEREST RATE" Width="150px"></asp:Label>
                <asp:TextBox ID="interestRateTxtbx" runat="server" CssClass="aspNetControl" Enabled="false"></asp:TextBox>
            </div>
            <div class="label-with-buttons">
                <asp:Label ID="Label3" runat="server" Text="Decision" Width="120px"></asp:Label>
                <div class="buttons">
                    <asp:Button ID="Approve" runat="server" Text="Approve" CssClass="aspNetControl tableButton" BackColor="#dba83d" ForeColor="white" OnClick="Approve_Click" />
                    <asp:Button ID="Decline" runat="server" Text="Decline" CssClass="aspNetControl tableButton" BackColor="white" ForeColor="#dba83d" OnClick="Decline_Click" />
                </div>
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
    
    <asp:HiddenField ID="TableName1" runat="server" />
    <asp:HiddenField ID="hash1" runat="server" />
    <asp:HiddenField ID="pkey1" runat="server" />
    <asp:HiddenField ID="callScript" runat="server" />
</asp:Content>
