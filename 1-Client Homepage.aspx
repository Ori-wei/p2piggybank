<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="1-Client Homepage.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Homepage</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="table-title">Notes Available for Investment</div>
    <div class="tables scrollable-gridview">
        <asp:GridView ID="noteTable" runat="server" AutoGenerateColumns="False" >
            <Columns>
                <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                <asp:BoundField DataField="interestRate" HeaderText="PROFIT RATE" />
                <asp:BoundField DataField="Duration" HeaderText="MONTHS" />
                <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                <asp:BoundField DataField="fundedToDate" HeaderText="FUNDED TO DATE" />
                <asp:BoundField DataField="remainingAmt" HeaderText="REMAINING AMOUNT" />
                <asp:TemplateField HeaderText="ACTION">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" Text="VIEW" CssClass="tableButton" CommandArgument='<%# Eval("noteAddress") %>' OnCommand="ShowNote"/>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
