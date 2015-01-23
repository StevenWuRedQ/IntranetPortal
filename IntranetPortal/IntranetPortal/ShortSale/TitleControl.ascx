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

    function MakeAsUrgent(caseId)
    {
        callbackMakeUrgent.PerformCallback(caseId);
    }

    function MakeUrgentComplate(result)
    {
        var span = document.getElementById("spanUrgent");
        
        if (result === "True")
        {
            span.className = "time_buttons Urgent";
            span.innerText = "Urgent";
        }
        else
        {
            span.className = "time_buttons";
            span.innerText = "Make As Urgent";
        }
    }

</script>
<style type="text/css">
    .TitleCleared .TitleContent {
        color: #98ba50;
    }
    .TitleDelete .TitleContent
    {
        text-decoration:line-through;
    }
    .Urgent{
        background-color:orangered;
        color:white;
    }
</style>
<div style="padding-top: 5px">
    <div style="height: 850px; overflow:auto" id="home_owner_content">
        <%--time label--%>
        <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
            <div style="font-size: 30px">
                <span>
                    <i class="fa fa-refresh"></i>
                    <span style="margin-left: 19px; font-weight: 300">Jun 9,2014 1:12PM</span>
                </span>                
                <span class="time_buttons" id="spanUrgent" style="margin-right: 30px; font-weight: 300;" onclick="MakeAsUrgent(<%=ShortSaleCaseData.CaseId%>)">
                    <% If ShortSaleCaseData.IsUrgent.HasValue AndAlso ShortSaleCaseData.IsUrgent Then %>
                        Urgent
                    <%Else%>
                        Mark As Urgent
                    <%End If%>
                </span>
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
                                <th class="table_head" style="text-align: right">&nbsp;</th>
                                <th>Date Ran</th>
                                <th class="table_head">AS of DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="font_14">
                                <td class="judgment_search_td">Emergency Repair Taxes
                                </td>
                                <td> <input type="text" class="ss_form_input table_input" data-field="JudgementInfo.RepairTax" placeholder="Click to input"/>
                                </td>
                                <td><input type="text" class="ss_form_input table_input ss_date" data-field="JudgementInfo.RepairTaxDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Open Property Taxes
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.PropertyTax"  placeholder="Click to input"/>
                                </td>
                                <td><input type="text" class="ss_form_input table_input ss_date"  data-field="JudgementInfo.PropertyTaxDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Open Water
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.OpenWater"  placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.OpenWaterDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">ECB Tickets
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.ECBTickets" placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.ECBTicketsDate"  placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">ECB DOB Violations
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.DOBViolation" placeholder="Click to input"/>
                                </td>
                                <td> <input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.DOBViolationDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">PVB
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.PVB" placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.PVBDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">IRS Lien
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.IRSLien" placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.IRSLienDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">NYC Lien
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.NYCLien" placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.NYCLienDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                            <tr class="font_14">
                                <td class="judgment_search_td">Add Federal Liens
                                </td>
                                <td>
                                    <input type="text" class="ss_form_input table_input" data-field="JudgementInfo.FederalLien" placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.FederalLienDate" placeholder="Click to select date"/>
                                </td>
                            </tr>
                           
                            <tr class="font_14">
                                <td class="judgment_search_td">Add Criminal
                                </td>
                                <td><input type="text" class="ss_form_input table_input" data-field="JudgementInfo.Criminal" placeholder="Click to input"/>
                                </td>
                                <td><input type="text"class="ss_form_input table_input ss_date" data-field="JudgementInfo.CriminalDate" placeholder="Click to select date"/>
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
                            <h4 class="ss_form_title">Clearence <i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="AspxPopupClearence.Show()"></i></h4>
                            <%--clearence list--%>
                            <div>
                                <% Dim i = 1%>
                                <% For Each clearence In ShortSaleCaseData.Clearences%>
                                <div class="clearence_list_item">
                                    <div class="clearence_list_content clearfix  <%= If(Not String.IsNullOrEmpty(clearence.Status) AndAlso clearence.Status = IntranetPortal.ShortSale.TitleClearence.ClearenceStatus.Cleared, "TitleCleared", "")%>"">
                                        <div class="clearence_list_index TitleContent">
                                            <%= i%>
                                        </div>
                                        <div class="clearence_list_right">
                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    Issue  <div style="float:right;margin-right:30px"> 
                                                        <i class="fa fa-times-circle icon_btn color_blue tooltip-examples " style="font-size: 14px" title="Delete" onclick="callbackClearence.PerformCallback('Delete|<%= clearence.ClearenceId%>|' + caseId)"></i>
                                                        <i class="fa fa-check  color_blue_edit collapse_btn tooltip-examples " style="font-size: 14px" title="Mark as Complete" onclick="callbackClearence.PerformCallback('Clear|<%= clearence.ClearenceId%>|' + caseId)"></i>
                                                </div>

                                                </div>
                                                <div class="clearence_list_text18 TitleContent">
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
                                                            <div class="clearence_list_text14 TitleContent">
                                                                <%= clearence.Contact.Name%>
                                                            </div>
                                                        </td>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Contact Number
                                                            </div>
                                                            <div class="clearence_list_text14 TitleContent">
                                                                <%= clearence.Contact.OfficeNO%>
                                                            </div>
                                                        </td>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Contact Email
                                                            </div>
                                                            <div class="clearence_list_text14 TitleContent">
                                                                <%= clearence.Contact.Email%>
                                                            </div>
                                                        </td>
                                                        <td class="clearence_table_td">
                                                            <div class="clearence_list_title">
                                                                Company Name
                                                            </div>
                                                            <div class="clearence_list_text14 TitleContent">
                                                                <%= clearence.Contact.CorpName%>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <% End If%>
                                            
                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    notes                                                                                                       
                                                    <i class="fa fa-plus-circle note_img tooltip-examples " title="Add Notes" style="color: #3993c1; cursor: pointer" onclick='AddNotes("<%= clearence.ClearenceId%>", this)'></i>
                                                        </div>
                                               
                                                <% If clearence.Notes IsNot Nothing AndAlso clearence.Notes.Count > 0 Then%>
                                                <div class="clearence_list_text14">
                                                    <% For Each note In clearence.Notes%>
                                                    <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                                    <span class="clearence_list_text14 TitleContent" ><%= note.Notes%>
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
                                                <div class="clearence_list_text14 TitleContent">
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
                        <input class="ss_form_input ss_allow_eidt" value="" runat="server" id="txtIssue" style="width: 90%">
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
                                    <input class="ss_form_input ss_allow_eidt" value="" runat="server" id="txtContactName">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Contact Number
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input ss_allow_eidt" value="" runat="server" id="txtContactNum">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Contact Email
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input ss_allow_eidt" value="" runat="server" id="txtContactEmail">
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
                                    <input class="ss_form_input ss_allow_eidt" value="" runat="server" id="txtCompanyName">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Amounts
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">                                  
                                    <dx:ASPxTextBox runat="server" ID="txtAmount" CssClass="ss_form_input ss_allow_eidt" Native="true" DisplayFormatString="c2">
                                 </dx:ASPxTextBox>
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

<dx:ASPxCallback runat="server" ID="callbackMakeUrgent" OnCallback="callbackMakeUrgent_Callback" ClientInstanceName="callbackMakeUrgent" >
    <ClientSideEvents CallbackComplete="function(s,e){MakeUrgentComplate(e.result);}" />
</dx:ASPxCallback>