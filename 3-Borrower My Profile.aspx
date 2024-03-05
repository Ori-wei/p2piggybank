<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="3-Borrower My Profile.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Profile</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function createDOB() {
            PageMethods.CreateDOBstring(document.getElementById('<%= icNo.ClientID %>').value, onCheckComplete);
        }

        function onCheckComplete(result) {
            if (result !== null) {
                document.getElementById('<%= lblICValidation.ClientID %>').innerText = "";
                document.getElementById('<%= dob.ClientID %>').value = result; // Set DOB
            } else {
                document.getElementById('<%= lblICValidation.ClientID %>').innerText = "Invalid IC number.";
            }
        }
    </script>

    <div class="form" runat="server" id="CreateProfileForm">
        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="1/3: Personal Info"></asp:Label>

        <asp:Label ID="Label2" runat="server" CssClass="formLabel" Text="Full Name"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fullName" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="fullName" CssClass="formTxtBox" runat="server" placeholder="e.g., Adam Smith"></asp:TextBox> <br />

        <asp:Label ID="Label3" runat="server" CssClass="formLabel" Text="Identity Card/ Passport Number"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="icNo" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:Label ID="lblICValidation" runat="server" ForeColor="#FF3300" />
        <asp:TextBox ID="icNo" CssClass="formTxtBox" runat="server" placeholder="e.g., 901118438856" ></asp:TextBox> <br />

        <asp:Label ID="Label4" runat="server" CssClass="formLabel" Text="Date of Birth"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="DoB" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="DoB" ForeColor="#FF3300" ErrorMessage="Date must be in the format DD-MM-YYYY" ValidationExpression="^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-(19|20)\d\d$" ></asp:RegularExpressionValidator>
        <asp:TextBox ID="dob" CssClass="formTxtBox" runat="server" placeholder="DD-MM-YYYY, e.g., 03-11-1990"></asp:TextBox> <br />

        <asp:Label ID="Label5" runat="server" CssClass="formLabel" Text="Gender"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="gender" InitialValue="" ErrorMessage="*" ForeColor="#FF3300" />
        <asp:DropDownList CssClass="formDropDown" ID="gender" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Male</asp:ListItem>
            <asp:ListItem>Female</asp:ListItem>
        </asp:DropDownList>

        <asp:Label ID="Label6" runat="server" CssClass="formLabel" Text="Contact Number"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="contactNo" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="contactNo" CssClass="formTxtBox" runat="server" placeholder="e.g., 011-3455 6789"></asp:TextBox> <br />

        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Next >" OnClick="nextBtn_Click" CausesValidation="True" /> <br />
        <asp:Button ID="backBtn" CausesValidation="false" CssClass="formBtn" BackColor="#FFFFFF" runat="server" Text="< Back" ForeColor="#667085" />
    </div>
</asp:Content>
                            

