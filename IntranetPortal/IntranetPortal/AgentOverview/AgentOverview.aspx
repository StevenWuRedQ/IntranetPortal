<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AgentOverview.aspx.vb" Inherits="IntranetPortal.AgentOverview" %>

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
    <script src="../scripts/Chart.js"></script>
    <link rel="stylesheet" href="../scrollbar/jquery.mCustomScrollbar.css" />
    <%-- <style>
        #draggable_field2
        {
            width:100px;
            height:30px;
        }
    </style>--%>
    <style>
        canvas {
        }
    </style>
    <script type="text/javascript">
       
    </script>

</head>
<body style="font: 12px 'Source Sans Pro'">
    <form id="form1" runat="server">
        <%--test drag--%>
        <%--<div id="draggable_field2">drap</div>--%>
        <%--angent overview ui--%>

        <div style="width: 1630px; height: 960px">

            <%--left div--%>
            <div style="width: 310px; color: #999ca1;" class="agent_layout_float">
                <%--top block--%>
                <div style="height: 450px; border-bottom: 1px solid #dde0e7">
                    <div style="margin: 30px 20px 30px 30px">
                        <div style="font-size: 24px;">
                            <i class="fa fa-group with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Employees</span>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="fa fa-sort-amount-desc"></i>
                        </div>
                        <input type="text" data-var="@btn-info-color" class="form-control" style="width: 250px; margin-top: 25px; height: 30px; color:#b1b2b7" placeholder="Type employee’s name" />
                        <div style="margin-top: 27px; height: 290px; /*background: blue*/">
                            <div>
                                <span class="font_black">A</span>&nbsp;&nbsp;&nbsp;<span class="employee_lest_head_number_label">2</span>
                            </div>
                            <ul style="margin-left: -35px; margin-top: 10px;">
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">Alko Kone</span><br />
                                        Eviction
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">Allen Glover</span><br />
                                        Sales
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                            </ul>

                            <div class="employee_list_group_margin">
                                <span class="font_black">B</span>&nbsp;&nbsp;&nbsp;<span class="employee_lest_head_number_label">4</span>
                            </div>
                            <ul style="margin-left: -35px; margin-top: 10px;">
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">Benn Martin</span><br />
                                        Sales
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">Ben Gendin</span><br />
                                        Departemnt
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>

                                <li class="employee_list_item">
                                    <div class="employee_list_item_div">
                                        <span class="font_black">Bibi Khan</span><br />
                                        Short Sale
                                    </div>
                                    <i class="fa fa-list-alt employee_list_item_icon"></i>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <%----end top block----%>

                <%--bottom block--%>
                <div>
                    <div style="margin: 22px 0px 0px 30px; font-size: 24px; color: #234b60">Lead Status</div>

                    <%--menu list--%>
                    <div style="margin: 13px 30px 30px 30px">
                        <div class="agent_menu_list_item">Hot Leads</div>
                        <div class="agent_menu_list_item">Follow Up</div>
                        <div class="agent_menu_list_item">In Negotiation</div>
                        <div class="agent_menu_list_item">Dead Lead </div>
                        <div class="agent_menu_list_item">Closed</div>
                    </div>

                    <%-----end-----%>
                </div>
                <%----end bottom block--%>
            </div>
            <%--splite bar--%>
            <div class="agent_layout_float" style="background: #e7e9ee; width: 10px;"></div>

            <%--center containter--%>
            <div style="width: 1000px;" class="agent_layout_float">
                <%--center top--%>
                <div style="height: 490px; float: left; border-right: 1px solid #dde0e7;">
                    <%--angent info--%>

                    <div style="width: 370px; height: 490px; background: url('../images/profile_bg.png')">
                        <%--width:201 height:201--%>                     
                        <img src="<%=IIf(String.IsNullOrEmpty(CurrentEmployee.Picture), "/images/user-empty-icon.png", CurrentEmployee.Picture)%>" class="img-circle" style="margin-top: 40px; margin-left: 84px; height:200px; width:200px" />                       
                        <div style="margin-top: 28px; font-size: 30px; color: #234b60; line-height: 16px" class="agnet_info_text"><%= CurrentEmployee.Name %></div>
                        <div style="margin-top: 8px; font-size: 16px; color: #234b60; font-weight: 900" class="agnet_info_text"><%= CurrentEmployee.Position %></div>
                        <%--info detial--%>
                        <div style="font-size: 14px; margin-top: 25px">
                            <%--items--%>
                            <div class="agent_info_detial_left">Manger</div>
                            <div class="agent_info_detial_space">&nbsp;</div>
                            <div class="agent_info_detial_right"><%= CurrentEmployee.Manager%>&nbsp;</div>
                            <%----end item--%>
                            <%--items--%>
                            <div class="agent_info_detial_left">Office</div>
                            <div class="agent_info_detial_space">&nbsp;</div>
                            <div class="agent_info_detial_right"><%= CurrentEmployee.Position %>(<%= CurrentEmployee.Department%>)&nbsp; </div>
                            <%----end item--%>
                            <%--items--%>
                            <div class="agent_info_detial_left">Employee Since</div>
                            <div class="agent_info_detial_space">&nbsp;</div>
                            <div class="agent_info_detial_right"><%=String.Format("{0:d}", CurrentEmployee.EmployeeSince) %>&nbsp;</div>
                            <%----end item--%>
                            <%--items--%>
                            <div class="agent_info_detial_left">Cell</div>
                            <div class="agent_info_detial_space">&nbsp;</div>
                            <div class="agent_info_detial_right"><%= String.Format("{0:(###) ###-####}", CurrentEmployee.Cellphone) %>&nbsp;</div>
                            <%----end item--%>
                            <%--items--%>
                            <div class="agent_info_detial_left">Email</div>
                            <div class="agent_info_detial_space">&nbsp;</div>
                            <div class="agent_info_detial_right" style="color: #3993c1"><%= CurrentEmployee.Email%>&nbsp;</div>
                            <%----end item--%>
                            <%--items--%>

                            <%----end item--%>
                        </div>
                        <%-----end info detial-----%>
                    </div>                    
                </div>
                <%--chart UI--%>
                <div style="height: 490px;">
                    <div style="padding-top: 50px; font-size: 30px; color: #ff400d; text-align: center">In the last 6 months</div>
                    <div style="padding-left: 370px; padding-top: 50px; height: 325px;">
                        <div style="margin-left: 50px; margin-right: 50px; margin-bottom: 30px; /*background: blue; */ color: white; height: 100%;">
                            <canvas id="canvas" height="240" width="530"></canvas>
                            <div id="lineLegend"></div>
                            <script>

                                var lineChartData = {
                                    labels: ["Jan,2014", "Feb,2014", "Mar,2014", "Apr,2014", "May,2014", "Jun,2014"],
                                    datasets: [
                                        {
                                            fillColor: "rgba(220,220,220,0.5)",
                                            strokeColor: "rgba(220,220,220,1)",
                                            pointColor: "rgba(220,220,220,1)",
                                            pointStrokeColor: "#fff",
                                            pointHighlightFill: "#fff",
                                            pointHighlightStroke: "rgba(220,220,220,1)",
                                            data: [41, 42, 43, 45, 48, 49],
                                            title:"Door knock"
                                        },
                                        {
                                            fillColor: "rgba(151,187,205,0.5)",
                                            strokeColor: "rgba(151,187,205,1)",
                                            pointColor: "rgba(151,187,205,1)",
                                            pointStrokeColor: "#fff",
                                            pointHighlightFill: "#fff",
                                            pointHighlightStroke: "rgba(151,187,205,1)",
                                            data: [32, 33, 35, 34, 33, 38],
                                            title:"Hot Leads"
                                        }
                                        ,
                                       {
                                           fillColor: "rgba(198,130,132,0.5)",
                                           strokeColor: "rgba(198,130,132,1)",
                                           pointColor: "rgba(198,130,132,1)",
                                           pointStrokeColor: "#fff",
                                           pointHighlightFill: "#fff",
                                           pointHighlightStroke: "rgba(198,130,132,1)",
                                           data: [20, 40, 60, 80, 90, 100],
                                           title: "Follow Ups "
                                       }
                                    ],
                                    
                                }
                                
                                function legend(parent, data) {
                                    parent.className = 'legend';
                                    var datas = data.hasOwnProperty('datasets') ? data.datasets : data;

                                    // remove possible children of the parent
                                    while (parent.hasChildNodes()) {
                                        parent.removeChild(parent.lastChild);
                                    }

                                    datas.forEach(function (d) {
                                        var title = document.createElement('span');
                                        title.className = 'title';
                                        title.style.borderColor = d.hasOwnProperty('strokeColor') ? d.strokeColor : d.color;
                                        title.style.borderStyle = 'solid';
                                        parent.appendChild(title);

                                        var text = document.createTextNode(d.title);
                                        title.appendChild(text);
                                    });
                                }

                                var myLine = new Chart(document.getElementById("canvas").getContext("2d")).Line(lineChartData, {
                                    bezierCurve: false,
                                    datasetFill: false,
                                    pointDotRadius: 6,                                 
                                    //legendTemplate: "<ul><li><span style=\"background-color:red\">111222</span></li><li><span style=\"background-color:red\">111222</span></li><li><span style=\"background-color:red\">111222</span></li></ul>"
                                    showTooltip: true,
                                    tooltipTemplate: "<span>tooltips</span>"
                                });
                                legend(document.getElementById("lineLegend"), lineChartData);
                            </script>
                        </div>

                    </div>
                </div>
                <%-----end chart ui-----%>
                <%--report UI--%>
                <div style="margin-top: 55px">
                    <%--tool head--%>
                    <div style="margin-left: 40px; margin-right: 40px; width: 960px; height: 370px">
                        <%--head--%>
                        <div style="font-size: 30px" class="clearfix">
                            <span style="color: #234b60; font-weight: 900">Customized Report&nbsp;&nbsp;&nbsp;</span>
                            <i class="fa fa-question-circle tooltip-examples" style="color: #999ca1" title="Drag and drop items from the pane on the right side to view the customized report."></i>
                            <div style="float: right; padding-right: 40px; font-size: 18px;">
                                <i class="fa fa-print  report_head_button report_head_button_padding"></i>
                                <i class="fa fa-save report_head_button report_head_button_padding"></i>
                                <i class="fa fa-exchange  report_head_button"></i>
                            </div>
                        </div>
                        <%--grid view--%>
                        <div style="height: 260px; width: 100%; margin-top: 35px; padding-right: 40px; overflow-x: auto;" id="custom_report_grid">
                            <table class="table table-condensed" style="width: 900px;margin-bottom: 0px;" id="custom_report_table_head">

                             </table>
                             <div style="height: 230px; /*background: blue; */" id="droppable" class="custom_report_table">
                                
                                <table class="table table-condensed" style="width: 900px" id="custom_report_table">
                                  <%--  <thead>
                                        <tr>
                                            <th class="report_head">Property</th>
                                            <th class="report_head">Date</th>
                                            <th class="report_head">Call ATPT</th>
                                            <th class="report_head">Doorknk ATPT</th>
                                            <th class="report_head">Comment</th>
                                            <th class="report_head">Data</th>
                                            <th class="report_head">&nbsp;</th>
                                        </tr>
                                    </thead>--%>
                                    <tbody id="custom_report_tbody">
                                        <%-- <tr>
                                            <td class="report_content" style="font-weight: 900; width: 230px;">123 Main St, Brooklyn, NY 12345</td>
                                            <td class="report_content" style="width: 90px">4/23/2014</td>
                                            <td class="report_content" style="width: 90px">12</td>
                                            <td class="report_content" style="width: 100px">3</td>
                                            <td class="report_content" style="width: 260px">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras at porta justo, vitae ultrices orci.</td>
                                            <td class="report_content" style="width: 125px">3</td>
                                            <td class="report_content" ><i class="fa fa-list-alt report_gird_icon" onclick="custome_report_itemlick(1)"></i></td>
                                        </tr>--%>
                                    </tbody>
                                </table>
                                <script>
                                    $(document).ready(function () {

                                        $(".tooltip-examples").tooltip({
                                            placement: 'bottom'
                                        });
                                    });
                                    $(function () {

                                        $(".draggable_field").draggable({ revert: "invalid" });
                                        $("#droppable").droppable({
                                            drop: function (event, ui) {
                                                var draggable = ui.draggable;
                                                var fild = draggable.children("span").text()

                                                window.report_fileds = window.report_fileds ? window.report_fileds : $.parseJSON('<%= report_fields() %>');
                                                window.report_fileds.push(fild);

                                                //alert('The square with ID "' + fild + '" was dropped onto me!');
                                                $("#" + draggable.attr('id')).remove();
                                                $('#custom_report_table tr').remove();
                                                change_table_thead();
                                                show_report_data();
                                            }
                                        });
                                    });

                                    var custome_report_itemlick = function (index) {
                                        //alert(index);
                                        //window.external.custome_report_itemlick(index);

                                        $.ajax({
                                            type: "POST",
                                            url: "AngentOverview.aspx?index=" + index,
                                            data: "{}",
                                            contentType: "application/json; charset=utf-8",
                                            dataType: "json",
                                            success: function (msg) {
                                                // Do something interesting here.
                                            }
                                        });
                                    }
                                    function change_table_thead()
                                    {
                                        $('#custom_report_table_head thead').remove();
                                        $('#custom_report_table thead').remove();
                                        $('#custom_report_table tbody').remove();

                                        var report_fileds = window.report_fileds ? window.report_fileds : $.parseJSON('<%= report_fields() %>');
                                         var headstr = "";
                                         var feilds_style = {
                                             property: "font-weight: 900; width: 230px",
                                             date: "width: 90px",
                                             call_atpt: "width: 90px",
                                             doorknk_atpt: "width: 100px",
                                             Comment: "width: 260px",
                                             data: "width: 125px"
                                         }
                                         headstr += '<thead>  <tr>';
                                         for (var i in report_fileds) {
                                             //&nbsp;
                                             var title = report_fileds[i].toString().replace("_", " ");
                                             headstr += '<th class="report_head" >' + report_fileds[i].toString().replace("_", " "); + '</th>';
                                         }
                                         headstr += '</tr></thead>';

                                         $('#custom_report_table_head').append(headstr);
                                         $('#custom_report_table').append(' <tbody id="custom_report_tbody">\n</tbody>');
                                    }
                                   
                                    function show_report_data() {
                                        var report_data = $.parseJSON('<%= report_data %>');
                                       
                                        for (var i in report_data) {
                                            var data = report_data[i];
                                            var feilds_style = {
                                                property: "font-weight: 900; width: 230px",
                                                date: "width: 90px",
                                                call_atpt: "width: 90px",
                                                doorknk_atpt: "width: 100px",
                                                Comment: "width: 260px",
                                                data: "width: 125px"
                                            }
                                            var report_fileds = window.report_fileds ? window.report_fileds : $.parseJSON('<%= report_fields() %>');
                                            var table_cell = "";
                                            for (var j = 0; j < report_fileds.length;j++)
                                            {
                                                var fileds = report_fileds[j]
                                                table_cell += '<td class="report_content" style="' + feilds_style[fileds] + ';">' + data[fileds] + '</td>\n'
                                            }
                                           // <td class="report_content" style="font-weight: 900; width: 230px;">' + data.property + '</td>\
                                           //<td class="report_content" style="width: 90px">' + data.date + '</td>\
                                           //<td class="report_content" style="width: 90px">' + data.call_atpt + '</td>\
                                           //<td class="report_content" style="width: 100px">' + data.doorknk_atpt + '</td>\
                                           //<td class="report_content" style="width: 260px">' + data.commet + '</td>\
                                           //<td class="report_content" style="width: 125px">' + data.data + '</td>\
                                            $('#custom_report_table').append('<tr>\
                                            '+table_cell+'\
                                            <td class="report_content" style=""><i class="fa fa-list-alt report_gird_icon" style="float:right;" onclick="custome_report_itemlick(' + i + ')"></i></td>/n\
                                            <tr>\
                                            ');
                                        }
                                    }
                                    change_table_thead();
                                    show_report_data();

                                </script>
                            </div>

                        </div>

                    </div>
                </div>
            </div>

            <%--right panel--%>
            <div style="width: 310px; background: #f5f5f5" class="agent_layout_float">
                <%--head--%>
                <div style="margin-left: 30px; margin-top: 30px; margin-right: 20px; font-size: 24px; float: none">
                    <span style="color: #234b60">Custom Fields</span><i class="fa fa-question-circle tooltip-examples" title="Drag and drop items from the pane on the right side to view the customized report." style="color: #999ca1; float: right; margin-top: 3px"></i>
                    <div style="margin-top: 25px">
                        <div class="draggable_field" id="draggable_field8">
                            <i class="fa fa-long-arrow-left draggable_icon"></i>
                            <span class="drappable_field_text">Call Attemps</span>
                        </div>
                        <div class="draggable_field draggable_field_margin" id="draggable_field0">
                            <i class="fa fa-long-arrow-left draggable_icon "></i>
                            <span class="drappable_field_text">Door Knock</span>
                        </div>
                        <div class="draggable_field draggable_field_margin" id="draggable_field">
                            <i class="fa fa-long-arrow-left draggable_icon "></i>
                            <span class="drappable_field_text">Attempts</span>
                        </div>
                        <div class="draggable_field draggable_field_margin" id="draggable_field1">
                            <i class="fa fa-long-arrow-left draggable_icon "></i>
                            <span class="drappable_field_text">Most Recent</span>
                        </div>
                        <div class="draggable_field draggable_field_margin" id="draggable_field2">
                            <i class="fa fa-long-arrow-left draggable_icon "></i>
                            <span class="drappable_field_text">Comment</span>
                        </div>
                        <div class="draggable_field draggable_field_margin" id="draggable_field3">
                            <i class="fa fa-long-arrow-left draggable_icon "></i>
                            <span class="drappable_field_text">FAR</span>
                        </div>
                        <div class="draggable_field draggable_field_margin" id="draggable_field4">
                            <i class="fa fa-long-arrow-left draggable_icon "></i>
                            <span class="drappable_field_text">Data</span>
                        </div>

                    </div>

                </div>

            </div>
        </div>
    </form>

    <!-- custom scrollbar plugin -->

    <script src="../scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
    <script>
        (function ($) {
            $(window).load(function () {

                $(".custom_report_table").mCustomScrollbar(
                    {
                        theme: "minimal-dark"
                    }
                    );
            });
        })(jQuery);
    </script>
    <%-----------end-------%>
</body>
</html>
