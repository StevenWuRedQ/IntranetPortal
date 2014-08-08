<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AgentOverview.aspx.vb" Inherits="IntranetPortal.AgentOverview" %>

<%@ Register Src="~/AgentOverview/AgentCharts.ascx" TagPrefix="uc1" TagName="AgentCharts" %>


<%--<%@ Register Assembly="DevExtreme.WebForms.v14.1, Version=14.1.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExtreme.WebForms" TagPrefix="devextreme" %>--%>


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
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <script src="https://netdna.bootstrapcdn.com/twitter-bootstrap/2.0.4/js/bootstrap-tooltip.js"></script>

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
        var empId = '<%# CurrentEmployee.EmployeeID %>';
        
        function SearchNames(inputBox) {
            var key = inputBox.value;
            //alert(key);
            if (key == "")
                gridEmpsClient.ClearFilter();
            else {
                var filterCondition = "[Name] LIKE '%" + key + "%'";
                gridEmpsClient.ApplyFilter(filterCondition);
            }
        }

        var postponedCallbackRequired = false;
        //function is called on changing focused row
        function OnGridFocusedRowChanged() {
            if (gridEmpsClient.GetFocusedRowIndex() >= 0) {
                if (ContentCallbackPanel.InCallback()) {
                    postponedCallbackRequired = true;
                }
                else {
                    DoCallback();
                }
            }
        }

        function OnEndCallback(s, e) {
            if (postponedCallbackRequired) {
                DoCallback();
                postponedCallbackRequired = false;
            }

            //Show chart
            if (empId != null)
                LoadEmployeeBarChart(empId);
        }
        function onGetAgentLogButtonClick()
        {
            if (empId != null)
            {
              
                LoadAngentTodayReport(empId);
            }else
            {
                alert('EmpId is null');
            }
            
        }
        function onGetAgentZoningDateClick()
        {
            if (empId != null)
            {
                alert(empId);
                AgentZoningData(empId)
            }else {
                alert('EmpId is null');
            }
          
        }
        function DoCallback() {
            var rowKey = gridEmpsClient.GetRowKey(gridEmpsClient.GetFocusedRowIndex());
            if (rowKey != null)
            {
                ContentCallbackPanel.PerformCallback("EMP|" + rowKey);
                empId = rowKey;
            }
        }

        function Savelayout(reportName) {
            callbackPnlTemplatesClient.PerformCallback("AddReport|" + reportName);
        }
        function LoadLayout(reportName) {
            gridReportClient.PerformCallback("LoadLayout|" + reportName);
        }
        function RemoveReport(reportName) {
            callbackPnlTemplatesClient.PerformCallback("RemoveReport|" + reportName);
        }
       
        function ShowLeadstatus(status)
        {
            gridReportClient.PerformCallback("BindStatus|" + status);
            //ContentCallbackPanel.PerformCallback("Status|" + status)
            LoadStatusBarChart(status);
        }

    </script>
</head>
<body style="font: 12px 'Source Sans Pro'" id="test">
    <form id="form1" runat="server">
        <%--test drag--%>
        <%--<div id="draggable_field2">drap</div>--%>
        <%--angent overview ui--%>
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" FullscreenMode="true">
            <Styles>
                <Pane Paddings-Padding="0">
                    <Paddings Padding="0px"></Paddings>
                </Pane>
                <Separator BackColor=" #e7e9ee"></Separator>
            </Styles>
            <Panes>
                <dx:SplitterPane Size="310px" MinSize="180px" ShowCollapseBackwardButton="True">
                    <ContentCollection>
                        <dx:SplitterContentControl runat="server">
                            <%--top block--%>
                            <div style="height: 459px; border-bottom: 1px solid #dde0e7">
                                <div style="margin: 30px 20px 30px 30px">
                                    <div style="font-size: 24px;">
                                        <i class="fa fa-group with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Employees</span>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="fa fa-sort-amount-desc"></i>
                                    </div>
                                    <input type="text" data-var="@btn-info-color" class="form-control" style="width: 250px; margin-top: 25px; height: 30px; color: #b1b2b7" placeholder="Type employee’s name" onchange="SearchNames(this)" />
                                    <div style="margin-top: 27px; height: 290px; overflow-y: scroll" id="employees_grid">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridEmps" KeyFieldName="EmployeeID" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" ClientInstanceName="gridEmpsClient" CssClass="font_source_sans_pro">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="Name" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <Settings AllowHeaderFilter="False"></Settings>
                                                    <DataItemTemplate>
                                                        <div class="employee_list_item clearfix">
                                                            <div class="employee_list_item_div">
                                                                <span class="font_black"><%# Eval("Name")%></span><br />
                                                                <%# Eval("Position")%>
                                                            </div>
                                                            <i class="fa fa-list-alt employee_list_item_icon"></i>
                                                        </div>

                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <%--why use tr td?--%>
                                                <%-- <dx:GridViewDataColumn FieldName="Position" Visible="false"></dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn Width="25px" VisibleIndex="5">
                                                    <DataItemTemplate>
                                                        <i class="fa fa-list-alt employee_list_item_icon"></i>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>--%>
                                            </Columns>
                                            <Styles > 
                                                    <SelectedRow BackColor="#FF400D"></SelectedRow>
                                                    <Cell>
                                                    <Paddings Padding="0px"></Paddings>
                                                    </Cell>
                                            </Styles>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" AllowFocusedRow="true" AllowClientEventsOnLoad="false" />
                                            <SettingsPager Mode="ShowAllRecords">
                                            </SettingsPager>
                                            <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />

                                            <Settings ShowColumnHeaders="False" GridLines="None"></Settings>

                                            <Border BorderStyle="None"></Border>
                                        </dx:ASPxGridView>
                                      
                                    </div>
                                    <div style="margin-top: 27px; height: 290px; display: none /*background: blue*/">
                                        <div>
                                            <span class="font_black">A</span>&nbsp;&nbsp;&nbsp;<span class="employee_lest_head_number_label">2</span>
                                        </div>
                                        <ul style="margin-left: -35px; margin-top: 10px;">
                                            <li class="employee_list_item">
                                                <div class="employee_list_item_div">
                                                    <span class="font_black">Alko Kone</span><br />
                                                    Eviction
                                                </div>

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
                                    <div class="agent_menu_list_item" onclick="ShowLeadstatus(1)">Hot Leads</div>
                                    <div class="agent_menu_list_item" onclick="ShowLeadstatus(3)">Follow Up</div>
                                    <div class="agent_menu_list_item" onclick="ShowLeadstatus(5)">In Negotiation</div>
                                    <div class="agent_menu_list_item" onclick="ShowLeadstatus(4)">Dead Lead </div>
                                    <div class="agent_menu_list_item" onclick="ShowLeadstatus(7)">Closed</div>
                                </div>

                                <%-----end-----%>
                            </div>
                            <%----end bottom block--%>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane>
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <dx:ASPxCallbackPanel runat="server" ID="contentCallback" ClientInstanceName="ContentCallbackPanel" OnCallback="contentCallback_Callback" Width="100%" Height="100%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxSplitter runat="server" ID="contentSplitter" Orientation="Vertical" Width="100%" Height="100%">
                                            <Styles>
                                                <Pane Paddings-Padding="0">
                                                    <Paddings Padding="0px"></Paddings>
                                                </Pane>
                                                <Separator BackColor=" #e7e9ee"></Separator>
                                            </Styles>
                                            <Panes>
                                                <dx:SplitterPane ShowCollapseBackwardButton="True">
                                                    <ContentCollection>
                                                        <dx:SplitterContentControl runat="server">
                                                            <div style="width: 1272px;" class="agent_layout_float clear-fix">
                                                                <%--center top--%>
                                                                <div style="height: 490px; float: left; border-right: 1px solid #dde0e7;">
                                                                    <%--angent info--%>

                                                                    <div style="width: 370px; height: 490px; background: url('../images/profile_bg.png')">
                                                                        <%--width:201 height:201--%>
                                                                       
                                                                        <dx:ASPxImage runat="server" ID="profile_image" CssClass="img-circle class_profile_image" ImageUrl="/images/user-empty-icon.png">

                                                                        </dx:ASPxImage>
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
                                                                        <button class="btn btn-default" type="button" onclick="onGetAgentLogButtonClick()">Today's Log</button>
                                                                        
                                                                        <button class="btn btn-default" type="button" onclick="onGetAgentZoningDateClick()" style="margin-left:20px">Leads's Tax</button>
                                                                        <%-----end info detial-----%>
                                                                        <%-----end info detial-----%>
                                                                    </div>
                                                                
                                                                </div>

                                                                <dx:ASPxPopupControl ID="ASPxPopupControl2" runat="server" HeaderText="Select Photo" ClientInstanceName="selectImgs" Modal="true" Width="500px" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter">
                                                                    <ContentCollection>
                                                                        <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol2" runat="server">
                                                                        </dx:PopupControlContentControl>
                                                                    </ContentCollection>
                                                                </dx:ASPxPopupControl>

                                                                <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" HeaderText="Report Name" ClientInstanceName="SaveReportPopup" Modal="true" Width="500px" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter">
                                                                    <ContentCollection>
                                                                        <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol1" runat="server">
                                                                            <dx:ASPxTextBox runat="server" ID="txtReportName" ClientInstanceName="txtClientReportName"></dx:ASPxTextBox>
                                                                            <dx:ASPxButton runat="server" ID="btnSave" AutoPostBack="false" Text="Add">
                                                                                <ClientSideEvents Click="function(s, e){
                                                                SaveReportPopup.Hide();
                                                                Savelayout(txtClientReportName.GetText());
                                                                }" />
                                                                            </dx:ASPxButton>
                                                                        </dx:PopupControlContentControl>
                                                                    </ContentCollection>
                                                                </dx:ASPxPopupControl>
                                                                <%--chart UI--%>
                                                                <div style="height: 490px;" class="clearfix">

                                                                    <div style="padding-top: 50px; font-size: 30px; color: #ff400d; text-align: center; display: none">In the last 6 months</div>

                                                                    <div style="padding-left: 370px; padding-top: 10px; height: 325px;" class="clearfix">
                                                                        <div class="layout_float_right clearfix">

                                                                             <div class="dropdown layout_float_right" >
                                                                                <button class="btn btn-default dropdown-toggle" type="button" id="chart_line_select" data-toggle="dropdown" style="background:transparent">
                                                                                    Line & Point Chart <span class="caret"></span>
                                                                           
                                                                                </button>
                                                                                <ul class="dropdown-menu" role="menu" aria-labelledby="chart_line_select">
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Line</a></li>
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Bar</a></li>
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Pie</a></li>
                                                                                    
                                                                                </ul>
                                                                            </div>
                                                                            <div class="dropdown layout_float_right" style="margin-right:20px">
                                                                                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" style="background:transparent">
                                                                                    Change Stat Range <span class="caret"></span>
                                                                           
                                                                                </button>
                                                                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(this)">Chart of Last 6 months</a></li>
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(this)">Chart of Last 12 months</a></li>
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(this)">Chart of Last 1 year</a></li>
                                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(this)">Chart of Last 2 years</a></li>
                                                                                </ul>
                                                                            </div>

                                                                            
                                                                        </div>
                                                                        <div style="margin-left: 50px; margin-right: 50px; margin-bottom: 30px; /*background: blue; */ color: white; height: 100%;">
                                                                            <uc1:AgentCharts runat="server" ID="AgentCharts" />
                                                                            <canvas id="canvas" height="240" width="530" style="display: none"></canvas>
                                                                            <div id="lineLegend" style="display: none"></div>
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
                                                                                            title: "Door knock"
                                                                                        },
                                                                                        {
                                                                                            fillColor: "rgba(151,187,205,0.5)",
                                                                                            strokeColor: "rgba(151,187,205,1)",
                                                                                            pointColor: "rgba(151,187,205,1)",
                                                                                            pointStrokeColor: "#fff",
                                                                                            pointHighlightFill: "#fff",
                                                                                            pointHighlightStroke: "rgba(151,187,205,1)",
                                                                                            data: [32, 33, 35, 34, 33, 38],
                                                                                            title: "Hot Leads"
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

                                                                                function ShowChart() {
                                                                                    show_bar_chart();
                                                                                }

                                                                                //'ShowChart();
                                                                            </script>
                                                                        </div>

                                                                    </div>
                                                                </div>
                                                                <%-----end chart ui-----%>
                                                            </div>

                                                        </dx:SplitterContentControl>
                                                    </ContentCollection>
                                                </dx:SplitterPane>
                                                <dx:SplitterPane>
                                                    <ContentCollection>
                                                        <dx:SplitterContentControl runat="server">
                                                            <%--report UI--%>
                                                            <div style="margin-top: 10px;">
                                                                <%--tool head--%>
                                                                <div style="margin-left: 40px; margin-right: 40px;">
                                                                    <%--head--%>
                                                                    <div style="font-size: 30px" class="clearfix">
                                                                        <span style="color: #234b60; font-weight: 900">Customized Report&nbsp;&nbsp;&nbsp;</span>
                                                                        <i class="fa fa-question-circle tooltip-examples" style="color: #999ca1" title="Check items from the pane on the right side to view the customized report."></i>
                                                                        <div style="float: right; padding-right: 40px; font-size: 18px;">
                                                                            
                                                                            <i class="fa fa-save report_head_button report_head_button_padding" onclick="SaveReportPopup.Show()" style="cursor: pointer"></i>
                                                                            <i class="fa fa-exchange report_head_button tooltip-examples report_head_button_padding" title="Compare"></i>
                                                                            <asp:LinkButton ID="btnExport" runat="server" OnClick="Unnamed_ServerClick" Text='<i class="fa fa-print  report_head_button report_head_button_padding"></i>'>                                                                
                                                                            </asp:LinkButton>
                                                                            <i class="fa fa-envelope  report_head_button report_head_button_padding"></i>
                                                                            <i class="fa fa-file-pdf-o  report_head_button"></i>
                                                                            
                                                                        </div>
                                                                    </div>

                                                                    <%--grid view--%>

                                                                    <%--<div style="overflow-x:scroll;overflow-y:scroll;max-height:900px;">--%>
                                                                    <dx:ASPxGridView ID="gridReport" runat="server" KeyFieldName="BBLE" Width="100%" AutoGenerateColumns="false" ClientInstanceName="gridReportClient" OnCustomCallback="gridReport_CustomCallback" Settings-ShowGroupPanel="false" OnLoad="gridReport_Load" OnInit="gridReport_Init" CssClass="font_source_sans_pro"  Settings-VerticalScrollBarMode="Auto" > <%--Settings-HorizontalScrollBarMode="Auto"--%>
                                                                        <Settings ShowFilterBar="Visible" ShowHeaderFilterButton="true" ShowGroupPanel="true" />
                                                                        <Columns>
                                                                            <dx:GridViewDataColumn FieldName="PropertyAddress">
                                                                                    <CellStyle Font-Bold="True"></CellStyle>
                                                                            </dx:GridViewDataColumn>

                                                                        </Columns>
                                                                        <SettingsPager PageSize="10" PageSizeItemSettings-Visible="true" PageSizeItemSettings-ShowAllItem="true" Mode="ShowAllRecords">
                                                                            <PageSizeItemSettings ShowAllItem="True" Visible="True"></PageSizeItemSettings>
                                                                           
                                                                        </SettingsPager>
                                                                        <Settings  VerticalScrollableHeight="350"/>

                                                                        <GroupSummary>
                                                                            <dx:ASPxSummaryItem FieldName="BBLE" SummaryType="Count" />
                                                                        </GroupSummary>
                                                                        <Styles>
                                                                            <Cell >
                                                                                <BorderLeft BorderWidth="0px"></BorderLeft>

                                                                                <BorderRight BorderWidth="0px"></BorderRight>
                                                                            </Cell>
                                                                            <Table>
                                                                                
                                                                            </Table>
                                                                        </Styles>
                                                                    </dx:ASPxGridView>
                                                                    <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridReport"></dx:ASPxGridViewExporter>
                                                                    <%--</div>--%>


                                                                    <div style="height: 260px; width: 100%; margin-top: 35px; padding-right: 40px; overflow-x: auto; display: none" id="custom_report_grid">
                                                                        <table class="table table-condensed" style="width: 900px; margin-bottom: 0px;" id="custom_report_table_head">
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

                                                                                    if ($(".tooltip-examples").tooltip) {
                                                                                        $(".tooltip-examples").tooltip({
                                                                                            placement: 'bottom'
                                                                                        });
                                                                                    } else {
                                                                                        alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
                                                                                    }

                                                                                });
                                                                                $(function () {
                                                                                    if ($(".draggable_field").draggable) {
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
                                                                                    }

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
                                                                                function change_table_thead() {
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
                                                                                    var report_data = $.parseJSON('<%= report_data_f %>');

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
                                                                                        for (var j = 0; j < report_fileds.length; j++) {
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
                                            '+ table_cell + '\
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
                                                        </dx:SplitterContentControl>
                                                    </ContentCollection>
                                                </dx:SplitterPane>
                                            </Panes>
                                        </dx:ASPxSplitter>
                                        <asp:HiddenField runat="server" ID="hfEmpName" />
                                                         <asp:HiddenField runat="server" ID="hfMode" />

                                        <dx:ASPxHiddenField runat="server" ID="hfReports"></dx:ASPxHiddenField>
                                    </dx:PanelContent>
                                </PanelCollection>
                                <ClientSideEvents EndCallback="OnEndCallback" />
                            </dx:ASPxCallbackPanel>

                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane Size="310px" ShowCollapseForwardButton="True" CollapsedStyle-CssClass="clearfix">
                    <CollapsedStyle CssClass="clearfix"></CollapsedStyle>
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <div style="width: 310px; background: #f5f5f5" class="agent_layout_float">
                                <div style="margin-left: 30px; margin-top: 30px; margin-right: 20px; font-size: 24px; float: none;">
                                    <div style="height: 460px" class="border_under_line">
                                        <div style="padding-bottom: 20px;" class="border_under_line">
                                            <span style="color: #234b60">Saved Reports</span>
                                            <i class="fa fa-question-circle tooltip-examples" title="Select item view the customized report." style="color: #999ca1; float: right; margin-top: 3px"></i>

                                        </div>

                                        <dx:ASPxCallbackPanel runat="server" ID="callbackPnlTemplates" ClientInstanceName="callbackPnlTemplatesClient" OnCallback="callbackPnlTemplates_Callback">
                                            <PanelCollection>
                                                <dx:PanelContent>
                                                    <% If Not GetTemplates() Is Nothing Then%>
                                                    <ul class="list-group" style="font-size: 14px; box-shadow: none">

                                                        <% For Each key In GetTemplates().Keys%>
                                                        <li class="list-group-item color_gray" style="background-color: transparent; border: 0px;">
                                                            <i class="fa fa-file-o" style="font-size: 18px"></i>
                                                            <span class="drappable_field_text" onclick='LoadLayout(this.innerHTML)' style="cursor: pointer; width: 140px;"><% = key%></span>
                                                            <button type="button" value="delete" onclick='RemoveReport("<%= key %>")'>Delete</button>
                                                        </li>
                                                        <% Next%>
                                                    </ul>
                                                    <% Else%>
                                                    No template saved.
                                                    <% End If%>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxCallbackPanel>

                                    </div>
                                    <div style="height: 450px;">

                                        <div style="padding-top: 19px; padding-bottom: 14px;" class="border_under_line">
                                            <span style="color: #234b60">Custom Fields</span>
                                            <i class="fa fa-question-circle tooltip-examples" title="Check items view the customized report." style="color: #999ca1; float: right; margin-top: 3px"></i>
                                        </div>

                                        <div style="margin-top: 20px; overflow: auto; height: 380px;" id="custom_fields_div">

                                            <script type="text/javascript">
                                                function Fields_ValueChanged(s, e) {
                                                    var values = filed_CheckBoxList1.GetSelectedValues() + ',' + filed_CheckBoxList2.GetSelectedValues();
                                                    
                                                    gridReportClient.PerformCallback("FieldChange|" + values);
                                                    e.processOnServer = false;
                                                }
                                            </script>
                                            <div>
                                                <div class="color_gray upcase_text" style="font-size: 12px; padding-bottom: 10px;">Category 1</div>
                                                <dx:ASPxCheckBoxList ID="chkFields" runat="server" ValueType="System.String" Width="100%" ClientInstanceName="filed_CheckBoxList1">
                                                    <Items>

                                                        <dx:ListEditItem Text="Property Address" Value="PropertyAddress" Selected="true" />
                                                        <dx:ListEditItem Text="Call Attemps" Value="CallAttemps" />
                                                        <dx:ListEditItem Text="Doorknock Attemps" Value="DoorKnockAttemps" />

                                                        <dx:ListEditItem Text="Create Date" Value="CreateDate" />
                                                    </Items>

                                                    <%--<CheckBoxStyle  BackgroundImage-ImageUrl="../images/icon_checked_box.png"/>--%>
                                                    <%--<CheckedImage Url="../images/icon_checked_box.png"></CheckedImage>--%>
                                                    <ClientSideEvents SelectedIndexChanged="Fields_ValueChanged" />
                                                </dx:ASPxCheckBoxList>
                                            </div>
                                            <div>
                                                <div class="color_gray upcase_text" style="font-size: 12px; padding-bottom: 10px; padding-top: 20px">Category 2</div>
                                                <dx:ASPxCheckBoxList ID="chkFields2" runat="server" ValueType="System.String" Width="100%" ClientInstanceName="filed_CheckBoxList2">
                                                    <Items>
                                                        <dx:ListEditItem Text="BBLE" Value="BBLE" Selected="true" />

                                                        <dx:ListEditItem Text="Status" Value="Status" />
                                                        <dx:ListEditItem Text="Sale Date" Value="SaleDate" />
                                                        <dx:ListEditItem Text="Tax Class" Value="TaxClass" />
                                                        <dx:ListEditItem Text="Block" Value="Block" />
                                                        <dx:ListEditItem Text="Lot" Value="Lot" />
                                                        <dx:ListEditItem Text="Year Build" Value="YearBuilt" />
                                                        <dx:ListEditItem Text="# of floor" Value="NumFloors" />
                                                        <dx:ListEditItem Text="Building Dem" Value="BuildingDem" />
                                                        <dx:ListEditItem Text="Lot Dem" Value="LotDem" />
                                                        <dx:ListEditItem Text="Est Value" Value="EstValue" />
                                                        <dx:ListEditItem Text="Zoning" Value="Zoning" />
                                                        <dx:ListEditItem Text="MaxFar" Value="MaxFar" />
                                                        <dx:ListEditItem Text="Actual Far" Value="ActualFar" />
                                                        <dx:ListEditItem Text="NYCSqft" Value="NYCSqft" />
                                                        <dx:ListEditItem Text="Unbuilt Sqft" Value="UnbuiltSqft" />

                                                    </Items>

                                                    <%--<CheckBoxStyle  BackgroundImage-ImageUrl="../images/icon_checked_box.png"/>--%>
                                                    <%--<CheckedImage Url="../images/icon_checked_box.png"></CheckedImage>--%>
                                                    <ClientSideEvents SelectedIndexChanged="Fields_ValueChanged" />
                                                </dx:ASPxCheckBoxList>
                                            </div>
                                            <div style="display: none">


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
                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>

        <div style="width: 1630px; height: 960px">

            <%--left div--%>
            <div style="width: 310px; color: #999ca1;" class="agent_layout_float">
            </div>

            <%--splite bar--%>
            <div class="agent_layout_float" style="background: #e7e9ee; width: 10px;"></div>

            <%--center containter--%>
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
                $('#employees_grid').mCustomScrollbar(
                    {
                        theme: "minimal-dark"
                    }
                );

                $('#custom_fields_div').mCustomScrollbar(
                    {
                        theme: "minimal-dark"
                    }
                );

                $('.dxgvCSD').mCustomScrollbar(
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
