<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleInLeadsView.ascx.vb" Inherits="IntranetPortal.ShortSaleInLeadsView" %>

<asp:HiddenField ID="hfBble" runat="server" />
<asp:HiddenField ID="hfCaseId" runat="server" />

<div class="form_head" style="margin-top: 40px;">Home Breakdown</div>






<dx:ASPxGridView ID="home_breakdown_gridview" runat="server" KeyFieldName="BBLE;FloorId" SettingsBehavior-AllowDragDrop="false" SettingsBehavior-AllowSort="false" OnRowInserting="home_breakdown_gridview_RowInserting" OnRowDeleting="home_breakdown_gridview_RowDeleting" OnRowUpdating="home_breakdown_gridview_RowUpdating" Visible="false">
    <Columns>
        <dx:GridViewCommandColumn ShowEditButton="true" ShowNewButtonInHeader="true" ShowDeleteButton="True" />
        <dx:GridViewDataColumn FieldName="FloorId" VisibleIndex="1" Caption="Floor" ReadOnly="true">
            <EditItemTemplate>
                <span>
                    <%# GetFloorId(Eval("FloorId"))%>
                </span>
            </EditItemTemplate>
        </dx:GridViewDataColumn>
        <dx:GridViewDataColumn FieldName="Bedroom" VisibleIndex="1" />
        <dx:GridViewDataColumn FieldName="Bathroom" VisibleIndex="2" />
        <dx:GridViewDataColumn FieldName="Livingroom" VisibleIndex="3" />
        <dx:GridViewDataColumn FieldName="Kitchen" VisibleIndex="4" />
        <dx:GridViewDataColumn FieldName="Diningroom" VisibleIndex="5" />
        <dx:GridViewDataColumn FieldName="Occupied" VisibleIndex="5" />
        <%--<dx:GridViewDataColumn FieldName="Lease" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Type" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Rent" VisibleIndex="5" />

                <dx:GridViewDataColumn FieldName="BoilerRoom" VisibleIndex="5" />--%>
    </Columns>
    <SettingsEditing Mode="PopupEditForm" />
</dx:ASPxGridView>
