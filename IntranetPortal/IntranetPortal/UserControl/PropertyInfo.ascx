<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PropertyInfo.ascx.vb" Inherits="IntranetPortal.PropertyInfo" %>
<div class="tab-pane active" id="property_info">
    <%--witch scroll bar--%>
    <%--/*display:none need delete when realse--%>
    <div style="height: 800px; overflow: auto;" id="prioity_content">
        <%--refresh label--%>
        <div style="margin: 30px 20px; height: 30px; background: #ffefe4; color: #ff400d; border-radius: 15px; font-size: 14px; line-height: 30px;">
            <i class="fa fa-spinner fa-spin" style="margin-left: 30px"></i>
            <span style="padding-left: 22px">Lead is being updated, it will take a few minutes to complete.</span>
        </div>
        <%--time label--%>
        <div style="height: 80px; font-size: 30px; margin-left: 30px;" class="font_gray">
            <div style="font-size: 30px">
                <i class="fa fa-refresh"></i>
                <span style="margin-left: 19px;">Jun 9, 2014 1:12 PM</span>
                <span class="time_buttons" style="margin-right: 30px">eCourts</span>
                <span class="time_buttons">DOB</span>
                <span class="time_buttons">Acris</span>
                <span class="time_buttons">Maps</span>
            </div>
            <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">Started on June 2, 2014 6:37 PM</span>
        </div>

        <%--note list--%>
        <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
            <div class="note_item">
                <i class="fa fa-exclamation-circle note_img"></i>
                <span class="note_text">Water Lien is High - Possible Tenant Issues</span>
            </div>
            <div class="note_item" style="background: #e8e8e8">
                <i class="fa fa-exclamation-circle note_img"></i>
                <span class="note_text">Property Has Approx $150,000 Equity</span>
            </div>
            <div class="note_item" style="border-left: 5px solid #ff400d">

                <i class="fa fa-exclamation-circle note_img" style="margin-left: 25px;"></i>
                <span class="note_text">Property Has Approx 3,124 Unbuilt Sqft</span>
                <i class="fa fa-arrows-v" style="float: right; line-height: 40px; padding-right: 20px; font-size: 18px; color: #b1b2b7"></i>
                <i class="fa fa-times" style="float: right; padding-right: 25px; line-height: 40px; font-size: 18px; color: #b1b2b7"></i>

            </div>
            <div class="note_item" style="background: white">
                <i class="fa fa-plus-circle note_img" style="color: #3993c1"></i>
            </div>
        </div>


        <%--------%>
        <%--property form--%>
        <div style="margin: 20px" class="clearfix">
            <div class="form_head">General</div>

            
                <%--line 1--%>
                <div class="form_div_node" style="width: 405px">
                    <span class="form_input_title">address</span>

                    <input class="text_input" value="<%= LeadsInfoData.PropertyAddress%>" />
                </div>

                <div class="form_div_node form_div_node_margin">
                    <span class="form_input_title">bble</span>

                    <input class="text_input font_black" value="4073038902" />
                </div>
                <%--end line 1--%>
                <%--line 2--%>
                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">Neighborhood</span>
                    <input class="text_input" value="QUEENS" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Borough</span>

                    <input class="text_input" value="4" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Block</span>

                    <input class="text_input" value="7327" />
                </div>
                <%--end line 2--%>
                <%--line 3--%>

                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">Lot</span>
                    <input class="text_input" value="29" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">NYC SQFT</span>

                    <input class="text_input" value="1532" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Year Built</span>

                    <input class="text_input" value=" " />
                </div>

                <%----end line 3----%>

                <%--line 4--%>

                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">Building dem</span>
                    <input class="text_input" value="16'x36'" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Lot Dem</span>

                    <input class="text_input" value="28'x116'" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">stories</span>

                    <input class="text_input" value=" " />
                </div>

                <%----end line 4----%>

                <%-----line 5-----%>
                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">Tax class</span>
                    <input class="text_input" value="1" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Zoning (<span style="color: #0e9ee9">PDF</span>)</span>

                    <input class="text_input" value="28'x116'" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Unbuilt sqft</span>

                    <input class="text_input" value=" " />
                </div>
                <%----end line 5--%>

                <%-----line 6-----%>
                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">Max Far</span>
                    <input class="text_input" value="0.60" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">axtual far</span>

                    <input class="text_input" value="0.43" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Zestimate</span>

                    <input class="text_input" value=" " />
                </div>
                <%----end line --%>       
        </div>
        <%-------end-----%>

        <%--Mortgage form--%>
        <div style="margin: 20px;" class="clearfix">
            <div class="form_head" style="margin-top: 40px;">MORTGAGE AND VIOLATIONS</div>

        

                <%--line 1--%>
                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">1st Mortgage</span>
                    <input class="text_input" value="$1800,00.00" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin form_div_node_no_under_line clearfix">
                    <span class="form_input_title"></span>
                    <br />

                    <%--class="circle-radio-boxes"--%>
                    <input type="radio" id="sex" name="sex" value="Fannie" />
                    <label for="sex" class=" form_div_radio_group">
                        <span class="form_span_group_text">Fannie</span>
                    </label>
                    <input type="radio" id="sexf" name="sex" value="FHA" style="margin-left: 66px" />
                    <label for="sexf" class=" form_div_radio_group form_div_node_margin">
                        <span class="form_span_group_text">FHA</span>
                    </label>
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Servicer</span>

                    <input class="text_input" value=" " />
                </div>
                <%--end line --%>
                <%--line 2--%>

                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">2nd Mortgage</span>
                    <input class="text_input" value="$3,854.42" />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin form_div_node_no_under_line clearfix">
                    <span class="form_input_title"></span>
                    <br />

                    <%--class="circle-radio-boxes"--%>
                    <input type="radio" id="sex1" name="sex" value="Fannie" />
                    <label for="sex1" class=" form_div_radio_group">
                        <span class="form_span_group_text">Fannie</span>
                    </label>
                    <input type="radio" id="sexf1" name="sex" value="FHA" style="margin-left: 66px" />
                    <label for="sexf1" class=" form_div_radio_group form_div_node_margin">
                        <span class="form_span_group_text">FHA</span>
                    </label>
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Servicer</span>

                    <input class="text_input" value=" " />
                </div>

                <%----end line ----%>

                <%--line 3--%>

                <div class="form_div_node form_div_node_line_margin">
                    <span class="form_input_title">3nd Mortgage</span>
                    <input class="text_input" value=" " />
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin form_div_node_no_under_line clearfix">
                    <span class="form_input_title"></span>
                    <br />

                    <%--class="circle-radio-boxes"--%>
                    <input type="radio" id="sex2" name="sex" value="Fannie" />
                    <label for="sex2" class=" form_div_radio_group">
                        <span class="form_span_group_text">Fannie</span>
                    </label>
                    <input type="radio" id="sexf2" name="sex" value="FHA" style="margin-left: 66px" />
                    <label for="sexf2" class=" form_div_radio_group form_div_node_margin">
                        <span class="form_span_group_text">FHA</span>
                    </label>
                </div>

                <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                    <span class="form_input_title">Servicer</span>

                    <input class="text_input" value=" " />
                </div>

                <%----end line ----%>
                <div style="width: 230px" class="clearfix">
                    <%--line 4--%>

                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title">Taxes</span>
                        <input class="text_input" value="$180,000.00" />
                    </div>


                    <%----end line ----%>
                    <%--line 5--%>

                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title">water</span>
                        <input class="text_input" value="$180,000.00" />
                    </div>
                    <%----end line ----%>
                    <%--line 6--%>

                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title">ecb/dob</span>
                        <input class="text_input" value=" " />
                    </div>
                    <%--line 7--%>

                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title" style="color: #ff400d">Total debt</span>
                        <input class="text_input" value="$180,000.00" />
                    </div>

                    <%----end line ----%>
                </div>

                <%----end line ----%>
          
        </div>
        <%-------end-----%>

        <%--Liens table--%>
        <div style="margin: 20px;" class="clearfix">
            <div class="form_head" style="margin-top: 40px;">Lines</div>

            <table class="table table-condensed" style="width: 100%">
                <thead>
                    <tr>
                        <th class="report_head">Effective</th>
                        <th class="report_head">Expiration</th>
                        <th class="report_head">Type</th>
                        <th class="report_head">PlainTiff</th>
                        <th class="report_head">Defendant</th>
                        <th class="report_head">Index</th>

                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="report_content">8/23/2013</td>
                        <td class="report_content">8/23/2014</td>
                        <td class="report_content">H.P.D.ORDER TO CORRECT</td>
                        <td class="report_content">DEPT OF HOUSING PRESERVATION 100 GOLD ST 6TH FL NEW YORK NY 10038</td>
                        <td class="report_content">OWNER OF BLOCK & LOT</td>
                        <td class="report_content">HP 170/13</td>
                    </tr>
                    <tr style="color: #b1b2b7">
                        <td class="report_content">5/16/2013</td>
                        <td class="report_content">5/16/2016
                                            <span class="color_balck">SATISFIED: 11/15/2013</span>
                        </td>
                        <td class="report_content">JUDGEMENT</td>
                        <td class="report_content">DEPT OF HOUSING PRESERVATION 100 GOLD ST 6TH FL NEW YORK NY 10038</td>
                        <td class="report_content">BRIGG ESTRELLA</td>
                        <td class="report_content">HP 170/13</td>
                    </tr>
                </tbody>

            </table>
        </div>
        <%--end--%>
    </div>


</div>
