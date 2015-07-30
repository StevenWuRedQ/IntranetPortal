<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ShortSaleReport.aspx.vb" Inherits="IntranetPortal.ShortSaleReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <button class="rand-button bg_color_blue rand-button-padding" type="button" style="margin-right: 10px" onserverclick="Unnamed_ServerClick" runat="server">Export</button>
    <dx:ASPxGridView ID="AllLeadsGrid" runat="server" ClientInstanceName="AllLeadsGridClient"
        KeyFieldName="CaseId" Width="100%">
        <Columns>
            <dx:GridViewDataTextColumn FieldName="RptPropertyInfo" Caption="Property Info">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="RptMortgageInfo" Caption="Mortgage Info">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="MortgageCategory" Caption="File Stage">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="FristMortageProgress" Caption="File Status">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="RptValuation" Caption="Valuation">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="RptOffer" Caption="Offer">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="" Caption="Missing Docs">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="LastFileOverview.ActivityDate" Caption="Date of File Overview">
            </dx:GridViewDataTextColumn> 
            <dx:GridViewDataTextColumn FieldName="LastFileOverview.Comments" Caption="Last File Overview">
            </dx:GridViewDataTextColumn> 
            <dx:GridViewDataTextColumn FieldName="ProcessorContact.Name" Caption="Processor">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="ReferralContact.Name" Caption="Referral">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="ReferralTeam" Caption="Office">
            </dx:GridViewDataTextColumn>                   
            <dx:GridViewDataTextColumn FieldName="CreateDate" Caption="File Created">
            </dx:GridViewDataTextColumn>       
        </Columns>
    </dx:ASPxGridView>
    <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="AllLeadsGrid"></dx:ASPxGridViewExporter>
</asp:Content>
