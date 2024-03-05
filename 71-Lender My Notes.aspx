<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="71-Lender My Notes.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm19" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>My Notes</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="tab-container">
        <asp:LinkButton ID="investedTab" runat="server" CssClass="tab-button" OnClick="InvestedTab_Click">Invested</asp:LinkButton>
        <asp:LinkButton ID="servicingTab" runat="server" CssClass="tab-button" OnClick="ServicingTab_Click">Servicing</asp:LinkButton>
        <asp:LinkButton ID="completedTab" runat="server" CssClass="tab-button" OnClick="CompletedTab_Click">Completed</asp:LinkButton>
    </div>

    <br />

    <asp:MultiView ID="MultiView1" runat="server">

        <asp:View ID="View1" runat="server">
            <!-- Content for the Repayment tab -->
            <div class="tables scrollable-gridview">
                <asp:GridView ID="investedTB" runat="server" AutoGenerateColumns="False" >
                    <Columns>
                        <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                        <asp:BoundField DataField="interestRate" HeaderText="RETURN RATE" />
                        <asp:BoundField DataField="Duration" HeaderText="DURATION" />
                        <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                        <asp:BoundField DataField="investedAmt" HeaderText="INVESTED AMOUNT" />
                        <asp:BoundField DataField="listedEndDate" HeaderText="LISTED END DATE" />
                    </Columns>
                </asp:GridView>
            </div>
        </asp:View>

        <asp:View ID="View2" runat="server">
            <!-- Content for the Repayment tab -->
            <div class="tables scrollable-gridview">
                <asp:GridView ID="servicingTB" runat="server" AutoGenerateColumns="False" >
                    <Columns>
                        <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                        <asp:BoundField DataField="interestRate" HeaderText="RETURN RATE" />
                        <asp:BoundField DataField="Duration" HeaderText="DURATION" />
                        <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                        <asp:BoundField DataField="investedAmt" HeaderText="INVESTED AMOUNT" />
                        <asp:BoundField DataField="repaymentDate" HeaderText="MATURITY DATE" />
                    </Columns>
                </asp:GridView>
            </div>
        </asp:View>

        <asp:View ID="View3" runat="server">
            <!-- Content for the Completed tab -->
            <div class="tables scrollable-gridview">
                <asp:GridView ID="completedTB" runat="server" AutoGenerateColumns="False" >
                    <Columns>
                        <asp:BoundField DataField="noteAddress" HeaderText="NOTE ADDRESS" />
                        <asp:BoundField DataField="interestRate" HeaderText="RETURN RATE" />
                        <asp:BoundField DataField="Duration" HeaderText="DURATION" />
                        <asp:BoundField DataField="financingAmt" HeaderText="FINANCING AMOUNT" />
                        <asp:BoundField DataField="investedAmt" HeaderText="INVESTED AMOUNT" />
                        <asp:BoundField DataField="repaymentDate" HeaderText="MATURITY DATE" />
                        <asp:BoundField DataField="noteStatus" HeaderText="NOTE STATUS" />
                    </Columns>
                </asp:GridView>
            </div>
        </asp:View>
    </asp:MultiView>

</asp:Content>
