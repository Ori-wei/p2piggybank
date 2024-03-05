<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Admin Background Verification 1.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm12" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Background Verification</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="table-title">Background Verification</div>
    <div class="tables scrollable-gridview">
        <asp:GridView ID="verificationTB" runat="server" AutoGenerateColumns="false" CssClass="gridview">
            <Columns>
                <asp:BoundField DataField="clientID" HeaderText="ID" />
                <asp:BoundField DataField="fullName" HeaderText="CLIENT NAME" />
                <asp:BoundField DataField="DoB" HeaderText="DATE OF BIRTH" />
                <asp:BoundField DataField="Gender" HeaderText="GENDER" />
                <asp:BoundField DataField="contactNo" HeaderText="CONTACT NO" />
                <asp:BoundField DataField="publicKey" HeaderText="PUBLIC KEY" />
                <asp:TemplateField HeaderText="DETAILS">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" Text="VIEW" CssClass="tableButton" CommandArgument='<%# Eval("clientID") %>' OnCommand="NextPage" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
