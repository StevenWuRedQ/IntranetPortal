<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Title.ascx.vb" Inherits="IntranetPortal.Title" %>
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
                <span class="time_buttons">See Titile Report</span>

            </div>
            <%--data format June 2, 2014 6:37 PM--%>
            <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">Started on June 2,1014</span>
        </div>

        <%--note list--%>
        <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
        </div>
        <div class="short_sale_content">
            <div class="ss_form">
                <h4 class="ss_form_title">Property <i class="fa fa-plus-circle  color_blue_edit collapse_btn"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item" style="width: 117%">
                        <label class="ss_form_input_title">Address</label>
                        <input class="ss_form_input" value="151-04 Main St, Flushing, NY 11367">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Block</label>
                        <input class="ss_form_input" value="3341">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Lot</label>
                        <input class="ss_form_input" value="23">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title"># Of Families</label>
                        <input class="ss_form_input" value="2">
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
            <div class="ss_form">
                <h4 class="ss_form_title">Proposed Closeing date <i class="fa fa-plus-circle  color_blue_edit collapse_btn"></i></h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Proposed Closing Date</label>
                        <input class="ss_form_input" value="October 2, 2014">
                    </li>

                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Sellers Title Commpany <i class="fa fa-plus-circle  color_blue_edit collapse_btn"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Company Name</label>
                        <input class="ss_form_input" value="NYC Title Inc">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input" value="347-123-456">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Ordered</label>
                        <input class="ss_form_input" value="Apr 14, 2014">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Received</label>
                        <input class="ss_form_input" value="May 3, 2014">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Order Number</label>
                        <input class="ss_form_input" value="BTA-1751">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Buyers Title Commpany  <i class="fa fa-plus-circle  color_blue_edit collapse_btn"></i></h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Company Name</label>
                        <input class="ss_form_input" value="Real World">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input" value="347-123-456">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">&nbsp;</label>
                        <input class="ss_form_input" value=" ">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Ordered</label>
                        <input class="ss_form_input" value="Apr 14, 2014">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Report Received</label>
                        <input class="ss_form_input" value="May 3, 2014">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Title Order Number</label>
                        <input class="ss_form_input" value="BTA-5322">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Judgment Search </h4>
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
                <h4 class="ss_form_title">Clearence <i class="fa fa-plus-circle  color_blue_edit collapse_btn"></i></h4>
                <%--clearence list--%>
                <div>
                    <%--index 1--%>
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                1
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue
                                    </div>
                                    <div class="clearence_list_text18">
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

                    <%--index 2--%>
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                2
                            </div>

                            <div class="clearence_list_right">
                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Issue(Cleared)
                                    </div>
                                    <div class="clearence_list_text18" style="text-decoration:line-through">
                                        Title in Jaime Torres and Tahnee Torres
                                    </div>
                                </div>
                                

                                

                                <div class="clearence_list_text">
                                    <div class="clearence_list_title">
                                        Amounts
                                    </div>
                                    <div class="clearence_list_text14" style="text-decoration:line-through">
                                        $191,500.00
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                     <%--index 3--%>
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index">
                                4
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
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix">
                            <div class="clearence_list_index  color_blue_edit">
                                3
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
                                        notes
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
                    <%--index 5--%>
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
                    <%--index 6--%>
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
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>
