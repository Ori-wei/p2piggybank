<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="0-Client Login Page.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform._0_Client_Login_Page" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Client Login Page</title>
    <link href="0-Client Login Page.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/web3@1.5.0/dist/web3.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <script>
            let web3 = new Web3(window.ethereum);
            const message = "Please sign this message to confirm your identity.";

            async function requestAccount() {
                const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
                return accounts[0];
            }

            async function signIn() {
                try {
                    const account = await requestAccount();
                    const signature = await web3.eth.personal.sign(message, account, '');

                    const isVerified = await verifySignature(account, signature);
                    if (isVerified) {
                        sessionStorage.setItem('publicKey', account);
                        setSessionPublicKey(account);
                        window.location.href = "1-Client Homepage.aspx";
                    } else {
                        alert('Failed to sign in!');
                    }
                } catch (error) {
                    console.error(error);
                    alert('Error signing in: ' + error.message);
                }
            }

            async function verifySignature(account, signature) {
                const signer = await web3.eth.personal.ecRecover(message, signature);
                return signer.toLowerCase() === account.toLowerCase();
            }

            // set public Key as session variable
            function setSessionPublicKey(publicKey) {
                $.ajax({
                    type: "POST",
                    url: "Test.asmx/SetSessionPublicKey",
                    data: JSON.stringify({ publicKey: publicKey }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log("Session public key set successfully.");
                        if (!sessionStorage.getItem('redirected')) {
                            sessionStorage.setItem('redirected', 'true');
                            window.location.href = '1-Client Homepage.aspx';
                        }
                    },
                    error: function (error) {
                        console.error("Error setting session public key.", error);
                    }
                });
            }
        </script>

        <div class="container">
            <!--Left-->
            <!--Logo-->
            <div class="column">
                <img src="images/logo-darkbg2.png" alt="P2Piggy Logo" class="logo" />
            </div>

            <!--Right-->
            <div class="column">
                <!--Headline-->
                <div class="headline">
                    <p>Where Your Crypto Journey </p>
                    <p>Meets <span style="color: #dba83d;">Trustworthy Lending</span>.</p>
                </div>

                <!--Connnect Wallet-->
                <div id="ConnectWalletFrame">
                <asp:Button ID="btnConnectWallet" runat="server" Text="CONNECT WALLET" 
                    BackColor="#dba83d" BorderStyle="None" BorderWidth="0px" OnClientClick="signIn(); return false;" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
