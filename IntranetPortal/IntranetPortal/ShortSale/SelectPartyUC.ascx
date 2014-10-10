<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SelectPartyUC.ascx.vb" Inherits="IntranetPortal.SelectPartyUC" %>
<script type="text/javascript">
    var tmpPartyName = null;
    var onSelectCallback;

    function ShowSelectParty(partyName, selectPartyCallback) {
        ASPxPopupSelectParty.PerformCallback();        
        tmpPartyName = partyName;
        onSelectCallback = selectPartyCallback;
    }

    function ShowEditForm() {
        gridParties.AddNewRow();
    }

    function AddNewCompany() {
        gridParties.UpdateEdit();
    }

    function SelectParty() {
        gridParties.GetValuesOnCustomCallback("", EndSelectParty);
        ASPxPopupSelectParty.Hide();
    }

    function EndSelectParty(party) {
        var data = JSON.parse(party);        
        refreshDiv(tmpPartyName, data);
        onSelectCallback(data);
    }
</script>

<dx:ASPxPopupControl ClientInstanceName="ASPxPopupSelectParty" Width="700px" Height="420px"
    MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl3" OnWindowCallback="ASPxPopupControl3_WindowCallback"    
    HeaderText="Title Company" Modal="true" ShowFooter="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" Visible="false" ID="popupContentSelectParty">
            <dx:ASPxRadioButtonList runat="server" ID="rblType" RepeatDirection="Horizontal">
                <Border BorderStyle="None" />
                <Items>
                    <dx:ListEditItem Value="" Text="All" />
                    <dx:ListEditItem Text="Title Company" Value="0" />
                    <dx:ListEditItem Text="Attorney" Value="1" />
                    <dx:ListEditItem Text="Seller" Value="2" />
                    <dx:ListEditItem Text="Employee" Value="3" />
                </Items>
                <ClientSideEvents SelectedIndexChanged="function(s,e){gridParties.Refresh();}" />
            </dx:ASPxRadioButtonList>
            <dx:ASPxGridView runat="server" ID="gridParties" ClientInstanceName="gridParties" KeyFieldName="ContactId" OnDataBinding="gridParties_DataBinding" Width="100%" OnRowInserting="gridParties_RowInserting" OnCustomDataCallback="gridParties_CustomDataCallback" OnRowDeleting="gridParties_RowDeleting">
                <Columns>
                    <dx:GridViewCommandColumn ShowSelectCheckbox="true" Caption="#"></dx:GridViewCommandColumn>
                    <dx:GridViewDataTextColumn FieldName="CorpName" Caption="Company Name"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Name" Caption="Contact"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="OfficeNO" Caption="Phone"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Address"></dx:GridViewDataTextColumn>
                    <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true"></dx:GridViewCommandColumn>
                </Columns>
                <Templates>
                    <EditForm>
                        <div class="ss_form" style="margin-top: 0px;">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">name</label>
                                    <input class="ss_form_input" value="" runat="server" id="txtContact">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Office</label>
                                    <input class="ss_form_input" value="" runat="server" id="txtCompanyName">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">address</label>
                                    <input class="ss_form_input" value="" runat="server" id="txtAddress">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">office #</label>
                                    <input class="ss_form_input" value="" runat="server" id="txtOffice">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Cell #</label>
                                    <input class="ss_form_input" value="" runat="server" id="txtCell">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">email</label>
                                    <input class="ss_form_input" value="" runat="server" id="txtEmail">
                                </li>
                            </ul>
                        </div>
                        <span class="time_buttons" onclick="gridParties.CancelEdit()">Cancel</span>
                        <span class="time_buttons" onclick="AddNewCompany()">OK</span>
                    </EditForm>
                </Templates>
                <SettingsBehavior AllowSelectSingleRowOnly="true" />
                <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
                <SettingsPopup>
                </SettingsPopup>
                <SettingsText PopupEditFormCaption="Add Title Company" />
            </dx:ASPxGridView>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <FooterContentTemplate>
        <div style="height: 30px; vertical-align: central">
            <span class="time_buttons" onclick="ASPxPopupSelectParty.Hide()">Cancel</span>
            <span class="time_buttons" onclick="SelectParty()">Confirm</span>
            <span class="time_buttons" onclick="ShowEditForm()">Add New</span>
        </div>
    </FooterContentTemplate>
    <ClientSideEvents EndCallback="function(s,e){s.Show();}" />
</dx:ASPxPopupControl>
