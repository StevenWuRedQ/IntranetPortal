<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleSummaryTab.ascx.vb" Inherits="IntranetPortal.ShortSaleSummaryTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<script>
    function refreshSummary() {
        summary_call_back_panel_client.PerformCallback(ShortSaleCaseData.CaseId);
    }
    function reinitClient(s, e) {
        ShortSaleDataBand(0);
        format_input();
    }
</script>

<dx:ASPxCallbackPanel ID="summary_call_back_panel" runat="server" ClientInstanceName="summary_call_back_panel_client" OnCallback="summary_call_back_panel_Callback">
    <ClientSideEvents
        EndCallback="reinitClient" />
    <PanelCollection>
        <dx:PanelContent>
            <div>
                <h4 class="ss_form_title">Property</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">address</label>

                        <input class="ss_form_input" style="width: 93.5%;" name="lender"
                            value="<%= summaryCase.PropertyInfo.PropertyAddress%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">BBLE</label>
                        <input class="ss_form_input font_black" data-field="PropertyInfo.BBLE">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Block</label>
                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">lot</label>
                        <input class="ss_form_input" data-field="PropertyInfo.Lot">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Accessibility</label>
                        <input class="ss_form_input" data-field="PropertyInfo.Accessibility">
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">c/o(<span class="link_pdf">pdf</span>)</span>

                        <input type="radio" id="pdf_check_yes" name="1" <%= ShortSalePage.CheckBox(summaryCase.PropertyInfo.CO)%> value="YES" class="ss_form_input">
                        <label for="pdf_check_yes" class="input_with_check">
                            <span class="box_text">Yes </span>
                        </label>

                        <input type="radio" id="pdf_check_no" name="1" <%= ShortSalePage.CheckBox(summaryCase.PropertyInfo.CO = False)%> value="NO" class="ss_form_input">
                        <label for="pdf_check_no" class="input_with_check">
                            <span class="box_text">No </span>
                        </label>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Tax class</label>
                        <input class="ss_form_input" value="<%= summaryCase.PropertyInfo.TaxClass%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title"># of families</label>
                        <input class="ss_form_input" value="<%= summaryCase.PropertyInfo.NumOfFamilies%>">
                    </li>

                </ul>
            </div>

            <%--<div data-array-index="0" data-field="PropertyInfo.Owners" class="ss_array" style="display: none">--%>
            <%Dim i = 0%>
            <%For Each owner As PropertyOwner In summaryCase.PropertyInfo.Owners%>
            <%i = i + 1%>
            <div class="ss_form">
                <h4 class="ss_form_title">Seller <%=i %></h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">name</label>
                        <input class="ss_form_input" value="<%=owner.FullName %>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">SSN</label>
                        <input class="ss_form_input ss_ssn" value="<%=owner.SSN %>">
                    </li>
                    <li class="ss_form_item" style="visibility: hidden">
                        <label class="ss_form_input_title">Tax class</label>
                        <input class="ss_form_input" value="No Tax class ??">
                    </li>
                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">Mailing address</label>
                        <input class="ss_form_input" value="<%=owner.MailingAddress %>" style="width: 93.5%;" name="lender">
                    </li>

                </ul>
            </div>
            <%Next%>
            <%--</div>--%>

            <div data-array-index="0" data-field="Mortgages" class="ss_array" style="display: none">

                <div class="ss_form">
                    <h4 class="ss_form_title"><span class="title_index ">Mortgage __index__1 </span></h4>
                    <ul class="ss_form_box clearfix">

                        <li class="ss_form_item ss_mortages_stauts">
                            <label class="ss_form_input_title">Status</label>
                            <select class="ss_form_input " data-item="Status" data-item-type="1">
                                <option value=""></option>
                                <% For Each mortStatus In IntranetPortal.ShortSale.PropertyMortgage.StatusData%>
                                <option value="<%= mortStatus.Category & "-" & mortStatus.Name%>"><%= mortStatus.Name%></option>
                                <% Next%>
                            </select>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Lender</label>
                            <input class="ss_form_input" data-item="Lender" data-item-type="1">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Loan #</label>
                            <input class="ss_form_input" data-item="Loan" data-item-type="1">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Loan Amount</label>
                            <input class="ss_form_input currency_input" onblur="$(this).formatCurrency();" data-item="LoanAmount" data-item-type="1">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Short Sale Dept</label>
                            <input class="ss_form_input" data-item="ShortSaleDeptContact.OfficeNO" data-item-type="1">
                        </li>

                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Mortgage Type</label>

                            <select class="ss_form_input" data-item="Type" data-item-type="1">
                                <option value=""></option>
                                <option value="Fannie">Fannie</option>
                                <option value="FHA">FHA</option>
                                <option value="Freddie Mac">Freddie Mac</option>
                                <option value="Ginnie Mae">Ginnie Mae</option>
                                <option value="Conventional">Conventional</option>
                                <option value="Private">Private</option>
                            </select>
                        </li>

                    </ul>
                </div>

            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Assigned Processor</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">name</label>
                        <input class="ss_form_input" value="<%=summaryCase.AssignedProcessor.Name%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_phone" value="<%=summaryCase.AssignedProcessor.Cell%>">
                    </li>


                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Referral</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">name</label>
                        <input class="ss_form_input" value="<%=summaryCase.ReferralContact.Name %>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Cell phone #</label>
                        <input class="ss_form_input ss_phone" value="<%=summaryCase.ReferralContact.Cell%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title ">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Manager</label>
                        <input class="ss_form_input" value="<%=summaryCase.Manager %>">
                    </li>
                    <%--<li class="ss_form_item">
                        <label class="ss_form_input_title">Cell phone #</label>
                        <input class="ss_form_input" value="Manager's cell phone ??">
                    </li>--%>
                    <%-- <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>--%>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Office</label>
                        <input class="ss_form_input" value="<%=summaryCase.ReferralContact.Office %>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Offie phone #</label>
                        <input class="ss_form_input ss_phone" value="<%=summaryCase.ReferralContact.OfficeNO %>">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Seller attorney</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">name</label>
                        <input class="ss_form_input" value="<%=summaryCase.SellerAttorneyContact.Name %>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_phone" value="<%=summaryCase.SellerAttorneyContact.Cell %>">
                    </li>

                </ul>
            </div>

        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>



