<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="01-Client Identity.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm25" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Choose Identity</title>
    <link href="0-Client Login Page.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 

    <h1>What are you looking for?</h1>

    <div class="container">
        <!--Borrow-->
        <div class="column">
            <h1>BORROW</h1>
            <p>I'm looking for funds</p>
        </div>

        <!--Invest-->
        <div class="column">
            <h1>INVEST</h1>
            <p>I'm looking for opportunities</p>
        </div>
    </div>
    
</asp:Content>
