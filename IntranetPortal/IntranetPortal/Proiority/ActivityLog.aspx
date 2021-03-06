﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ActivityLog.aspx.vb" Inherits="IntranetPortal.ActivityLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="../styles/stevencss.css" rel='stylesheet' type='text/css' />
    <link href="../css/font-awesome.css" type="text/css" rel="stylesheet" />

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <script>
        $(document).ready(function () {

            if ($(".tooltip-examples").tooltip) {
                $(".tooltip-examples").tooltip({
                    placement: 'bottom'
                });
            } else {
                alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
            }

        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="font-size: 12px; color: #9fa1a8;">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                <li class="short_sale_head_tab activity_light_blue">
                    <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                        <i class="fa fa-history head_tab_icon_padding"></i>
                        <div class="font_size_bold">Activity Log</div>
                    </a>
                </li>

                <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                <li style="margin-right: 30px; color: #7396a9; float: right">
                    <i class="fa fa-calendar-o sale_head_button tooltip-examples" title="Schedule"></i>
                    <i class="fa fa-phone sale_head_button sale_head_button_left"></i>
                    <i class="fa fa-sign-in  sale_head_button sale_head_button_left"></i>
                    <i class="fa fa-list-ol sale_head_button sale_head_button_left"></i>
                    <i class="fa fa-print sale_head_button sale_head_button_left"></i>
                </li>
            </ul>


            <%--comment box filters--%>
            <div style="padding: 20px; background: #f5f5f5" class="clearfix">
                <%--comment box and text--%>

                <div style="float: left; height: 110px; width: 450px; margin-top: 10px;">
                    <div class="clearfix">
                        <span style="color: #295268;" class="upcase_text">Add Comment&nbsp;&nbsp;<i class="fa fa-comment" style="font-size: 14px"></i></span>
                        <input type="radio" id="is_public" name="is_public" value="Fannie" class="font_12" />
                        <label for="is_public" class="font_12">
                            <span class="upcase_text">Internal update</span>
                        </label>
                        <input type="radio" id="is_publicf" name="is_public" value="FHA" class="font_12" />
                        <label for="is_publicf" class="font_12">
                            <span class="upcase_text">Public update</span>
                        </label>
                    </div>
                    <textarea style="border-radius: 5px; width: 100%; height: 90px; border: 2px solid #dde0e7;">
                    </textarea>
                </div>
                <div class="clearfix">
                    <div style="float: right">
                        <div style="color: #2e2f31; float: right">
                            FILTER BY:&nbsp;&nbsp<i class="fa fa-filter acitivty_short_button" style="color: #444547; font-size: 14px;"></i>
                        </div>

                        <div style="margin-top: 50px">
                            <div class="border_under_line">
                                <select class="text_input" style="width: 120px; margin-bottom: 5px; background: #f5f5f5">
                                    <option value="volvo" class="text_input">6/9/2014</option>
                                    <option value="saab" class="text_input">6/10/2014</option>
                                    <option value="opel" class="text_input">Type3</option>
                                    <option value="audi" class="text_input">Type4</option>
                                </select>
                            </div>

                        </div>
                        <div style="margin-top: 15px; float: right">
                            <i class="fa fa-plus-circle activity_add_buttons" style="margin-right: 15px;"></i>
                            <i class="fa fa-tasks activity_add_buttons"></i>
                        </div>
                    </div>
                </div>
            </div>
            <%-------end-----%>
            <%-- log tables--%>
            <div>
                <table style="font-size: 14px;">
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_green_bg">
                                <i class="fa fa-check"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Deal closed
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 4, 2014 5:03 pm
                            </div>
                        </td>
                    </tr>
                    <tr style="background: #f5f5f5">
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_red_bg">
                                <i class="fa fa-info"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Priority
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>
                    <tr style="height: 40px;" class="activity_log_high_light " valign="top">
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_light_blue2" style="margin-left: -3px">
                                <i class="fa fa-clock-o"></i>
                            </div>

                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                <div class="font_black color_balck clearfix">
                                    Appointment with Mr.Ulric 
                                    <div style="float: right; font-size: 18px">
                                        <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" title="Accept"></i>
                                        <i class="fa fa-times-circle-o log_item_hl_buttons"></i>
                                        <i class="fa fa-history log_item_hl_buttons"></i>
                                    </div>
                                </div>
                                <table style="margin-top: 5px;">
                                    <tr>
                                        <td><i class="fa fa-info-circle log_item_icon"></i></td>
                                        <td>Signing</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-clock-o log_item_icon"></i></td>
                                        <td>Jun 10, 2014 5:00 pm</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-clock-o log_item_icon"></i></td>
                                        <td>Jun 10, 2014 5:00 pm</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-map-marker log_item_icon"></i></td>
                                        <td>In office</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-hand-o-right log_item_icon"></i></td>
                                        <td>Any manager</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-comment log_item_icon"></i></td>
                                        <td>Client has own attorney</td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                    <tr style="height: 40px;" class="activity_log_high_light " valign="top">
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon" style="margin-left: -3px; background: #eb7171">
                                <i class="fa fa-tasks"></i>
                            </div>

                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                <div class="font_black color_balck clearfix">
                                    Task completed  Mr.Ulric 
                                    <div style="float: right; font-size: 18px">
                                        <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" title="Completed"></i>
                                        <i class="fa fa-history log_item_hl_buttons" onclick=""></i>
                                    </div>
                                </div>
                                <table style="margin-top: 5px;">
                                    <tr>
                                        <td><i class="fa fa-group log_item_icon"></i></td>
                                        <td>123 Ron</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-hand-o-right log_item_icon"></i></td>
                                        <td>Lookup Request</td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-sort-numeric-asc log_item_icon"></i></td>
                                        <td>Important</td>
                                    </tr>

                                    <tr>
                                        <td><i class="fa fa-comment log_item_icon"></i></td>
                                        <td>TEstdddd</td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>
                    <%--check--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_check">
                                <i class="fa fa-check"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Deal closed
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                    <%--info--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_info">
                                <i class="fa fa-info"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Priority > Priority
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>
                    <%--comment--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_comment">
                                <i class="fa fa-comment"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                The appointment with Mr.Ulric has been moved to 6/12/14 @3pm.
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--clock-o--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_clock-o">
                                <i class="fa fa-clock-o"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                               Appointment accepted
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>
                   
                     <%--cubes--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_cubes">
                                <i class="fa fa-cubes"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                               Construction began
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>
                     <%--refresh--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_refresh">
                                <i class="fa fa-refresh"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                               Homeowner info updated
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--usd--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_usd">
                                <i class="fa fa-usd"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                               Accounting information
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--tasks--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_tasks">
                                <i class="fa fa-tasks"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                               Task completed
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--fax--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_fax">
                                <i class="fa fa-fax"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Contract faxed to Mr.Ulric (347-123-4567)
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--envelope--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_envelope">
                                <i class="fa fa-envelope"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Document A emailed to Mr.Ulric 
(example@email.com)
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--print--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_print">
                                <i class="fa fa-print"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                               Document B printed
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                     <%--sign-out--%>
                    <tr>
                        <td class="log_item_padding">
                            <div class="activity_log_item_icon activity_color_sign-out">
                                <i class="fa fa-sign-out"></i>
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col1">
                                Eviction
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col2">
                                Andrea Taylor
                            </div>
                        </td>
                        <td class="log_item_padding">
                            <div class="log_item_col3">
                                Jun 12, 2014 5:08 pm
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
            <%------end-------%>
        </div>
    </form>
</body>
</html>
