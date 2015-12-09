<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Task/Reports/WorkflowReprot.Master" CodeBehind="WorklistReport.aspx.vb" Inherits="IntranetPortal.WorklistReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderMain" runat="server">
    <h3>User Worklist</h3>
    <dx:ASPxLabel runat="server" Text="" ID="lblUserName" ClientInstanceName="lblUserName" Theme="Moderno"></dx:ASPxLabel>
    <dx:ASPxGridView ID="GridWorklist" ClientInstanceName="gridWorklist" runat="server" KeyFieldName="Id" Width="100%" Theme="Moderno" OnDataBinding="GridWorklist_DataBinding">
        <Columns>
            <dx:GridViewDataColumn FieldName="Id" VisibleIndex="0" />
            <dx:GridViewDataColumn FieldName="DisplayName" VisibleIndex="1" />
            <dx:GridViewDataColumn FieldName="ProcessName" VisibleIndex="1" />
            <dx:GridViewDataColumn FieldName="ActivityName" VisibleIndex="2" />
            <dx:GridViewDataColumn FieldName="DestinationUser" VisibleIndex="3" />
            <dx:GridViewDataTextColumn FieldName="CreateDate" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="G">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="G" />
            <dx:GridViewDataColumn FieldName="Status"></dx:GridViewDataColumn>
            <dx:GridViewDataTextColumn FieldName="Duration">
                <PropertiesTextEdit DisplayFormatString="dd\.hh\:mm\:ss"></PropertiesTextEdit>
            </dx:GridViewDataTextColumn>
        </Columns>        
        <SettingsPager Mode="ShowPager"></SettingsPager>
        <GroupSummary>
            <dx:ASPxSummaryItem FieldName="Id" SummaryType="Count" DisplayFormat="Count: {0}" />
            <dx:ASPxSummaryItem FieldName="Duration" SummaryType="Average" DisplayFormat="Avg Duration: {0:dd\.hh\:mm\:ss}" />
        </GroupSummary>
        <Settings ShowGroupPanel="true" />
    </dx:ASPxGridView>


</asp:Content>
