<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ShortSaleReport.aspx.vb" Inherits="IntranetPortal.ShortSaleReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <button class="rand-button bg_color_blue rand-button-padding" type="button" style="margin-right: 10px" onserverclick="Unnamed_ServerClick" runat="server">Export</button>
    <dx:ASPxGridView ID="AllLeadsGrid" runat="server" ClientInstanceName="AllLeadsGridClient"
        KeyFieldName="CaseId" Width="100%">
        <Columns>
            <dx:GridViewDataTextColumn FieldName="PropertyInfo.PropertyAddress" Caption="Full Property Address">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="PropertyOwner.FirstName" Caption="First Name">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="PropertyOwner.LastName" Caption="Last Name">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="OccupiedBy" Caption="Occupancy">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="FristMortageProgress" Caption="File Progress">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Description" FieldName="ReportDetails">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="FristMortageLender" Caption="1st Mortgage Company">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="SencondMortageLender" Caption="2nd Mortgage Company">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="LastActivity.Source" Caption="Last Activity Done By">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="LastActivity.ActivityDate" Caption="Last Activity">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="LastActivity.ActivityTitle" Caption="Last Activity Title">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="ListingAgentContact.Name" Caption="Referral">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn Caption="Other1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="CreateDate" Caption="File Created">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="ProcessorContact.Name" Caption="Processor">
            </dx:GridViewDataTextColumn>
        </Columns>
    </dx:ASPxGridView>
    <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="AllLeadsGrid"></dx:ASPxGridViewExporter>
</asp:Content>
