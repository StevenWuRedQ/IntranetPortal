<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Priority.aspx.vb" Inherits="IntranetPortal.Priority" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Priority</title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="../styles/stevencss.css" rel='stylesheet' type='text/css' />
    <link href="../css/font-awesome.css" type="text/css" rel="stylesheet" />

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="../scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scripts/jquery.collapse.js"></script>
    <script src="/scripts/jquery.collapse_storage.js"></script>
    <script src="/scripts/jquery.collapse_cookie_storage.js"></script>
</head>
<body>
    <form id="form1" runat="server">

        <div style="width: 980px; height: 960px">

            <%--left div--%>
            <div style="width: 310px; color: #999ca1; position: relative" class="agent_layout_float">
                <%--top block--%>
                <div>
                    <div style="margin: 30px 20px 30px 30px">
                        <div style="font-size: 24px;">
                            <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Employees</span>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="fa fa-sort-amount-desc"></i>
                        </div>

                        <div style="margin-top: 27px; height: 290px; /*background: blue*/">
                            <div>
                                <i class="fa fa-user font_black color_balck"></i>
                                <span class="font_black color_balck">&nbsp;David Peterson</span>&nbsp;&nbsp;&nbsp;
                                <span class="employee_lest_head_number_label">2</span>
                            </div>
                            <ul style="margin-left: -35px; margin-top: 10px;">
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">1072 DE KALB AVE </span>
                                        - 1072 DEKALB AVENUE LLC
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">1089 DE KALB AVE </span>
                                        - 1089 DEKALB AVE TRUST
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                            </ul>

                            <div class="employee_list_group_margin">
                                <i class="fa fa-user font_black color_balck"></i>
                                <span class="font_black color_balck">&nbsp;John Smith</span>&nbsp;&nbsp;&nbsp;
                                <span class="employee_lest_head_number_label">3</span>
                            </div>
                            <ul style="margin-left: -35px; margin-top: 10px;">
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">123 ST  </span>
                                        - 1072 DEKALB AVENUE LLC
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">1089 DE KALB AVE </span>
                                        - 1089 DEKALB AVE TRUST
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>

                                <li class="employee_list_item">

                                    <div class="employee_list_item_div">
                                        <span class="font_black">3023 BELL  </span>
                                        - 1089 DEKALB AVE TRUST
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <%----end top block----%>

                <%-----buttom infos--%>
                <div style="position: absolute; bottom: 0; padding-left: 32px; margin-bottom: 100px">
                    <%-- margin-bottom:30px--%>
                    <div style="position: relative; float: left">
                        <table>
                            <tr>
                                <td>
                                    <div class="priority_info_label priority_info_lable_org">
                                        <span class="font_black">1,796 </span><span class="font_extra_light">Leads</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="priority_info_label priority_info_label_blue" style="float: left; margin-left: 5px;">
                                        <span class="font_black">0 </span><span class="font_extra_light">Deals</span>
                                    </div>
                                </td>
                            </tr>
                        </table>

                    </div>
                </div>
                <%-----end-----%>
            </div>
            <%--splite bar--%>
            <div class="agent_layout_float" style="background: #e7e9ee; width: 10px;"></div>
            <div style="width: 660px;" class="agent_layout_float">

                <div style="width: 660px; font-family: 'Source Sans Pro'">
                    <%--head tabs and buttoms--%>

                    <!-- Nav tabs -->
                    <ul class="nav nav-tabs" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                        <li class="active short_sale_head_tab">
                            <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                <i class="fa fa-info-circle head_tab_icon_padding"></i>
                                <div class="font_size_bold">Property Info</div>
                            </a>
                        </li>
                        <li class="short_sale_head_tab">
                            <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a">
                                <i class="fa fa-home head_tab_icon_padding"></i>
                                <div class="font_size_bold">Homeowner</div>
                            </a>
                        </li>
                        <li class="short_sale_head_tab">
                            <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a">
                                <i class="fa fa-file head_tab_icon_padding"></i>
                                <div class="font_size_bold">Documents</div>
                            </a>
                        </li>

                        <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                        <li style="margin-left: 48px; color: #ffa484">
                            <i class="fa fa-refresh sale_head_button"></i>
                            <i class="fa fa-envelope sale_head_button sale_head_button_left"></i>
                            <i class="fa fa-fax  sale_head_button sale_head_button_left"></i>
                            <i class="fa fa-print sale_head_button sale_head_button_left"></i>
                        </li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content">


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

                                    <form action="#">
                                        <%--line 1--%>
                                        <div class="form_div_node" style="width: 405px">
                                            <span class="form_input_title">address</span>

                                            <input class="text_input" value="61-12 122 ST, BAYSIDE, NY 11361" />
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
                                    </form>
                                </div>
                                <%-------end-----%>

                                <%--Mortgage form--%>
                                <div style="margin: 20px;" class="clearfix">
                                    <div class="form_head" style="margin-top: 40px;">MORTGAGE AND VIOLATIONS</div>

                                    <form action="#" class="clearfix">

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
                                    </form>
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
                        <div class="tab-pane clearfix" id="home_owner">

                            <%--id="home_owner_content" scorll bar some issue--%>
                            <%--style="overflow: auto;"--%>

                            <div class="clearfix" style="height: 800px; overflow: auto;" id="home_owner_content">
                                <div style="width: 330px; border-right: 1px solid #dde0e7; float: left;">
                                    <%--left side--%>
                                    <div class="homeowner_content clearfix">
                                        <div style="font-size: 30px; color: #2e2f31">
                                            <i class="fa fa-file">&nbsp;</i>
                                            <span class="homeowner_name">&nbsp;Kang, Boon C</span>
                                        </div>
                                        <div class="form_div_node form_div_no_float" style="width: 100%">
                                            <span class="form_input_title">age</span>

                                            <input class="text_input" value="09/1939 Born 74 Years Ago" />
                                        </div>
                                        <div class="form_div_node form_div_no_float" style="width: 100%">
                                            <span class="form_input_title">Death Indicator</span>

                                            <input class="text_input" value="Alive" />
                                        </div>
                                        <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                                            <span class="form_input_title">bankruptcy</span>
                                            <div class="clearfix">
                                                <span>Yes</span>
                                                <i class="fa fa-minus-square-o" style="float: right; color: #b1b2b7"></i>
                                            </div>
                                            <%--expanll list--%>
                                            <div style="margin-left: 14px; margin-top: 5px;" class="clearfix homeowner_expanll_border">
                                                <div style="margin-left: 20px;">
                                                    <div class="form_div_node form_div_no_float" style="width: 100%">
                                                        <span class="form_input_title">Type</span>

                                                        <input class="text_input" value="Any type" />
                                                    </div>
                                                    <div class="form_div_node form_div_no_float" style="width: 100%">
                                                        <span class="form_input_title">Year</span>

                                                        <input class="text_input" value="2010" />
                                                    </div>
                                                    <div class="form_div_node form_div_no_float" style="width: 100%">
                                                        <span class="form_input_title">Attorney</span>

                                                        <input class="text_input" value="John Smith" />
                                                    </div>
                                                    <div class="form_div_node form_div_no_float" style="width: 100%">
                                                        <span class="form_input_title">attorney phone number</span>
                                                        <input class="text_input" value="(347)123-456" />
                                                    </div>
                                                </div>
                                            </div>
                                            <%------end ------%>
                                            <%--empty line--%>
                                            <div style="height: 20px; width: 100%; border-bottom: 1px solid #dde0e7;">
                                                &nbsp;
                                            </div>
                                            <%-----end-----%>
                                        </div>

                                        <%--1st section info--%>
                                        <div style="margin-top: 270px;">
                                            <div class="form_head homeowner_section_margin">
                                                <span>Best Phone Numbers &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color"></i>
                                            </div>
                                            <div>
                                                <div class="clearfix homeowner_info_label">
                                                    <div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-phone homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text text_line_through">
                                                                <div>
                                                                    (347) 233-4243
                                                                </div>
                                                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font">
                                                                    (ET) ActiveLandLine (100%)
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="color_light_green filed_margin_top clearfix">
                                                            <i class="fa fa-phone homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text">
                                                                <div>
                                                                    (347) 233-4243
                                                                </div>
                                                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font">
                                                                    (ET) ActiveLandLine (100%)
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="color_gray filed_margin_top clearfix">
                                                            <i class="fa fa-phone homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text">
                                                                <div class="color_blue">
                                                                    (347) 233-4243
                                                                </div>
                                                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                    (ET) Mobile (82%)
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>

                                                </div>

                                            </div>

                                        </div>

                                        <%-----end -------%>

                                        <%-----2nd section info--%>
                                        <div>
                                            <div class="form_head homeowner_section_margin">
                                                <span>Best Addresses &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color"></i>
                                            </div>
                                            <div>
                                                <div class="clearfix homeowner_info_label">
                                                    <div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-map-marker homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text">
                                                                <div class="color_blue">
                                                                    9411 114TH ST, SOUTH RICHMOND HILL, NY 11419
                                                                   
                                                                </div>
                                                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                    04/1992 to 06/13/2014
                                                                </div>
                                                            </div>
                                                        </div>

                                                    </div>

                                                </div>

                                            </div>

                                        </div>
                                        <%----end-----%>

                                        <%-----3rd section info--%>
                                        <div>
                                            <div class="form_head homeowner_section_margin">
                                                <span>Best emails &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color"></i>
                                            </div>
                                            <div>
                                                <div class="clearfix homeowner_info_label">
                                                    <div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-envelope homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                                                                <div class="color_blue">
                                                                    cistool@igateway.net
                                                                   
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-envelope homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                                                                <div class="color_blue">
                                                                    cistool@hotmail.com
                                                                   
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-envelope homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                                                                <div class="color_blue">
                                                                    bkang@cis-inc.net
                                                                   
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        <%----end-----%>

                                        <%-----4th section info--%>
                                        <div>
                                            <div class="form_head homeowner_section_margin">
                                                <span>Best emails &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color"></i>&nbsp;
                                                    <i class="fa fa-stethoscope homeowner_plus_color"></i>
                                            </div>
                                            <div>
                                                <div class="clearfix homeowner_info_label">
                                                    <div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-envelope homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                                                                <div class="color_blue">
                                                                    cistool@igateway.net
                                                                   
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-envelope homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                                                                <div class="color_blue">
                                                                    cistool@hotmail.com
                                                                   
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="color_gray clearfix">
                                                            <i class="fa fa-envelope homeowner_info_icon"></i>
                                                            <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                                                                <div class="color_blue">
                                                                    bkang@cis-inc.net
                                                                   
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        <%----end-----%>

                                        <%-----5th section info--%>
                                        <div>
                                            <div class="form_head homeowner_section_margin">
                                                <span>First Degree Relatives &nbsp;</span>
                                            </div>
                                            <div class="color_gray clearfix filed_margin_top homeowner_title_margin">
                                                <i class="fa fa-chain color_gray homeowner_info_icon"></i>
                                                <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                                                    <span class="font_black color_balck">Zhang, Yan Fang</span><br />
                                                    <span style="font-size: 14px">Age <span class="color_balck">44</span></span>
                                                </div>

                                            </div>
                                            <div class="homeowner_expanll_border" style="margin-left: 20px">
                                                <div>
                                                    <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                                                        <div>
                                                            <div class="color_gray clearfix">
                                                                <i class="fa fa-phone homeowner_info_icon"></i>
                                                                <div class="form_div_node homeowner_info_text ">
                                                                    <div class="color_blue">
                                                                        (347) 233-4243
                                                                    </div>
                                                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                        (ET) ActiveLandLine (100%)
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="color_gray filed_margin_top clearfix">
                                                                <i class="fa fa-phone homeowner_info_icon"></i>
                                                                <div class="form_div_node homeowner_info_text">
                                                                    <div class="color_blue">
                                                                        (347) 789-4243
                                                                    </div>
                                                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                        (ET) ActiveLandLine (100%)
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <div class="color_gray filed_margin_top clearfix">
                                                                <i class="fa fa-phone homeowner_info_icon"></i>
                                                                <div class="form_div_node homeowner_info_text">
                                                                    <div class="color_blue">
                                                                        (347) 556-4243
                                                                    </div>
                                                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                        (ET) Mobile (82%)
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <span class="time_buttons more_buttom">Load More Info
                                                                </span>
                                                            </div>
                                                        </div>

                                                    </div>

                                                </div>
                                            </div>

                                        </div>
                                        <%----end-----%>
                                    </div>
                                    <%------end-----%>
                                </div>
                                <%--right side--%>
                                <div style="width: 329px; float: right;">

                                    <div class="homeowner_content clearfix">
                                        <div style="font-size: 30px; color: #2e2f31">
                                            <i class="fa fa-file">&nbsp;</i>
                                            <span class="homeowner_name">&nbsp;Kang, Boon C</span>
                                        </div>
                                        <div class="form_div_node form_div_no_float" style="width: 100%">
                                            <span class="form_input_title">age</span>

                                            <input class="text_input" value="09/1939 Born 74 Years Ago" />
                                        </div>
                                        <div class="form_div_node form_div_no_float" style="width: 100%">
                                            <span class="form_input_title">Death Indicator</span>

                                            <input class="text_input" value="Alive" />
                                        </div>
                                        <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                                            <span class="form_input_title">bankruptcy</span>

                                            <%--expanll list--%>


                                            <%------end ------%>
                                            <%--empty line--%>
                                            <div style="height: 30px; width: 100%; border-bottom: 1px solid #dde0e7;">
                                                None Found
                                            </div>
                                            <%-----end-----%>

                                            <%--1st section info--%>
                                            <div>
                                                <div class="form_head homeowner_section_margin">
                                                    <span>Best Phone Numbers &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color"></i>
                                                </div>
                                                <div>
                                                    <div class="clearfix homeowner_info_label">
                                                        <div>
                                                            <div class="color_gray filed_margin_top clearfix">
                                                                <i class="fa fa-phone homeowner_info_icon"></i>
                                                                <div class="form_div_node homeowner_info_text">
                                                                    <div class="color_blue">
                                                                        (347) 561-3980
                                                                    </div>
                                                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                        (ET) ActiveLandLine (100%)
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="color_gray filed_margin_top clearfix">
                                                                <i class="fa fa-phone homeowner_info_icon"></i>
                                                                <div class="form_div_node homeowner_info_text">
                                                                    <div class="color_blue">
                                                                        (347) 561-3989
                                                                    </div>
                                                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                        (ET) ActiveLandLine (100%)
                                                                    </div>
                                                                </div>
                                                            </div>


                                                        </div>

                                                    </div>

                                                </div>

                                            </div>

                                            <%-----end -------%>

                                            <%-----2nd section info--%>
                                            <div>
                                                <div class="form_head homeowner_section_margin">
                                                    <span>Best Addresses &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color"></i>
                                                </div>
                                                <div>
                                                    <div class="clearfix homeowner_info_label">
                                                        <div>
                                                            <div class="color_gray clearfix">
                                                                <i class="fa fa-map-marker homeowner_info_icon"></i>
                                                                <div class="form_div_node homeowner_info_text">
                                                                    <div class="color_blue">
                                                                        9411 114TH ST, SOUTH RICHMOND HILL, NY 11419
                                                                   
                                                                    </div>
                                                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                        05/1993 to 06/13/2014
                                                                    </div>
                                                                </div>
                                                            </div>

                                                        </div>

                                                    </div>

                                                </div>

                                            </div>
                                            <%----end-----%>

                                            <%-----5th section info--%>
                                            <div>
                                                <div class="form_head homeowner_section_margin">
                                                    <span>First Degree Relatives &nbsp;</span>
                                                </div>
                                                <div class="color_gray clearfix filed_margin_top homeowner_title_margin">
                                                    <i class="fa fa-chain color_gray homeowner_info_icon"></i>
                                                    <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                                                        <span class="font_black color_balck font_black upcase_text">Kang, Boon Chang</span><br />
                                                        <span style="font-size: 14px">Age <span class="color_balck">74</span></span>
                                                    </div>

                                                </div>
                                                <div class="homeowner_expanll_border" style="margin-left: 20px">
                                                    <div>
                                                        <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                                                            <div>
                                                                <div class="color_gray clearfix">
                                                                    <i class="fa fa-phone homeowner_info_icon"></i>
                                                                    <div class="form_div_node homeowner_info_text ">
                                                                        <div class="color_blue">
                                                                            (347) 233-4243
                                                                        </div>
                                                                        <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                            (ET) ActiveLandLine (100%)
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="color_gray filed_margin_top clearfix">
                                                                    <i class="fa fa-phone homeowner_info_icon"></i>
                                                                    <div class="form_div_node homeowner_info_text">
                                                                        <div class="color_blue">
                                                                            (347) 789-4243
                                                                        </div>
                                                                        <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                            (ET) ActiveLandLine (100%)
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="color_gray filed_margin_top clearfix">
                                                                    <i class="fa fa-phone homeowner_info_icon"></i>
                                                                    <div class="form_div_node homeowner_info_text">
                                                                        <div class="color_blue">
                                                                            (347) 556-4243
                                                                        </div>
                                                                        <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                                                            (ET) Mobile (82%)
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div>
                                                                    <span class="time_buttons more_buttom">Load More Info
                                                                    </span>
                                                                </div>
                                                            </div>

                                                        </div>

                                                    </div>
                                                </div>

                                            </div>
                                            <%----end-----%>
                                        </div>

                                    </div>
                                </div>
                                <%------end-----%>
                            </div>

                        </div>
                        <div class="tab-pane " id="documents">
                            <div class="clearfix color_gray">
                                <%--documents heads--%>
                                <div style="padding: 35px 20px 35px 20px;" class="border_under_line">
                                    <div style="width: 100%">
                                        <div class="font_30">
                                            <i class="fa fa-file"></i>&nbsp
                                            <span class="font_light">Documents</span>
                                        </div>
                                        <div style="padding-left: 39px;" class="clearfix">
                                            <span style="font-size: 14px;">1089 DE KALB AVE, BROOKLYN, NY 12345</span>
                                            <span class="color_blue expand_button" style="padding-right: 25px">Collapse All</span>
                                            <span class="color_blue expand_button">Expand All&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

                                        </div>
                                    </div>
                                </div>
                                <%-- document list --%>
                                <div class="clearfix">

                                    <%--left side--%>
                                    <div style="width: 330px; float: left" class="border_right">


                                        <div class="doc_list_section">
                                            <div id="default-example" data-collapse="">
                                                <h3 class="doc_list_title  open color_balck">Helpful Docs &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue"></i></h3>
                                                <div>
                                                    <div class="clearfix">
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id1" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id1">
                                                            <span class="color_balck">PayStub  </span>(Financials)
                                                        <span class="checks_data_text">April 3, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id2" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id2">
                                                            <span class="color_balck">Inside 1   </span>(Photos)
                                                        <span class="checks_data_text">March 21, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id3" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id3">
                                                            <span class="color_balck">PayStub  </span>(Construction)
                                                        <span class="checks_data_text">2013</span>

                                                        </label>
                                                    </div>
                                                </div>

                                            </div>

                                        </div>

                                        <div class="border_under_line" style="height: 23px">&nbsp;</div>
                                        <%--section 2--%>
                                        <div class="doc_list_section">
                                            <div data-collapse="">
                                                <h3 class="doc_list_title open">Financials   &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue"></i></h3>
                                                <div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id4" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id4">
                                                            <span class="color_balck">PayStub  </span>
                                                            <span class="checks_data_text">April 3, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id5" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id5">
                                                            <span class="color_balck">Bank Statement  </span>
                                                            <span class="checks_data_text">March 21, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id6" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id6">
                                                            <span class="color_balck">Tax Return  </span>
                                                            <span class="checks_data_text">2013</span>

                                                        </label>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <%--section 3--%>
                                        <div class="doc_list_section">
                                            <div data-collapse="">
                                                <h3 class="doc_list_title open">Short Sale &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue"></i></h3>
                                                <div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id7" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id7">
                                                            <span class="color_balck">HUD  </span>
                                                            <span class="checks_data_text">April 3, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id8" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id8">
                                                            <span class="color_balck">Authorization  </span>
                                                            <span class="checks_data_text">March 21, 2014</span>

                                                        </label>
                                                    </div>

                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id9" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id9">
                                                            <span class="color_balck">Client Info  </span>
                                                            <span class="checks_data_text">January 12 ,2014</span>

                                                        </label>
                                                    </div>

                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id10" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id10">
                                                            <span class="color_balck">Hardship  </span>
                                                            <span class="checks_data_text">January 12 ,2014</span>

                                                        </label>
                                                    </div>

                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id11" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id11">
                                                            <span class="color_balck">ID  </span>
                                                            <span class="checks_data_text">January 10 ,2014</span>

                                                        </label>
                                                    </div>

                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                    <%--right side--%>
                                    <div style="width: 330px; float: left">
                                        <%--section 1--%>
                                        <div class="doc_list_section">
                                            <div data-collapse="">
                                                <h3 class="doc_list_title open">Construction &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue"></i></h3>
                                                <div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id12" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id12">
                                                            <span class="color_balck">Bank Statement </span>
                                                            <span class="checks_data_text">April 3, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id13" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id13">
                                                            <span class="color_balck">filename.pdf</span>
                                                            <span class="checks_data_text">March 21, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id14" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id14">
                                                            <span class="color_balck">PayStub  </span>
                                                            <span class="checks_data_text">March 9,2014</span>

                                                        </label>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <%--section 2--%>
                                        <div class="doc_list_section">
                                            <div data-collapse="">
                                                <h3 class="doc_list_title open">Photos &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue"></i></h3>
                                                <div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id15" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id15">
                                                            <span class="color_balck">Front</span>
                                                            <span class="checks_data_text">April 3, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id16" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id16">
                                                            <span class="color_balck">Back</span>
                                                            <span class="checks_data_text">March 21, 2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id17" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id17">
                                                            <span class="color_balck">Inside 1  </span>
                                                            <span class="checks_data_text">March 9,2014</span>

                                                        </label>
                                                    </div>
                                                    <div>
                                                        <input type="checkbox" name="vehicle" value="Bike" id="doc_list_id18" />
                                                        <label class="doc_list_checks check_margin" for="doc_list_id18">
                                                            <span class="color_balck">Inside 2</span>
                                                            <span class="checks_data_text">March 21, 2014</span>

                                                        </label>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>


                                        <%--section 3--%>
                                        <div class="doc_list_section">
                                            <div data-collapse="">
                                                <h3 class="doc_list_title">Photos &nbsp;&nbsp;<i class="fa fa-plus-square-o color_blue"></i></h3>
                                                <div>
                                                </div>

                                            </div>
                                        </div>
                                        <%--section 4--%>
                                        <div class="doc_list_section">
                                            <div data-collapse="">
                                                <h3 class="doc_list_title">Photos &nbsp;&nbsp;<i class="fa fa-plus-square-o color_blue"></i></h3>
                                                <div>
                                                </div>

                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="height: 70px; background: #ff400d; font-size: 18px; color: white; display: none">
                            <div class="short_sale_head_tab">
                                <i class="fa fa-info-circle head_tab_icon_padding"></i>
                                <div class="font_size_bold">Property Info</div>
                            </div>
                            <div class="short_sale_head_tab">
                                <i class="fa fa-home head_tab_icon_padding"></i>
                                <div class="font_size_bold">Homeowner</div>

                            </div>
                            <div class="short_sale_head_tab">
                                <i class="fa fa-file head_tab_icon_padding"></i>
                                <div class="font_size_bold">Documents</div>
                            </div>
                            <div class="short_sale_head_tab short_sale_head_tab_nohover" style="width: 200px; margin-left: 55px; text-align: left; color: #ffa484">
                                <i class="fa fa-refresh sale_head_button"></i>
                                <i class="fa fa-envelope sale_head_button sale_head_button_left"></i>
                                <i class="fa fa-fax  sale_head_button sale_head_button_left"></i>
                                <i class="fa fa-print sale_head_button sale_head_button_left"></i>
                            </div>
                        </div>


                        <!-- custom scrollbar plugin -->

                        <script src="../scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
                        <script>
                            (function ($) {
                                $(window).load(function () {

                                    $("#prioity_content").mCustomScrollbar(
                                        {
                                            theme: "minimal-dark"
                                        }
                                        );
                                    $("#home_owner_content").mCustomScrollbar(
                                        {
                                            theme: "minimal-dark"
                                        }
                                        );

                                });
                            })(jQuery);
                        </script>
                        <script>
                            var el = $(".doc_list_title");

                            //el.collapse();
                            el.bind("opened", function (e, section) {
                                var h3 = e.target;
                                //alert("'" + h3.tagName + "' was opened");
                                var kids = $(h3).children();
                                kids.addClass("hilite");
                                var icon = kids.children();
                                //$(icon).toggleClass ('fa fa-minus-square-o color_blue');

                                var icon_e = icon;
                                //if (icon.length>1)
                                //{
                                //    icon_e = icon[1];
                                //}
                                if ($(icon_e).hasClass("fa")) {
                                    $(icon_e).removeClass('fa-plus-square-o').addClass('fa-minus-square-o');
                                }

                                $(h3).removeClass("hilite");
                                //section.$summary.find('fa').toggleClass('fa fa-minus-square-o color_blue');
                            })
                            .bind("closed", function (e, section) {
                                var h3 = e.target;
                                //alert("'" + h3.tagName + "' was closed");
                                var kids = $(h3).children();
                                kids.addClass("hilite");
                                var icon = kids.children();
                                //$(icon).toggleClass('fa fa-plus-square-o color_blue');
                                //if (icon.tagName === "i") {
                                $(icon).removeClass('fa-minus-square-o').addClass('fa-plus-square-o');
                                //}
                                $(h3).removeClass("hilite");
                                //fa fa-plus-square-o color_blue
                                //alert("'" + section.$summary.text() + "' was closed");
                                //section.$summary.find('fa').toggleClass('fa fa-plus-square-o color_blue');
                            });
                        </script>
                        <%-----------end-------%>
                        <%-----end-----%>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
