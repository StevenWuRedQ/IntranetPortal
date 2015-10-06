<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AssignRulesControl.ascx.vb" Inherits="IntranetPortal.AssignRulesControl" %>
<link href="/css/stevencss.css?v=1.02" rel="stylesheet" type="text/css" />
<dx:ASPxGridView runat="server" Width="100%" ID="gridAssignRules" KeyFieldName="RuleId"  OnDataBinding="gridAssignRules_DataBinding" OnRowInserting="gridAssignRules_RowInserting" OnRowDeleting="gridAssignRules_RowDeleting">
    <Columns>
        <dx:GridViewDataTextColumn FieldName="EmployeeName">
            <EditItemTemplate>
                <dx:ASPxComboBox runat="server" OnDataBinding="Unnamed_DataBinding" CssClass="edit_drop" ID="cbEmps" Value='<%# Bind("EmployeeName")%>'>
                </dx:ASPxComboBox>
            </EditItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="LeadsTypeText" Caption="Leads Type">            
            <EditItemTemplate>
                <dx:ASPxComboBox runat="server" ID="cbLeadsType" OnDataBinding="cbLeadsType_DataBinding" CssClass="edit_drop" Value='<%# Bind("LeadsType")%>'>                 
                </dx:ASPxComboBox>
            </EditItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="Count">
            <EditItemTemplate>
                <dx:ASPxTextBox runat="server" ID="txCount" CssClass="edit_drop" Value='<%# Bind("Count")%>'>
                </dx:ASPxTextBox>
            </EditItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="IntervalTypeText" Caption="Interval">
            <EditItemTemplate>
                <dx:ASPxComboBox runat="server" ID="cbInterval" OnDataBinding="cbInterval_DataBinding" CssClass="edit_drop" Value='<%# Bind("IntervalType")%>'>                 
                </dx:ASPxComboBox>
            </EditItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="true">
         
        </dx:GridViewCommandColumn>
    </Columns>      
    <SettingsPager Mode="ShowAllRecords">
    </SettingsPager>       
    <SettingsBehavior AutoExpandAllGroups="true" />
</dx:ASPxGridView>
