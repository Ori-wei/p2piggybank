<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Admin Financing Approval 1.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm13" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Financing Approval</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="table-title">Financing Approval</div>
    <div class="tables scrollable-gridview">
        <asp:GridView ID="financingAppTB" runat="server" AutoGenerateColumns="false" CssClass="gridview">
            <Columns>
                <asp:BoundField DataField="appID" HeaderText="APPLICATION ID" />
                <asp:BoundField DataField="appDateTime" HeaderText="APPLICATION DATETIME" />
                <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                <asp:BoundField DataField="Duration" HeaderText="DURATION" />
                <asp:BoundField DataField="borrowerID" HeaderText="BORROWER ID" />
                <asp:TemplateField HeaderText="BORROWER DETAILS">
                    <ItemTemplate>
                        <asp:LinkButton ID="borrowerDetails" runat="server" Text="VIEW" CssClass="tableButton" CommandArgument='<%# Eval("borrowerID") %>' OnCommand="ShowBorrower" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="APPLICATION DETAILS">
                    <ItemTemplate>
                        <asp:LinkButton ID="appDetails" runat="server" Text="PROCEED" CssClass="tableButton" CommandArgument='<%# Eval("appID") %>' OnCommand="ShowApp" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
