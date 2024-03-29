<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin Login.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm11" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <title>Admin Login Page</title>
    <link rel="stylesheet" href="Admin Login.css" />
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
                        alert('Successfully signed in!');
                        sessionStorage.setItem('publicKey', account);
                        updateButtonWithAddress(account);
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

            function updateButtonWithAddress(address) {
                const firstSix = address.substring(0, 6);
                const lastSix = address.substring(address.length - 6);
                const shortenedAddress = firstSix + "...." + lastSix;

                var btn = document.getElementById('<%= btnConnectWallet.ClientID %>');

                // Check if the button is an input or a button element
                if (btn.tagName === 'INPUT') {
                    // For input elements like <input type="submit">
                    btn.value = shortenedAddress;
                } else {
                    // For button elements like <button type="submit">
                    btn.innerText = shortenedAddress;
                }

                const publicKey = address;
                document.getElementById('<%= publicKeyHolder.ClientID %>').value = publicKey;
                setSessionPublicKey(publicKey);
            }

            // set hidden field as session variable
            function setSessionPublicKey(publicKey) {
                $.ajax({
                    type: "POST",
                    url: "Test.asmx/SetSessionPublicKey", // Replace with your actual endpoint
                    data: JSON.stringify({ publicKey: publicKey }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log("Session public key set successfully.");
                        window.location.href = "Admin Integrity Check.aspx";
                    },
                    error: function (error) {
                        console.error("Error setting session public key.", error);
                    }
                });
            }

            // Call this function on page load or when the DOM is fully loaded
            function initializeWalletButton() {
                // Check if the wallet address is stored in the session
                const walletAddress = sessionStorage.getItem('publicKey');
                console.log("Wallet address from session storage: " + walletAddress);
                if (walletAddress) {
                    updateButtonWithAddress(walletAddress);
                    console.log("update button success!");
                }
            }

            // Call initializeWalletButton when the document is ready
            document.addEventListener('DOMContentLoaded', initializeWalletButton);

        </script>

        <!--Logo-->
        <div id="logo">
            <img src="images/logo-darkbg2.png" alt="P2PIGGY Logo" />
        </div>
        <!--Admin Module-->
        <div class="formTitle">Admin Module</div>
        <!--Button-->
        <div id="ConnectWalletFrame">
            <asp:Button ID="btnConnectWallet" runat="server" Text="CONNECT WALLET" BackColor="#dba83d" BorderStyle="None" BorderWidth="0px" OnClientClick="signIn(); return false;" />
        </div>

        <asp:HiddenField ID="publicKeyHolder" runat="server" value=""/>
    </form>
</body>
</html>
