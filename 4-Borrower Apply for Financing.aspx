<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="4-Borrower Apply for Financing.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm7" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Apply for Financing</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
    <link rel="stylesheet" href="table.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form" runat="server" id="ApplyForFinancingForm">
        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="1/2: Financing Info"></asp:Label>

        <asp:Label ID="Label2" runat="server" CssClass="formLabel" Text="Financing Amount (ETH)"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="financingAmt" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:TextBox ID="financingAmt" CssClass="formTxtBox" runat="server" placeholder="e.g., 500"></asp:TextBox> <br />

        <asp:Label ID="Label3" runat="server" CssClass="formLabel" Text="Note Duration (Month)"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="noteDuration" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="noteDuration" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>1</asp:ListItem>
            <asp:ListItem>2</asp:ListItem>
            <asp:ListItem>3</asp:ListItem>
            <asp:ListItem>4</asp:ListItem>
            <asp:ListItem>5</asp:ListItem>
            <asp:ListItem>6</asp:ListItem>
            <asp:ListItem>7</asp:ListItem>
            <asp:ListItem>8</asp:ListItem>
            <asp:ListItem>9</asp:ListItem>
            <asp:ListItem>10</asp:ListItem>
            <asp:ListItem>11</asp:ListItem>
            <asp:ListItem>12</asp:ListItem>
        </asp:DropDownList>

        <asp:Label ID="Label4" runat="server" CssClass="formLabel" Text="Financing Purpose"></asp:Label>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="financingPurpose" InitialValue="" ErrorMessage="*" ForeColor="#FF3300"></asp:RequiredFieldValidator>
        <asp:DropDownList CssClass="formDropDown" ID="financingPurpose" runat="server" placeholder="Choose One">
            <asp:ListItem></asp:ListItem>
            <asp:ListItem>Business Expansion</asp:ListItem>
            <asp:ListItem>Working Capital</asp:ListItem>
            <asp:ListItem>Equipment Purchase</asp:ListItem>
            <asp:ListItem>Research and Development</asp:ListItem>
            <asp:ListItem>Hiring Staff</asp:ListItem>
        </asp:DropDownList>

        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Next >" OnClick="nextBtn_Click" /> <br />
        <asp:Button ID="backBtn" CausesValidation="false" CssClass="formBtn" BackColor="#FFFFFF" runat="server" Text="< Back" ForeColor="#667085" OnClick="backBtn_Click" />
    </div>
</asp:Content>
