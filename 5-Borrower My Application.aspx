<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="5-Borrower My Application.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm16" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Application</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="table-title">My Application</div>
    <div class="tables scrollable-gridview">
        <asp:GridView ID="myApplicationTB" runat="server" AutoGenerateColumns="false" CssClass="gridview" OnRowDataBound="myApplicationTB_RowDataBound">
            <Columns>
                <asp:BoundField DataField="appID" HeaderText="APPLICATION ID" />
                <asp:BoundField DataField="appDateTime" HeaderText="APPLICATION DATETIME" />
                <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                <asp:BoundField DataField="Duration" HeaderText="DURATION" />
                <asp:BoundField DataField="financingPurpose" HeaderText="FINANCING PURPOSE" />
                <asp:BoundField DataField="status" HeaderText="STATUS" />
                <asp:TemplateField HeaderText="ACTION">
                    <ItemTemplate>
                        <asp:LinkButton ID="viewBtn" runat="server" Text="VIEW" CssClass="tableButton" CommandArgument='<%# Eval("appID") %>' OnCommand="ShowApp" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
