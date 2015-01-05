<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleMortgageTab.ascx.vb" Inherits="IntranetPortal.ShortSaleMortgageTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<script src="/scripts/stevenjs.js?v=1.02"></script>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />
    </div>
</div>



<div data-array-index="0" data-field="Mortgages" class="ss_array" style="display: none">
    <%--<h3 class="title_with_line"><span class="title_index title_span">Mortgages </span></h3>--%>
    <h4 class="ss_form_title title_with_line">
        <span class="title_index title_span">Mortgage __index__1</span>&nbsp;
         <i class="fa fa-expand expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>
        &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="Add"></i>
        <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="Delete"></i>
    </h4>
    <div class="collapse_div">
        <div>
            <%--<h4 class="ss_form_title title_with_line"><span class="title_index title_span">Mortgage __index__</span>  <i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'mortgage1')"></i> &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="AddArraryItem(event,this)" title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples" onclick="delete_array_item(this)" title="Delete"></i> 
        </h4>--%>


            <ul class="ss_form_box clearfix" id="mortgage__index__">
                <li class="ss_form_item ss_mortages_stauts">
                    <label class="ss_form_input_title">Status</label>
                    <select class="ss_form_input " data-item="Status" data-item-type="1">
                        <option value=""></option>
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
                        <option value="Approved">Approved</option>
                    </select>

                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last BPO completed on</label>
                    <input class="ss_form_input ss_date" data-item="LastBPOUpdate" data-item-type="1">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">LENDER</label>
                    <input class="ss_form_input" data-item="Lender" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Loan #</label>
                    <input class="ss_form_input" data-item="Loan" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">LOAN AMOUNT</label>
                    <%--<dx:ASPxTextBox Native="true" runat="server" CssClass="ss_form_input" data-item="LoanAmount">
                        <MaskSettings Mask="$<0..99999g>.<00..99>" IncludeLiterals="DecimalSymbol" />
                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip" />
                        <ClientSideEvents Init="price_InitAndKeyUp" KeyUp="price_InitAndKeyUp" />
                    </dx:ASPxTextBox>--%>

                    <input class="ss_form_input currency_input" data-item="LoanAmount" data-item-type="1" onblur="$(this).formatCurrency();">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Authorization Sent On</label>
                    <input class="ss_form_input ss_date" data-item="AuthorizationSent" data-item-type="1">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tax Class</label>
                    <input class="ss_form_input" data-field="PropertyInfo.TaxClass">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title"># of Families</label>
                    <input class="ss_form_input" data-field="PropertyInfo.NumOfFamilies">
                </li>

                <li class="ss_form_item">
                    <span class="ss_form_input_title">FHA</span>

                    <input type="radio" id="checkYes_FHA__index__" name="FHAname__index__" data-item="FHA" data-item-type="1" data-radio="Y" value="YES" class="ss_form_input">
                    <label for="checkYes_FHA__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_noFHA__index__" name="FHAname__index__" data-item="FHA" data-item-type="1" value="NO" class="ss_form_input">
                    <label for="none_check_noFHA__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                <li class="ss_form_item">
                    <span class="ss_form_input_title">FANNIE MAE</span>

                    <input type="radio" id="checkYes_Fannie2__index__" name="Fannie__index__" data-item="Fannie" data-item-type="1" data-radio="Y" value="YES" class="ss_form_input">
                    <label for="checkYes_Fannie2__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check2_Fannie__index__" name="Fannie__index__" data-item="Fannie" data-item-type="1" value="NO" class="ss_form_input">
                    <label for="none_check2_Fannie__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                <li class="ss_form_item">
                    <span class="ss_form_input_title">FREDDIE MAC</span>

                    <input type="radio" id="checkYes_FREDDIE_MAC__index__" name="FREDDIE_MAC__index__" data-item="Freddie" data-item-type="1" data-radio="Y" value="YES" class="ss_form_input">
                    <label for="checkYes_FREDDIE_MAC__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_FREDDIE_MAC__index__" name="FREDDIE_MAC__index__" data-item="Freddie" data-item-type="1" value="NO" class="ss_form_input">
                    <label for="none_check_FREDDIE_MAC__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">Lien Postion</label>
                <select class="ss_form_input">
                    <option value="volvo">1 st</option>
                    <option value="saab">2 nd</option>
                    <option value="mercedes">3 rd</option>
                    <option value="audi">4 th</option>
                </select>

            </li>--%>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Short sale dept 
                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('Mortgages[__index__].ShortSaleDeptContact', function(party){ShortSaleCaseData.Mortgages[__index__].ShortSaleDept =party.ContactId})"></i>

            </h4>
            <ul class="ss_form_box clearfix" id="short_sale_dept">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">phone #</label>
                    <input class="ss_form_input ss_not_edit" data-item="ShortSaleDeptContact.Cell" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input" data-item="AuthorizationSent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">customer service</label>
                    <input class="ss_form_input ss_not_edit" data-item="ShortSaleDeptContact.OfficeNO" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input" data-item="AuthorizationSent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" data-item="AuthorizationSent" data-item-type="1">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input ss_not_edit" data-item="ShortSaleDeptContact.OfficeNO" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email</label>
                    <input class="ss_form_input ss_not_edit" data-item="ShortSaleDeptContact.Email" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" data-item="AuthorizationSent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Lender
                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('Mortgages[__index__].LenderContact', function(party){ShortSaleCaseData.Mortgages[__index__].LenderContactId =party.ContactId})"></i>

            </h4>
            <ul class="ss_form_box clearfix" >
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Name</label>
                    <input class="ss_form_input ss_not_edit" data-item="LenderContact.Name" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">phone #</label>
                    <input class="ss_form_input ss_not_edit" data-item="LenderContact.Cell" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input" data-item="AuthorizationSent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">customer service</label>
                    <input class="ss_form_input ss_not_edit" data-item="LenderContact.OfficeNO" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input" data-item="AuthorizationSent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" data-item="AuthorizationSent" data-item-type="1">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input ss_not_edit" data-item="LenderContact.OfficeNO" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email</label>
                    <input class="ss_form_input ss_not_edit" data-item="LenderContact.Email" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" data-item="AuthorizationSent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
            </ul>
        </div>
        <div class="ss_form">
            <h4 class="ss_form_title">Processor 
                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('Mortgages[__index__].ProcessorContact', function(party){ShortSaleCaseData.Mortgages[__index__].Processor =party.ContactId})"></i>

            </h4>
            <ul class="ss_form_box clearfix" id="processor_list">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Name</label>
                    <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Assigned to Processor</label>
                    <input class="ss_form_input " value="Date Assigned ??">
                </li>--%>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" data-item="ProcessorContact.Email" data-item-type="1">
            </li>--%>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #</label>
                    <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input " data-item="ProcessorContact.Email" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">email</label>
                    <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1">
                </li>
            </ul>

        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Negotiator 
                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('Mortgages[__index__].NegotiatorContact', function(party){ShortSaleCaseData.Mortgages[__index__].Negotiator =party.ContactId})"></i>
            </h4>
            <ul class="ss_form_box clearfix" id="negotiator_list">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Name</label>
                    <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #</label>
                    <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input " value="616">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">email</label>
                    <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Email" data-item-type="1">
                </li>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Supervisor 
                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('Mortgages[__index__].SupervisorContact', function(party){ShortSaleCaseData.Mortgages[__index__].Supervisor =party.ContactId})"></i>

            </h4>
            <ul class="ss_form_box clearfix" id="supervisor_list">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Name</label>
                    <input class="ss_form_input ss_not_edit" data-item="SupervisorContact.Name" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">extension</label>
                <input class="ss_form_input " value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #</label>
                    <input class="ss_form_input ss_not_edit" data-item="SupervisorContact.Cell" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input " value="616">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input ss_not_edit" data-item="SupervisorContact.OfficeNO" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">email</label>
                    <input class="ss_form_input ss_not_edit" data-item="SupervisorContact.Email" data-item-type="1">
                </li>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Closer
      <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('Mortgages[__index__].CloserContact', function(party){ShortSaleCaseData.Mortgages[__index__].Closer =party.ContactId})"></i>

            </h4>
            <ul class="ss_form_box clearfix" id="closer_list">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">closer</label>
                    <input class="ss_form_input ss_not_edit" data-item="CloserContact.Name" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                <label class="ss_form_input_title">extension</label>
                <input class="ss_form_input " value="56">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #</label>
                    <input class="ss_form_input ss_not_edit" data-item="CloserContact.Cell" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <%--    <label class="ss_form_input_title">Extension</label>
                <input class="ss_form_input " value="616">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input ss_not_edit" data-item="CloserContact.OfficeNO" data-item-type="1">
                </li>
                <%-- <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">email</label>
                    <input class="ss_form_input ss_not_edit" data-item="CloserContact.Email" data-item-type="1">
                </li>
            </ul>
        </div>
    </div>
</div>


