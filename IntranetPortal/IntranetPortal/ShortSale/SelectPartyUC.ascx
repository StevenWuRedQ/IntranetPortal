<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SelectPartyUC.ascx.vb" Inherits="IntranetPortal.SelectPartyUC" %>
<script type="text/javascript">
    var tmpPartyName = null;
    var onSelectCallback;
    var isloaded = false;

    function ShowSelectParty(partyName, selectPartyCallback) {
        if (isloaded)
            ASPxPopupSelectParty.Show();
        else {
            ASPxPopupSelectParty.PerformCallback();
            isloaded = true;
        }

        tmpPartyName = partyName;
        onSelectCallback = selectPartyCallback;
    }

    function ShowEditForm() {
        gridParties.AddNewRow();
    }

    function AddNewCompany() {
        if (ASPxClientEdit.ValidateGroup("Contact"))
            gridParties.UpdateEdit();
        else {
        }
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
        <dx:PopupControlContentControl runat="server" ID="popupContentSelectParty">
            <div class="popup_padding">
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
                <dx:ASPxGridView runat="server" ID="gridParties" ClientInstanceName="gridParties" KeyFieldName="ContactId" OnDataBinding="gridParties_DataBinding" Width="100%" OnRowInserting="gridParties_RowInserting" OnCustomDataCallback="gridParties_CustomDataCallback" OnRowDeleting="gridParties_RowDeleting" OnRowUpdating="gridParties_RowUpdating">
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
                            <div class="popup_padding">
                                <div class="ss_form" style="margin-top: 0px;">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">name</label>
                                            <%--<input class="ss_form_input" value='<%# Bind("Name")%>' runat="server" id="txtContact">--%>
                                            <dx:ASPxTextBox runat="server" ID="txtContact" CssClass="ss_form_input" Native="true" Text='<%# Bind("Name")%>'>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Company Name</label>
                                            <dx:ASPxTextBox runat="server" ID="txtCompanyName" CssClass="ss_form_input" Native="true" Text='<%# Bind("CorpName")%>'>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">address</label>
                                            <input class="ss_form_input" value='<%# Bind("Address")%>' runat="server" id="txtAddress">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">office #</label>
                                            <dx:ASPxTextBox runat="server" ID="txtOffice" CssClass="ss_form_input" Native="true" Text='<%# Bind("OfficeNO")%>'>
                                                <MaskSettings Mask="(999) 000-0000" IncludeLiterals="None" />
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Cell #</label>
                                            <dx:ASPxTextBox runat="server" ID="txtCell" CssClass="ss_form_input" Native="true" Text='<%#Bind("Cell")%>'>
                                                <MaskSettings Mask="(999) 000-0000" IncludeLiterals="None" />
                                                <ValidationSettings CausesValidation="false" RequiredField-IsRequired="false" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">email</label>
                                            <dx:ASPxTextBox runat="server" ID="txtEmail" CssClass="ss_form_input" Native="true" Text='<%# Bind("Email")%>'>
                                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact">
                                                    <RegularExpression ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorText="Email isnot valid." />
                                                </ValidationSettings>
                                            </dx:ASPxTextBox>
                                        </li>
                                    </ul>
                                </div>
                                <span class="time_buttons" onclick="gridParties.CancelEdit()">Cancel</span>
                                <span class="time_buttons" onclick="AddNewCompany()">OK</span>
                            </div>

                        </EditForm>
                    </Templates>
                    <SettingsBehavior AllowSelectSingleRowOnly="true" />
                    <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
                    <SettingsPopup>
                    </SettingsPopup>
                    <SettingsText PopupEditFormCaption="Add Title Company" />
                </dx:ASPxGridView>
            </div>


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
