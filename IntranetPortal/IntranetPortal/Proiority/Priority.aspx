<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Priority.aspx.vb" Inherits="IntranetPortal.Priority" %>

<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>
<%@ Register Src="~/UserControl/PropertyInfo.ascx" TagPrefix="uc1" TagName="PropertyInfo" %>



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
    <script src="/Scripts/jquery.collapse.js"></script>
    <script src="/Scripts/jquery.collapse_storage.js"></script>
    <script src="/Scripts/jquery.collapse_cookie_storage.js"></script>
    <script src="/bower_components/jquery-formatcurrency/jquery.formatCurrency-1.4.0.js"></script>
    <script>
        $('.currency_input').blur(function () {
            alert('blur runned');
            $('.currency_input').formatCurrency();
        });
    </script>
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
                                <i class="fa fa-user color_balck font_16"></i>
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
                        
                        <uc1:PropertyInfo runat="server" ID="PropertyInfo" />
                        
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

                                            <input class="text_input currency_input" value="09/1939 Born 74 Years Ago" />
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

                                            <%-----best address section info--%>
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

                                            <%-----Degree section info--%>
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
