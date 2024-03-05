<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="Encryption.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm23" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:LinkButton ID="LinkButton1" runat="server" Text="Encrypt" CssClass="tableButton" OnClick="encrypt_Click" />
    <asp:LinkButton ID="LinkButton2" runat="server" Text="Decrypt" CssClass="tableButton" OnClick="decrypt_Click"/>
</asp:Content>
