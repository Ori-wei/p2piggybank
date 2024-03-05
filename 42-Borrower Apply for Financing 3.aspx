﻿<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="42-Borrower Apply for Financing 3.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Apply for Financing</title>
    <link rel="stylesheet" href="3-Borrower My Profile.css" />
    <link rel="stylesheet" href="table.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="form">
        <asp:Label ID="Label1" runat="server" CssClass="formTitle" Text="Thank you for your registration!"></asp:Label>

        <div class="message-container">
            <p>
            Your application is pending review. Please allow 2-3 days for your application to be approved. <br /><br />
            Thank you for your patience.
            </p>
        </div>
        <asp:Button ID="nextBtn" CssClass="formBtn" BackColor="#AFBCD5" runat="server" Text="Proceed >" OnClick="nextBtn_Click" /> <br />
    </div>
</asp:Content>
