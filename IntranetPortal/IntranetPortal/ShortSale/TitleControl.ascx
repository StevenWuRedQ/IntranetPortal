<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleControl.ascx.vb" Inherits="IntranetPortal.TitleControl" %>
<script type="text/javascript">
    //var selectSellerTitle = null;
    //function SelectTitleCompany(isSeleteSellerTitle) {     
    //    selectSellerTitle = isSeleteSellerTitle;
    //    ASPxPopupTitleControl.PerformCallback();      
    //}

    //function ShowEditForm() {
    //    gridTitleCompany.AddNewRow();      
    //}

    //function AddNewCompany() {
    //    gridTitleCompany.UpdateEdit();
    //}

    //function SelectCompany() {
    //    gridTitleCompany.GetSelectedFieldValues('CorpName;OfficeNO;', OnGetSelectedFieldValues);
    //    ASPxPopupTitleControl.Hide();
    //}

    //function OnGetSelectedFieldValues(selectedValues) {

    //    if (selectedValues.length == 0) return;

    //    var titleCompany = selectedValues[0];

    //    if (selectSellerTitle) {
    //        document.getElementById("txtSellerCompanyName").value = titleCompany[0];
    //        document.getElementById("txtSellerTitlePhone").value = titleCompany[1];
    //    }
    //    else {
    //        document.getElementById("txtBuyerCompanyName").value = titleCompany[0];
    //        document.getElementById("txtBuyerTitlePhone").value = titleCompany[1];
    //    }
    //}

    var tmpClearenceId = null;
    function AddNotes(clearenceId, element) {
        tmpClearenceId = clearenceId;
        aspxAddNotes.ShowAtElement(element);
    }
</script>
<div style="padding-top: 5px">
    <div style="height: 850px; overflow: auto;" id="home_owner_content">
        <%--time label--%>
        <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
            <div style="font-size: 30px">
                <span>
                    <i class="fa fa-refresh"></i>
                    <span style="margin-left: 19px; font-weight: 300">Jun 9,2014 1:12PM</span>
                </span>
                <span class="time_buttons" style="margin-right: 30px; font-weight: 300;" onclick="ShowPopupMap('https://iapps.courts.state.ny.us/webcivil/ecourtsMain', 'eCourts')">Mark As Urgent</span>
                <span class="time_buttons">See Title Report</span>
            </div>
            <%--data format June 2, 2014 6:37 PM--%>
            <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">Started on June 2,1014</span>
        </div>

        <%--note list--%>
        <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
        </div>

        <div class="short_sale_content">
            <div class="clearfix">
                <div style="float: right">
                    <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />
                </div>
            </div>
            <div class="ss_form" id="ddd">
                <h4 class="ss_form_title">Proposed Closing date</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Proposed Closing Date</label>
                        <input class="ss_form_input ss_date" data-field="ClosingDate"  value="<%= ShortSaleCaseData.ClosingDate %>">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Sellers Title Company <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('SellerTitle.TitleContact', function(party){ShortSaleCaseData.SellerTitle.ContactId=party.ContactId;$('#dateSellerOrderDate').val('');$('#dateSellerReceivedDate').val('');$('#txtSellerOrderNum').val('');})"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Company Name</label>
                        <input class="ss_form_input ss_not_edit" data-field="SellerTitle.TitleContact.CorpName" value="<%= ShortSaleCaseData.SellerTitle.TitleContact.CorpName%>" id="txtSellerCompanyName">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_phone ss_not_edit" data-field="SellerTitle.TitleContact.OfficeNO" value="<%= ShortSaleCaseData.SellerTitle.TitleContact.OfficeNO%>" id="txtSellerTitlePhone">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Ordered</label>
                        <input class="ss_form_input ss_date ss_not_edit" data-field="SellerTitle.ReportOrderDate" value="<%= ShortSaleCaseData.SellerTitle.ReportOrderDate%>" id="dateSellerOrderDate">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Received</label>
                        <input class="ss_form_input ss_date ss_not_edit" data-field="SellerTitle.ReceivedDate"  value="<%= ShortSaleCaseData.SellerTitle.ReceivedDate%>" id="dateSellerReceivedDate">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Order Number</label>
                        <input class="ss_form_input ss_not_edit" data-field="SellerTitle.OrderNumber" value="<%= ShortSaleCaseData.SellerTitle.OrderNumber%>" id="txtSellerOrderNum">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Buyers Title Company  <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('BuyerTitle.TitleContact', function(party){ShortSaleCaseData.BuyerTitle.ContactId=party.ContactId;$('#dateBuyerOrderDate').val('');$('#dateBuyerReceivedDate').val('');$('#txtBuyerOrderNumber').val('');})"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Company Name</label>
                        <input class="ss_form_input ss_not_edit" data-field="BuyerTitle.TitleContact.CorpName" value="<%= ShortSaleCaseData.BuyerTitle.TitleContact.CorpName%>" id="txtBuyerCompanyName">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-field="BuyerTitle.TitleContact.OfficeNO" value="<%= ShortSaleCaseData.BuyerTitle.TitleContact.OfficeNO%>" id="txtBuyerTitlePhone">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Ordered</label>
                        <input class="ss_form_input ss_date ss_not_edit" data-field="BuyerTitle.ReportOrderDate" value="<%= ShortSaleCaseData.BuyerTitle.ReportOrderDate%>" id="dateBuyerOrderDate">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Received</label>
                        <input class="ss_form_input ss_date ss_not_edit" data-field="BuyerTitle.ReceivedDate" value="<%= ShortSaleCaseData.BuyerTitle.ReceivedDate%>" id="dateBuyerReceivedDate">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Order Number</label>
                        <input class="ss_form_input ss_not_edit" data-field="BuyerTitle.OrderNumber" value="<%= ShortSaleCaseData.BuyerTitle.OrderNumber%>" id="txtBuyerOrderNumber">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Judgement Search </h4>
                <%-- log tables--%>
                <div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="table_head" style="text-align: right">Date Ran</th>
                                <th>&nbsp;</th>
                                <th class="table_head">AS of DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="font_14">
                                <td class="judgment_search_td">Emergency Repair Taxes
                                </td>
                                <td>Auto
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Open Property Taxes
                                </td>
                                <td>Auto
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Open Water
                                </td>
                                <td>Auto
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">ECB Tickets
                                </td>
                                <td>Need to Analyze judgement search to obtain info
                                </td>
                                <td>May 15,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">ECB DOB Violations
                                </td>
                                <td>Auto
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">PVB
                                </td>
                                <td>Auto
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">IRS Lien
                                </td>
                                <td>Need to Analyze judgement search to obtain info
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">NYC Lien
                                </td>
                                <td>Need to Analyze judgement search to obtain info
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Add Federal Liens
                                </td>
                                <td>Need to Analyze judgement search to obtain info
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">NYC Lien
                                </td>
                                <td>Need to Analyze judgement search to obtain info
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Add Criminal
                                </td>
                                <td>Need to Analyze judgement search to obtain info
                                </td>
                                <td>May 1,2014
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="ss_form">
                <dx:ASPxCallbackPanel ID="callbackClearence" runat="server" ClientInstanceName="callbackClearence" OnCallback="callbackClearence_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <h4 class="ss_form_title">Clearence <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="AspxPopupClearence.Show()"></i></h4>
                            <%--clearence list--%>
                            <div>
                                <% Dim i = 1%>
                                <% For Each clearence In ShortSaleCaseData.Clearences%>
                                <div class="clearence_list_item">
                                    <div class="clearence_list_content clearfix">
                                        <div class="clearence_list_index">
                                            <%= i%>
                                        </div>
                                        <div class="clearence_list_right">
                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    Issue <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" style="font-size: 14px" title="Delete" onclick="callbackClearence.PerformCallback('Delete|<%= clearence.ClearenceId%>|' + caseId)"></i><i class="fa fa-check  color_blue_edit collapse_btn tooltip-examples ss_control_btn" style="font-size: 14px" title="Mark as Complete" onclick="callbackClearence.PerformCallback('Clear|<%= clearence.ClearenceId%>|' + caseId)"></i>
                                                </div>
                                                <div class="clearence_list_text18" <%= If(Not String.IsNullOrEmpty(clearence.Status) AndAlso clearence.Status = IntranetPortal.ShortSale.TitleClearence.ClearenceStatus.Cleared, "style='text-decoration:line-through;'", "")%>>
                                                    <%= clearence.Issue%>
                                                </div>
                                            </div>
                                            <% If clearence.ContactId.HasValue Then%>
                                            <div class="clearence_list_text">
                                                <table>
                                                    <tr>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Contact Name
                                                            </div>
                                                            <div class="clearence_list_text14">
                                                                <%= clearence.Contact.Name%>
                                                            </div>
                                                        </td>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Contact Number
                                                            </div>
                                                            <div class="clearence_list_text14">
                                                                <%= clearence.Contact.OfficeNO%>
                                                            </div>
                                                        </td>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Contact Email
                                                            </div>
                                                            <div class="clearence_list_text14">
                                                                <%= clearence.Contact.Email%>
                                                            </div>
                                                        </td>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Company Name
                                                            </div>
                                                            <div class="clearence_list_text14">
                                                                <%= clearence.Contact.CorpName%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <% End If%>


                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    notes <i class="fa fa-plus-circle note_img tooltip-examples ss_control_btn" title="Add Notes" style="color: #3993c1; cursor: pointer" onclick='AddNotes("<%= clearence.ClearenceId%>", this)'></i>
                                                </div>
                                                <% If clearence.Notes IsNot Nothing AndAlso clearence.Notes.Count > 0 Then%>
                                                <div class="clearence_list_text14">
                                                    <% For Each note In clearence.Notes%>
                                                    <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                                    <span class="clearence_list_text14"><%= note.Notes%>
                                                        <br />
                                                        <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                                        <span class="clearence_list_text12"><%= note.CreateDate%> by <%= note.CreateBy%>
                                                        </span>
                                                    </span>
                                                    <br />
                                                    <% Next%>
                                                </div>
                                                <% End If%>
                                            </div>


                                            <% If clearence.Amount.HasValue Then%>
                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    Amounts
                                                </div>
                                                <div class="clearence_list_text14">
                                                    <%= clearence.Amount%>
                                                </div>
                                            </div>
                                            <% End If%>
                                        </div>
                                    </div>
                                </div>
                                <% i = i + 1%>
                                <% Next%>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
        </div>
    </div>
</div>

<%--<dx:ASPxPopupControl ClientInstanceName="ASPxPopupTitleControl" Width="700px" Height="420px" AllowDragging="true" DragElement="Header"
    MaxWidth="800px" MinWidth="150px" ID="popupTitleControl" OnWindowCallback="popupTitleControl_WindowCallback"
    HeaderText="Select Contact" Modal="true" ShowFooter="true" 
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" Visible="false" ID="popupContentTitle">              
            <dx:ASPxGridView runat="server" ID="gridTitleCompany" ClientInstanceName="gridTitleCompany" KeyFieldName="ContactId" OnDataBinding="titleCompanyGrid_DataBinding" Width="100%" OnRowInserting="gridTitleCompany_RowInserting">
                <Columns>
                    <dx:GridViewCommandColumn ShowSelectCheckbox="true" Caption="#"></dx:GridViewCommandColumn>
                    <dx:GridViewDataTextColumn FieldName="CorpName" Caption="Company Name"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Name" Caption="Contact"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="OfficeNO" Caption="Phone"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Address"></dx:GridViewDataTextColumn>
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
                        <span class="time_buttons" onclick="gridTitleCompany.CancelEdit()">Cancel</span>
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
            <span class="time_buttons" onclick="ASPxPopupTitleControl.Hide()">Cancel</span>
            <span class="time_buttons" onclick="SelectCompany()">Confirm</span>
            <span class="time_buttons" onclick="ShowEditForm()">Add Company</span>
        </div>
    </FooterContentTemplate>
    <ClientSideEvents EndCallback="function(s,e){s.Show();}" />
</dx:ASPxPopupControl>--%>

<dx:ASPxPopupControl ClientInstanceName="AspxPopupClearence" Width="600px" Height="320px"
    MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl1" OnWindowCallback="ASPxPopupControl1_WindowCallback"
    HeaderText="Clearence" Modal="true" ShowFooter="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            <div class="popup_padding">
                <div class="clearence_list_text">
                    <div class="clearence_list_title">
                        Issue
                    </div>
                    <div class="clearence_list_text18  color_blue_edit">
                        <input class="ss_form_input" value="" runat="server" id="txtIssue" style="width: 90%">
                    </div>
                </div>
                <div class="clearence_list_text">
                    <table>
                        <tr>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Contact Name
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="txtContactName">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Contact Number
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="txtContactNum">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Contact Email
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="txtContactEmail">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="clearence_list_text">
                    <table>
                        <tr>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Company Name
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="Text1">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Amounts
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="txtAmount">
                                </div>
                            </td>

                            <td class="clearence_table_td"></td>
                        </tr>
                    </table>
                </div>
            </div>

        </dx:PopupControlContentControl>
    </ContentCollection>
    <FooterContentTemplate>
        <div style="height: 30px; vertical-align: central">
            <span class="time_buttons" onclick="AspxPopupClearence.Hide()">Close</span>
            <span class="time_buttons" onclick="AspxPopupClearence.PerformCallback(caseId)">Add</span>
        </div>
    </FooterContentTemplate>
    <ClientSideEvents EndCallback="function(s,e){AspxPopupClearence.Hide();callbackClearence.PerformCallback(caseId);}" />
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="aspxAddNotes" Width="500px" Height="50px" ID="ASPxPopupControl2"
    HeaderText="Add Notes" ShowHeader="false" OnWindowCallback="ASPxPopupControl2_WindowCallback"
    runat="server" EnableViewState="false" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Middle" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl>
            <table>
                <tr style="padding-top: 3px;">
                    <td style="width: 380px; vertical-align: central">
                        <dx:ASPxTextBox runat="server" ID="txtNotes" Width="360px"></dx:ASPxTextBox>
                    </td>
                    <td style="text-align: right">
                        <div>
                            <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false" CssClass="rand-button" BackColor="#3993c1">
                                <ClientSideEvents Click="function(s,e){aspxAddNotes.PerformCallback(tmpClearenceId);}" />
                            </dx:ASPxButton>
                        </div>

                    </td>
                </tr>
            </table>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents EndCallback="function(s,e){aspxAddNotes.Hide();callbackClearence.PerformCallback(caseId);}" />
</dx:ASPxPopupControl>
