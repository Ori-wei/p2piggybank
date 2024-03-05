<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Admin Integrity Check.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm21" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Integrity Check</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        var table1;
        var table2;
        var table3;
        var table4;
        var table5;

        let hashHolderAddress;

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
        fetchHashHolderAddress();

        // function to call
        async function checkTable() {
            await retrieveAndCompareLatestHash('Client');
            await retrieveAndCompareLatestHash('Borrower');
            await retrieveAndCompareLatestHash('Lender');
            await retrieveAndCompareLatestHash('App');
            await retrieveAndCompareLatestHash('Note');

            updateIntegrityTable(table1, table2, table3, table4, table5);
        }

        // gather contract and db hash
        async function retrieveAndCompareLatestHash(tableName) {
            try {
                // 1- getLatestHash from contract and database
                // retrieve hash from contract
                await getHashfromContract(tableName);
                var hashfromContract = $('#<%= hashContract.ClientID %>').val();
                var pkey = $('#<%= primaryKeyContract.ClientID %>').val();
            
                // retrieve from database
                await getHashfromDb(tableName, pkey);
                var hashfromDB = $('#<%= hashDB.ClientID %>').val();

                // 2- compare hash
                let comparisonResult;
                if (hashfromContract == hashfromDB) {
                    comparisonResult = "matched";
                } else {
                    comparisonResult = "unmatched";
                }

                // 3- send result to aspx
                let hashContract = hashfromContract.substring(0, 5) + "..." + hashfromContract.substring(hashfromContract.length - 5);
                let hashDB = hashfromDB.substring(0, 5) + "..." + hashfromDB.substring(hashfromDB.length - 5);

                console.log("Hash from Contract:", hashContract);
                console.log("Hash from DB:", hashDB);
                console.log("Comparison hash result: " + comparisonResult);

                // create object
                if (tableName == 'Client') {
                    table1 = {
                        tableName: tableName,
                        primaryKey: pkey,
                        hashContract: hashContract,
                        hashDB: hashDB,
                        comparisonResult: comparisonResult
                    };
                }
                if (tableName == 'Borrower') {
                    table2 = {
                        tableName: tableName,
                        primaryKey: pkey,
                        hashContract: hashContract,
                        hashDB: hashDB,
                        comparisonResult: comparisonResult
                    };
                }
                if (tableName == 'Lender') {
                    table3 = {
                        tableName: tableName,
                        primaryKey: pkey,
                        hashContract: hashContract,
                        hashDB: hashDB,
                        comparisonResult: comparisonResult
                    };
                }
                if (tableName == 'App') {
                    table4 = {
                        tableName: tableName,
                        primaryKey: pkey,
                        hashContract: hashContract,
                        hashDB: hashDB,
                        comparisonResult: comparisonResult
                    };
                }
                if (tableName == 'Note') {
                    table5 = {
                        tableName: tableName,
                        primaryKey: pkey,
                        hashContract: hashContract,
                        hashDB: hashDB,
                        comparisonResult: comparisonResult
                    };
                }

                console.log('js table object: ' + table1.tableName + table1.hashContract);
                console.log('js table object: ' + table2.tableName + table2.hashContract);
                console.log('js table object: ' + table3.tableName + table3.hashContract);
                console.log('js table object: ' + table4.tableName + table4.hashContract);
                console.log('js table object: ' + table5.tableName + table5.hashContract);
                //await updateIntegrityTable(tableName, hashContract, hashDB, comparisonResult);
                //window.location.href = 'Admin Integrity Check.aspx';
            } catch (error) {
                console.error("Error in comparing hashes: ", error);
            }
        }

        async function updateIntegrityTable(table1, table2, table3, table4, table5) {
            try {
                const response = await $.ajax({
                    url: 'Admin Integrity Check.asmx/UpdateComparisonResults',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        table1: table1,
                        table2: table2,
                        table3: table3,
                        table4: table4,
                        table5: table5
                    }),
                    success: function (response) {
                        console.log('create session list done, trigger postback start');
                        __doPostBack('UpdatePanel1', '');
                    },
                    error: function (xhr, status, error) {
                        console.error('Error updating integrity data to C#:. Status:', status,
                            'Error: ', error, 'Response: ', xhr.responseText);
                    }
                });
                console.log('integrity table udpated to C# successfully:', response);
            } catch (error) {
                console.error('Error updating integrity table:', error);
            }
        }

        // smart contract
        async function getHashfromContract(tableName) {
            try {
                const result = await hashHolderAddress.methods.getLatestHash(tableName).call();

                if (result) {
                    const pk = result[0];
                    const hsh = result[1];
                    console.log("The latest hash for " + tableName + " is: " + hsh + ". Primary key is " + pk);

                    // Set the values of hidden fields
                    $('#<%= hashContract.ClientID %>').val(hsh);
                    $('#<%= primaryKeyContract.ClientID %>').val(pk);

                    console.log("Hidden fields updated with Hash.");
                }
                else {
                    console.log('Hash data not retrieved from smart contract.');
                }

            } catch (error) {
                console.error("Error in retrieving hash from smart contract: ", error);
            }
        }

        // database
        function getHashfromDb(tableName, primaryKey) {
            return $.ajax({
                url: 'Admin Integrity Check.asmx/AllocateFunction',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ tableName: tableName, primaryKey: primaryKey }),
                success: function (response) {
                    var hashDB = response.d;
                    console.log('hash note retrieved successfully:', hashDB);
                    $('#<%= hashDB.ClientID %>').val(hashDB);
                },
                error: function (error) {
                    console.error('Error sending funding data to C#:', error);
                }
            });
        }
    </script>
    <div class="table-title">Integrity Check</div>
    <br /><br />
    <asp:LinkButton ID="LinkButton1" runat="server" Text="CHECK" CssClass="tableButton" OnClientClick="checkTable(); return false;"/>
    <div>
        <!--from contract-->
        <asp:HiddenField ID="hashContract" runat="server" />
        <asp:HiddenField ID="primaryKeyContract" runat="server" />
        <asp:HiddenField ID="hashDB" runat="server" />
    </div>

    <div>

    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <div class="tables scrollable-gridview">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:GridView ID="ComparisonResults" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="tableName" HeaderText="Table Name" />
                        <asp:BoundField DataField="primaryKey" HeaderText="Primary Key" />
                        <asp:BoundField DataField="hashContract" HeaderText="Hash From Contract" />
                        <asp:BoundField DataField="hashDB" HeaderText="Hash From Database" />
                        <asp:BoundField DataField="comparisonResult" HeaderText="Comparison Result" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    
    <asp:Button ID="OkButton" runat="server" Text="OK" CssClass="tableButton" OnClick="OkButton_Click" Visible="false" />
</asp:Content>
