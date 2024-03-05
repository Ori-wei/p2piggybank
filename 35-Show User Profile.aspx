<%@ Page Title="" Language="C#" MasterPageFile="~/0-Client Template.Master" AutoEventWireup="true" CodeBehind="35-Show User Profile.aspx.cs" Inherits="Loh_Yuen_Wei_TP063508_FYP_P2P_Lending_Platform.WebForm20" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>User Profile</title>
    <link rel="stylesheet" href="tables.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!--top-->
    <div class="table-title">Client Details</div>
    <div class="detail-box">
        <!--top-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail1" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="icNo" HeaderText="IC Number" />
                    <asp:BoundField DataField="fullName" HeaderText="Full Name" />
                    <asp:BoundField DataField="DoB" HeaderText="Date of Birth"/>
                    <asp:BoundField DataField="Gender" HeaderText="Gender" />
                </Fields>
            </asp:DetailsView>
            
        </div>
        <!--top-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail2" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10" OnDataBound="AppDetail2_DataBound">
                <Fields>
                    <asp:BoundField DataField="contactNo" HeaderText="Contact Number" />
                    <asp:TemplateField HeaderText="IC Document">
                        <ItemTemplate>
                            <asp:LinkButton ID="icDoc" runat="server" Text="Download" CssClass="tableButton" CommandArgument='<%# Eval("icDoc") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="publicKey" HeaderText="Public Key" />
                    <asp:BoundField DataField="status" HeaderText="Status" />
                </Fields>
            </asp:DetailsView>
        </div>
    </div>

    <br /><br />
    <!--middle-->
    <div class="table-title" runat="server" id="borrowerTitle">Borrower Details</div>
    <div class="detail-box" runat="server" id="detailContainer1">
        <!--middle-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail3" runat="server" AutoGenerateRows="False" DataSourceID="AppSource3" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="borrowerID" HeaderText="Borrower ID" />
                    <asp:BoundField DataField="bizName" HeaderText="Business Name" />
                    <asp:BoundField DataField="bizRegNo" HeaderText="Business Registration No" />
                    <asp:BoundField DataField="bizAdd" HeaderText="Business Address" />
                    <asp:BoundField DataField="bizContact" HeaderText="Business Contact" />
                    <asp:BoundField DataField="bizIndustry" HeaderText="Business Industry" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
        <!--middle-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail4" runat="server" AutoGenerateRows="False" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="entityType" HeaderText="Entity Type" />
                    <asp:TemplateField HeaderText="Business Cert">
                        <ItemTemplate>
                            <asp:LinkButton ID="bizCert" runat="server" Text="Download" CssClass="tableButton" CommandArgument='<%# Eval("bizCert") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Utility Bill">
                        <ItemTemplate>
                            <asp:LinkButton ID="utilityBill" runat="server" Text="Download" CssClass="tableButton" CommandArgument='<%# Eval("utilityBill") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Form 9">
                        <ItemTemplate>
                            <asp:LinkButton ID="form9" runat="server" Text="Download" CssClass="tableButton" CommandArgument='<%# Eval("form9") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bank Statement">
                        <ItemTemplate>
                            <asp:LinkButton ID="bankStmt" runat="server" Text="Download" CssClass="tableButton" CommandArgument='<%# Eval("bankStmt") %>' OnCommand="DownloadFile"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
        </div>
    </div>

    <br /><br />
    <!--bottom-->
    <div class="table-title" runat="server" id="lenderTitle">Lender Details</div>
    <div class="detail-box" runat="server" id="detailContainer2">
        <!--bottom-left-->
        <div class="details">
            <asp:DetailsView ID="AppDetail5" runat="server" AutoGenerateRows="False" DataSourceID="AppSource5" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="lenderID" HeaderText="Lender ID" />
                    <asp:BoundField DataField="annualIncome" HeaderText="Annual Income" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource5" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
        <!--bottom-right-->
        <div class="details">
            <asp:DetailsView ID="AppDetail6" runat="server" AutoGenerateRows="False" DataSourceID="AppSource6" CssClass="details" BorderStyle="None" CellPadding="10">
                <Fields>
                    <asp:BoundField DataField="riskTolerance" HeaderText="Risk Tolerance" />
                    <asp:BoundField DataField="riskAck" HeaderText="Risk Acknowledgement" />
                </Fields>
            </asp:DetailsView>
            <asp:SqlDataSource ID="AppSource6" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
    </div>

    <br />
    <asp:Button ID="Button1" runat="server" Text="< Back " CssClass="aspNetControl tableButton" OnClick="Back_Click" />
</asp:Content>
