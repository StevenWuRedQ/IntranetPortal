<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleSummaryTab.ascx.vb" Inherits="IntranetPortal.ShortSaleSummaryTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<script>
    function refreshSummary() {
        summary_call_back_panel_client.PerformCallback(ShortSaleCaseData.CaseId);
    }
    function reinitClient(s, e) {
        ShortSaleDataBand(0);
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

                        <input type="radio" id="pdf_check_no" name="1" <%= ShortSalePage.CheckBox( Not summaryCase.PropertyInfo.CO)%> value="NO" class="ss_form_input">
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
                        <input class="ss_form_input" value="<%=owner.SSN %>">
                    </li>
                    <li class="ss_form_item">
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
                            <label class="ss_form_input_title">Stuats</label>
                            <select class="ss_form_input " data-item="Status" data-item-type="1">
                                <option value="NULL">NULL</option>
                                <option value="Ready for Submission">Ready for Submission</option>
                                <option value="Pending Service Release">Pending Service Release</option>
                                <option value="Package Submitted">Package Submitted</option>
                                <option value="Package Submitted in Equator">Package Submitted in Equator</option>
                                <option value="Pending BPO Expiration">Pending BPO Expiration</option>
                                <option value="Processor Assigned">Processor Assigned</option>
                                <option value="Document Review">Document Review</option>
                                <option value="Updated Docs Needed">Updated Docs Needed</option>
                                <option value="Processor BPO Ordered">Processor BPO Ordered</option>
                                <option value="Processor BPO Schdeduled">Processor BPO Schdeduled</option>
                                <option value="Processor BPO Completed">Processor BPO Completed</option>
                                <option value="Negotiator BPO Ordered">Negotiator BPO Ordered</option>
                                <option value="Negotiator BPO Schdeduled">Negotiator BPO Schdeduled</option>
                                <option value="Negotiator BPO Completed">Negotiator BPO Completed</option>
                                <option value="Auction/Hubzu Opt Out">Auction/Hubzu Opt Out</option>
                                <option value="Negotiator Assigned">Negotiator Assigned</option>
                                <option value="Offer Review">Offer Review</option>
                                <option value="Counter Offer">Counter Offer</option>
                                <option value="Value Dispute">Value Dispute</option>
                                <option value="Marketing W/ Price Reductions">Marketing W/ Price Reductions</option>
                                <option value="Investor Review">Investor Review</option>

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
                            <input class="ss_form_input input_currency" onblur="$(this).formatCurrency();" data-item="LoanAmount" data-item-type="1">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Short Sale Dept</label>
                            <input class="ss_form_input" value="866-880-1232">
                        </li>

                        <li class="ss_form_item">
                            <span class="ss_form_input_title">&nbsp;</span>

                            <input type="checkbox" id="pdf_check_yes1__index__" name="1">
                            <label for="pdf_check_yes1__index__" class="input_with_check">
                                <span class="box_text">Fannie</span>
                            </label>

                            <input type="checkbox" id="pdf_check_no2__index__" name="1">
                            <label for="pdf_check_no2__index__" class="input_with_check">
                                <span class="box_text">FHA</span>
                            </label>

                        </li>
                        <li class="ss_form_item">
                            <span class="ss_form_input_title">&nbsp;</span>

                            <input type="checkbox" id="pdf_check_yes3__index__" name="1" value="YES">
                            <label for="pdf_check_yes3__index__" class="input_with_check">
                                <span class="box_text">Freddie Mac </span>
                            </label>

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
                        <input class="ss_form_input" value="<%=summaryCase.AssignedProcessor.Cell%>">
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
                        <input class="ss_form_input" value="<%=summaryCase.ReferralContact.Cell%>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title ">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Manager</label>
                        <input class="ss_form_input" value="Manager ??">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Cell phone #</label>
                        <input class="ss_form_input" value="Manager's cell phone ??">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input ss_form_hidden" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Office</label>
                        <input class="ss_form_input" value="<%=summaryCase.ReferralContact.Office %>">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Offie phone #</label>
                        <input class="ss_form_input" value="<%=summaryCase.ReferralContact.OfficeNO %>">
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
                        <input class="ss_form_input" value="<%=summaryCase.SellerAttorneyContact.Cell %>">
                    </li>

                </ul>
            </div>

        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>



