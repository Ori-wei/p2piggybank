<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="31-Borrower My Profile 2.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Profile</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
    <link rel="stylesheet" href="table.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form">
        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="2/3: Business Info"></asp:Label>

        <asp:Label ID="Label2" runat="server" CssClass="formLabel" Text="Business Name"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="bizName" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="bizName" CssClass="formTxtBox" runat="server" placeholder="Your Business Name"></asp:TextBox> <br />

        <asp:Label ID="Label3" runat="server" CssClass="formLabel" Text="Business Registration Number"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="bizRegNo" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="bizRegNo" CssClass="formTxtBox" runat="server" placeholder="e.g., 901118438856"></asp:TextBox> <br />

        <asp:Label ID="Label4" runat="server" CssClass="formLabel" Text="Business Address"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="bizAdd" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="bizAdd" CssClass="formTxtBox" runat="server" placeholder="e.g., Bukit Jalil, Kuala Lumpur 57000, Malaysia."></asp:TextBox> <br />

        <asp:Label ID="Label7" runat="server" CssClass="formLabel" Text="Business Contact"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="bizContact" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="bizContact" CssClass="formTxtBox" runat="server" placeholder="e.g., 0323528977"></asp:TextBox> <br />

        <asp:Label ID="Label5" runat="server" CssClass="formLabel" Text="Business Industry"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="bizIndustry" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="bizIndustry" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Technology</asp:ListItem>
            <asp:ListItem>Healthcare</asp:ListItem>
            <asp:ListItem>Finance</asp:ListItem>
            <asp:ListItem>Retail</asp:ListItem>
            <asp:ListItem>Manufacturing</asp:ListItem>
            <asp:ListItem>Education</asp:ListItem>
        </asp:DropDownList>

        <asp:Label ID="Label6" runat="server" CssClass="formLabel" Text="Legal Entity Type"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="entityType" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="entityType" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Sole Proprietorship/ Partnership</asp:ListItem>
            <asp:ListItem>Private Limited Company (Sdn. Bhd.)</asp:ListItem>
            <asp:ListItem>Public Limited Company (Berhad)</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Next >" OnClick="nextBtn_Click" CausesValidation="True" /> <br />
        <asp:Button ID="backBtn" CausesValidation="false" CssClass="formBtn" BackColor="#FFFFFF" runat="server" Text="< Back" ForeColor="#667085" OnClick="backBtn_Click" />
    </div>
</asp:Content>
