<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSale.aspx.vb" Inherits="IntranetPortal.ShortSale" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Short Sale</title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="../styles/stevencss.css" rel='stylesheet' type='text/css' />
    <link href="../css/font-awesome.css" type="text/css" rel="stylesheet" />

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">

        <div class="clearfix" style="width: 980px;height:980px;">
            <%--left div--%>
            <div style="width: 310px; color: #999ca1; position: relative" class="agent_layout_float">
                <%--top block--%>
                <div>
                    <div style="margin: 30px 20px 30px 30px">
                        <div style="font-size: 24px;" class="clearfix">
                            <i class="fa fa-folder-open with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i> &nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Cases</span>
                            <i class="fa fa-sort-amount-desc icon_right_s" ></i>
                        </div>

                        <div style="margin-top: 27px; height: 290px; /*background: blue*/">
                            
                            <ul style="margin-left: -40px; margin-top: 10px;">
                                <li class="employee_list_item employee_list_item_no_broder">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">1072 DE KALB AVE </span>
                                        - 1072 DEKALB AVENUE LLC
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                <li class="employee_list_item employee_list_item_no_broder">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">1089 DE KALB AVE </span>
                                        - 1089 DEKALB AVE TRUST
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                <li class="employee_list_item employee_list_item_no_broder">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">123 ST  </span>
                                        - 1072 DEKALB AVENUE LLC
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                  <li class="employee_list_item employee_list_item_no_broder">

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
            <%--short sale content--%>
            <div style="width: 660px;" class="agent_layout_float">
                <div style="width: 660px; font-family: 'Source Sans Pro'">
                    <%--head tabs and buttoms--%>
                    <div style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                        <div class="short_sale_head_tab">
                            <i class="fa fa-info-circle head_tab_icon_padding"></i>
                            <div class="font_size_bold">Overview</div>
                        </div>
                        <div class="short_sale_head_tab">
                            <i class="fa fa-key head_tab_icon_padding"></i>
                            <div class="font_size_bold">Title</div>

                        </div>
                        <div class="short_sale_head_tab">
                            <i class="fa fa-file head_tab_icon_padding"></i>
                            <div class="font_size_bold">Documents</div>
                        </div>
                        <div class="short_sale_head_tab " style="width: 200px; margin-left: 55px; text-align: left; color: #ffa484">
                            <i class="fa fa-refresh sale_head_button"></i>
                            <i class="fa fa-envelope sale_head_button sale_head_button_left"></i>
                            <i class="fa fa-share sale_head_button sale_head_button_left"></i>
                            <i class="fa fa-print sale_head_button sale_head_button_left"></i>
                        </div>
                    </div>
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

                    <%--tabs--%>
                    <div style="height: 40px; font-weight: 600; margin-top: 17px; font-size: 16px">
                        <div class="short_sale_buttom_tab">Summary</div>
                        <div class="short_sale_buttom_tab" style="border-color: #ff400d">Property Info</div>
                        <div class="short_sale_buttom_tab">Mortgages</div>
                        <div class="short_sale_buttom_tab">Homewoner</div>
                        <div class="short_sale_buttom_tab">Eviction</div>
                        <div class="short_sale_buttom_tab">Parties</div>
                    </div>
                    <%--edit buttom--%>
                    <div style="height: 40px">
                        <div style="width: 50px; height: 32px; border-radius: 16px; font-size: 12px; cursor: pointer; text-align: center; line-height: 32px; float: right; margin-right: 20px; margin-top: 10px; background: #99bdcf; color: white">Edit</div>
                    </div>

                    <%--property form--%>
                    <div style="margin: 20px">
                        <div class="form_head">Property</div>

                        <form action="#">
                            <div class="form_div_node">
                                <span class="form_input_title">Street Number</span>

                                <input class="text_input" value="151-04" />
                            </div>
                            <div class="form_div_node form_div_node_margin">
                                <span class="form_input_title">Street name</span>

                                <input class="text_input" value="Main St" />
                            </div>
                            <div class="form_div_node form_div_node_margin">
                                <span class="form_input_title">City</span>

                                <input class="text_input" value="Flushing" />
                            </div>

                            <div class="form_div_node form_div_node_line_margin">
                                <span class="form_input_title">STATE</span>

                                <input class="text_input" value="NY" />
                            </div>
                            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                                <span class="form_input_title">Zip</span>

                                <input class="text_input" value="11367" />
                            </div>
                            <div style="width: 255px; float: left"></div>
                            <div class="form_div_node form_div_node_line_margin">
                                <span class="form_input_title">BLOCK</span>

                                <input class="text_input" value="3341" />
                            </div>
                            <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                                <span class="form_input_title">lot</span>
                                <asp:TextBox ID="TextBox1" CssClass="text_input" runat="server"></asp:TextBox>
                                <%--<input class="text_input" value="72"/>--%>
                            </div>

                            <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                                <span class="form_input_title">buiding type</span>

                                <%--<input class="text_input" type="reset" />--%>
                                <select class="text_input">
                                    <option value="volvo" class="text_input">House</option>
                                    <option value="saab" class="text_input">APT</option>
                                    <option value="opel" class="text_input">Type3</option>
                                    <option value="audi" class="text_input">Type4</option>
                                </select>
                            </div>

                            <div class="form_div_node form_div_node_line_margin">
                                <span class="form_input_title"># of stories</span>

                                <input class="text_input" value="1" />
                            </div>
                            <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                                <span class="form_input_title"># of unit</span>

                                <input class="text_input" value="2" />
                            </div>

                            <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                                <span class="form_input_title" style="font-weight: 900">accessibitlity</span>
                                <select class="text_input">
                                    <option value="volvo" class="text_input">Lockbox-LOC</option>
                                    <option value="saab" class="text_input">Type2</option>
                                    <option value="opel" class="text_input">Type3</option>
                                    <option value="audi" class="text_input">Type4</option>
                                </select>
                            </div>
                            <div class="form_div_node form_div_node_line_margin form_div_radio_grup">
                                <span class="form_input_title">c/o (<span style="color: #0e9ee9">PDF</span>)</span><br />
                                <%--class="circle-radio-boxes"--%>

                                <input type="radio" id="sex" name="sex" value="Fannie" />
                                <label for="sex" class=" form_div_radio_group" style="padding-top: 4px;">
                                    <span class="form_span_group_text">Yes</span>
                                </label>
                                <input type="radio" id="sexf" name="sex" value="FHA" style="margin-left: 66px" />
                                <label for="sexf" class=" form_div_radio_group form_div_node_margin">
                                    <span class="form_span_group_text">No</span>
                                </label>
                                <%--<input type="radio" id="sex" name="sex" value="male" /><label for="sex" class="form_span_group_text form_div_radio_group">Yes</label>
                                <input type="radio" id="sexf" name="sex" value="female" style="margin-left: 66px" /><label for="sexf" class=" form_div_node_margin">No</label>--%>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <%--------end---------%>
        </div>

    </form>
</body>
</html>
