<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleControl.ascx.vb" Inherits="IntranetPortal.TitleControl" %>
<script type="text/javascript">
    var selectSellerTitle = null;
    function SelectTitleCompany(isSeleteSellerTitle) {
        selectSellerTitle = isSeleteSellerTitle;
        ASPxPopupTitleControl.Show();
        gridTitleCompany.Refresh();
    }

    function ShowEditForm() {
        gridTitleCompany.AddNewRow();
    }

    function AddNewCompany() {
        gridTitleCompany.UpdateEdit();
    }

    function SelectCompany() {
        gridTitleCompany.GetSelectedFieldValues('CorpName;OfficeNO;', OnGetSelectedFieldValues);
        ASPxPopupTitleControl.Hide();
    }

    function OnGetSelectedFieldValues(selectedValues) {

        if (selectedValues.length == 0) return;

        var titleCompany = selectedValues[0];

        if (selectSellerTitle) {
            document.getElementById("txtSellerCompanyName").value = titleCompany[0];
            document.getElementById("txtSellerTitlePhone").value = titleCompany[1];
        }
        else {
            document.getElementById("txtBuyerCompanyName").value = titleCompany[0];
            document.getElementById("txtBuyerTitlePhone").value = titleCompany[1];
        }
    }

    var tmpClearenceId = null;
    function AddNotes(clearenceId, element) {
        tmpClearenceId = clearenceId;
        aspxAddNotes.ShowAtElement(element);
    }

    //function BindData()
    //{       
    //    var field = ($("input[data-source='case']").attr("data-field"));
    //    alert(ShortSaleCaseData.CaseId);
    //    $("input[data-source='case']").val(ShortSaleCaseData[field]);
    //}

</script>
<div style="padding-top: 5px">
    <div style="height: 850px; overflow: auto;" id="prioity_content">
        <%--refresh label--%>

        <dx:ASPxPanel ID="UpatingPanel" runat="server">
            <PanelCollection>
                <dx:PanelContent runat="server">
                    <div class="update_panel" style="display: none">
                        <i class="fa fa-spinner fa-spin" style="margin-left: 30px"></i>
                        <span style="padding-left: 22px">Lead is being updated, it will take a few minutes to complete.</span>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>

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
                    <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='BindData()' />
                </div>
            </div>
            <div class="ss_form" style="display: none">
                <h4 class="ss_form_title">Property</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">Address</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.PropertyInfo.PropertyAddress%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Block</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.PropertyInfo.Block%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Lot</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.PropertyInfo.Lot%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title"># Of Families</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.PropertyInfo.NumOfFamilies%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">C/O (<span class="">PDF</span>) </label>

                        <input type="radio" id="check_yes51" name="check51" value="YES">
                        <label for="check_yes51" class="input_with_check">Yes</label>

                        <input type="radio" id="check_no51" name="check51" value="NO">
                        <label for="check_no51" class="input_with_check">No</label>
                    </li>
                </ul>
            </div>
            <div class="ss_form" id="ddd">
                <h4 class="ss_form_title">Proposed Closing date</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Proposed Closing Date</label>
                        <input class="ss_form_input" data-field="CaseId" value="<%= ShortSaleCaseData.ClosingDate %>">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Sellers Title Company <i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="SelectTitleCompany(true)"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Company Name</label>
                        <input class="ss_form_input" data-field="SellerTitle.CompanyName" value="<%= ShortSaleCaseData.SellerTitle.CompanyName%>" id="txtSellerCompanyName">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.SellerTitle.Phone%>" id="txtSellerTitlePhone">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Ordered</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.SellerTitle.ReportOrderDate%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Received</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.SellerTitle.ReceivedDate%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Order Number</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.SellerTitle.OrderNumber%>">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Buyers Title Company  <i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="SelectTitleCompany(false)"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Company Name</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.BuyerTitle.CompanyName%>" id="txtBuyerCompanyName">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.BuyerTitle.Phone%>" id="txtBuyerTitlePhone">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Ordered</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.BuyerTitle.ReportOrderDate%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Received</label>
                        <input class="ss_form_input" value="<%= ShortSaleCaseData.BuyerTitle.ReceivedDate%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Order Number</label>
                        <input class="ss_form_input" data-flied="BuyerTitle.OrderNumber" value="<%= ShortSaleCaseData.BuyerTitle.OrderNumber%>">
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
                            <h4 class="ss_form_title">Clearence <i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="AspxPopupClearence.Show()"></i></h4>
                            <%--clearence list--%>
                            <div>

                                <% For Each clearence In ShortSaleCaseData.Clearences%>
                                <div class="clearence_list_item">
                                    <div class="clearence_list_content clearfix">
                                        <div class="clearence_list_index">
                                            <%= clearence.SeqNum%>
                                        </div>

                                        <div class="clearence_list_right">
                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    Issue
                                                </div>
                                                <div class="clearence_list_text18">
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
                                                    </tr>
                                                </table>
                                            </div>
                                            <% End If%>


                                            <div class="clearence_list_text">
                                                <div class="clearence_list_title">
                                                    notes <i class="fa fa-plus-circle note_img tooltip-examples" title="Add Notes" style="color: #3993c1; cursor: pointer" onclick='AddNotes("<%= clearence.ClearenceId%>", this)'></i>
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
                                <% Next%>

                                <%--    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                2
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue(Cleared)
                                    </div>
                                    <div class="clearence_list_text18" style="text-decoration: line-through">
                                        Title in Jaime Torres and Tahnee Torres
                                    </div>
                                </div>




                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Amounts
                                    </div>
                                    <div class="clearence_list_text14" style="text-decoration: line-through">
                                        $191,500.00
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>--%>

                                <%--       <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                3
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue
                                    </div>
                                    <div class="clearence_list_text18">
                                        One open mortgage
                                    </div>
                                </div>
                                <div class="clearence_list_text">
                                    <table>
                                        <tr>
                                            <td class="clearence_table_td">
                                                <div class="clearence_list_title">
                                                    Contact Name
                                                </div>
                                                <div class="clearence_list_text14">
                                                    Michael Moore
                                                </div>
                                            </td>
                                            <td class="clearence_table_td">
                                                <div class="clearence_list_title">
                                                    Contact Number
                                                </div>
                                                <div class="clearence_list_text14">
                                                    718-123-4567
                                                </div>
                                            </td>
                                            <td class="clearence_table_td">
                                                <div class="clearence_list_title">
                                                    Contact Email
                                                </div>
                                                <div class="clearence_list_text14">
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                    </table>

                                </div>

                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        notes
                                    </div>
                                    <div class="clearence_list_text14">
                                        <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                        <span class="clearence_list_text14">Contacted lenders attorney and requested payoff
                                            <br />
                                            <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                            <span class="clearence_list_text12">7/23/2014 by Ron Borovinsky
                                            </span>

                                        </span>
                                        <br />

                                        <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                        <span class="clearence_list_text14">Followed up, no payoff provided yet
                                            <br />
                                            <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                            <span class="clearence_list_text12">7/24/2014 by Ron Borovinsky
                                            </span>

                                        </span>
                                        <br />
                                        <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                        <span class="clearence_list_text14">Payoff received
                                            <br />
                                            <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                            <span class="clearence_list_text12">7/25/2014 by Ron Borovinsky
                                            </span>

                                        </span>
                                    </div>
                                </div>

                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Amounts
                                    </div>
                                    <div class="clearence_list_text14">
                                        $1,768.50
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                    <%--index 4 edit model--%>
                                <%--         <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index  color_blue_edit">
                                4
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue
                                    </div>
                                    <div class="clearence_list_text18  color_blue_edit">
                                        2561 Morgan Avenue, Bronx NY
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
                                                    Michael Moore
                                                </div>
                                            </td>
                                            <td class="clearence_table_td">
                                                <div class="clearence_list_title">
                                                    Contact Number
                                                </div>
                                                <div class="clearence_list_text14  color_blue_edit">
                                                    718-123-4567
                                                </div>
                                            </td>
                                            <td class="clearence_table_td">
                                                <div class="clearence_list_title">
                                                    Contact Email
                                                </div>
                                                <div class="clearence_list_text14  color_blue_edit">
                                                    &nbsp;
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        notes &nbsp;<i class="fa fa-plus-circle color_blue_edit icon_btn"></i>
                                    </div>
                                    <div class="clearence_list_text14">
                                        <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                        <span class="clearence_list_text14  color_blue_edit">Contacted lenders attorney and requested payoff
                                            <br />
                                            <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                            <span class="clearence_list_text12">7/23/2014 by Ron Borovinsky
                                            </span>

                                        </span>
                                        <br />
                                        <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                        <span class="clearence_list_text14  color_blue_edit">Entering note text |
                                            <br />
                                            <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                            <span class="clearence_list_text12">7/23/2014 by Ron Borovinsky
                                            </span>

                                        </span>
                                    </div>
                                </div>

                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Amounts
                                    </div>
                                    <div class="clearence_list_text14  color_blue_edit">
                                        $1,768.50
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                   
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                5
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue
                                    </div>
                                    <div class="clearence_list_text18">
                                        One contract of sale recorded
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                  
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                6
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue
                                    </div>
                                    <div class="clearence_list_text18">
                                        Numerous judgments, PVB'Sand ECB'S vs. Jaime Torres
                                    </div>
                                </div>


                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        notes
                                    </div>
                                    <div class="clearence_list_text14">
                                        <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                        <span class="clearence_list_text14">Verified all judments against adress on ID, drop box and last deed (none o.h)
                                            <br />
                                            <i class="fa fa-caret-right clearence_caret_right_icon" style="visibility: hidden"></i>
                                            <span class="clearence_list_text12">7/23/2014 by Ron Borovinsky
                                            </span>

                                        </span>
                                    </div>
                                </div>

                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Amounts
                                    </div>
                                    <div class="clearence_list_text14">
                                        $1,768.50
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>--%>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
        </div>
    </div>
</div>
<dx:ASPxPopupControl ClientInstanceName="ASPxPopupTitleControl" Width="700px" Height="420px"
    MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl3"
    HeaderText="Title Company" Modal="true" ShowFooter="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
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
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="AspxPopupClearence" Width="600px" Height="320px"
    MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl1" OnWindowCallback="ASPxPopupControl1_WindowCallback"
    HeaderText="Clearence" Modal="true" ShowFooter="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
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
