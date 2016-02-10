<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Management.aspx.vb" Inherits="IntranetPortal.ManagementUI" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.common.css" />
    <link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/15.1.6/css/dx.light.css" />
    <style>
        .nofoucs:focus {
            border: none !important;
        }
    </style>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script src="/bower_components/globalize/lib/globalize.js"></script>
    <script src="http://cdn3.devexpress.com/jslib/15.1.6/js/dx.chartjs.js"></script>
    <script src="http://cdn3.devexpress.com/jslib/15.1.6/js/dx.webappjs.js"></script>
    <div class="container-fluid">
        <%--Head--%>
        <div style="padding-top: 30px">
            <div style="font-size: 48px; color: #234b60">
                <div class="row">
                    <div class="col-md-4 ">
                        <div class="border_right" style="padding-right: 0px; font-weight: 300;">
                            <table>
                                <tr>
                                    <td id="tdReportTitle"><i class="fa fa-users mag_tabv_i"></i>Agent Activity
                                    </td>
                                    <td>
                                        <%--<i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;" ></i>--%>
                                        <div id="reportType" class="nofoucs" style="margin-left: 10px; background: white; border: none; box-shadow: none" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <table>
                            <tr>
                                <td>
                                    <span style="font-size: 30px" id="teams_link">Queens Team</span>
                                </td>
                                <td>
                                    <%--<i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;" ></i>--%>
                                    <div id="dropDownMenu" class="nofoucs" style="margin-left: 10px; background: white; border: none; box-shadow: none" />
                                </td>
                            </tr>
                        </table>
                        <%--<i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;" ></i>--%>
                    </div>
                    <div class="col-md-6">
                        <div>
                            <div style="display: inline-block">
                                <span class="magement_font">Total agents</span>
                                <span class="magement_font magement_number" id="total_agent_count">23</span>
                            </div>
                            <div style="display: inline-block; margin-left: 20px">
                                <span class="magement_font">total deals within last 30 days</span>
                                <span class="magement_font magement_number" id="total_deal_count">241</span>
                            </div>
                            <div style="display: inline-block">
                                <span class="magement_number management_score">
                                    <span class="management_molecular ">87</span> <span class="management_denominator">/100</span>
                                </span>
                            </div>
                            <div style="display: inline-block" class="management_text">
                                <span>Effeciency Score</span><br />
                                <span>This Month</span>
                            </div>
                            <i class="fa fa-search-plus management_search_icon" style="margin-left: 10px;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div style="margin-top: 40px;">
            <%--body Left--%>
            <%--<div class="row" style="display:none">
                <div class="col-md-7">
                    <div role="tabpanel" class="mag_tab_panel">

                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active mag_tab"><a class="mag_tab_text" href="#phone_callsTab" aria-controls="phone_callsTab" role="tab" data-toggle="tab"><i class="fa fa-phone"></i>
                                <br />
                                Phone Calls</a></li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#geomap" aria-controls="profile" role="tab" data-toggle="tab">
                                <i class="fa fa-map-marker"></i>
                                <br />
                                Geo map</a>

                            </li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#profile" aria-controls="profile" role="tab" data-toggle="tab">
                                <i class="fa fa-sign-in"></i>
                                <br />
                                Door Knocks</a>

                            </li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#deals_tab" aria-controls="deals_tab" role="tab" data-toggle="tab"><i class="fa fa-check-circle"></i>
                                <br />
                                Deals</a></li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#messages" aria-controls="messages" role="tab" data-toggle="tab"><i class="fa fa-crosshairs"></i>
                                <br />
                                HR Analytics</a></li>

                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" style="padding: 30px;">
                            <div role="tabpanel" class="tab-pane active" id="phone_callsTab">
                                <div class="mag_tab_input_group">

                                    <div class="row">
                                        <div class="col-md-3">
                                            <select class="form-control">
                                                <option>Last Month</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-control" id="selAgents">
                                                <option>All Agents</option>
                                                <option>Agents 1</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1">
                                            <input type="button" value="Display" class="rand-button bg_color_blue rand-button-padding" onclick="LoadGrid()" />
                                        </div>
                                        <div class="col-md-1">
                                            <input type="button" value="Chart" class="rand-button bg_color_blue rand-button-padding" onclick="LoadPhoneBarChart()" />

                                        </div>
                                    </div>
                                </div>
                                <div style="margin: 30px 0; font-size: 24px; color: #234b60; display: none" id="divPhoneSummary">
                                    <span style="font-weight: 900" id="CallTotalCount">52,013 </span>Phone Calls<br />
                                    <span style="font-size: 14px; color: #77787b">January 1, 2015 - January 31, 2015</span>
                                </div>
                                <div style="font-size: 14px;">
                                    <div id="chartContainer" style="height: 450px; max-width: 1000px; width: 100%; margin: 0 auto; display: none"></div>
                                    <div id="gridContainer" style="height: 450px; max-width: 1000px; width: 100%; margin: 0 auto; display: none"></div>
                                </div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="profile">...</div>
                            <div role="tabpanel" class="tab-pane" id="geomap">
                                <iframe src="/Map/ZipMap.aspx" style="width: 100%; min-height: 600px"></iframe>
                            </div>

                            <div role="tabpanel" class="tab-pane" id="deals_tab">deals_tab</div>
                            <div role="tabpanel" class="tab-pane" id="messages">...</div>

                        </div>

                    </div>
                </div>
                <div class="col-md-5">
                    <div style="padding-left: 10px">
                        <div>
                            <i class="fa fa-pie-chart report_head_button report_head_button_padding tooltip-examples"></i><span class="font_black">Status Of Leads</span>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div id="container" class="containers" style="height: 250px; width: 100%;"></div>
                                    <div class="chart_text">
                                        In Process Leads: <span id="InProcessCount" class="font_black">0</span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div id="current_leads" class="containers" style="height: 250px; width: 100%;"></div>
                                    <div class="chart_text">
                                        Current Leads: <span id="spanTotalLeads" class="font_black">0</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div style="margin: 30px 0;">
                            <i class="fa fa-bar-chart report_head_button report_head_button_padding tooltip-examples"></i><span class="font_black">Monthly Leads Process</span>
                        </div>
                        <div>
                            <div id="leads_process_chart" class="containers" style="height: 250px; width: 100%;"></div>
                        </div>
                        <div style="margin: 30px 0;">
                            <i class="fa fa-line-chart report_head_button report_head_button_padding tooltip-examples"></i><span class="font_black">Compare Offices</span>
                        </div>
                        <div>
                            <div id="compare_offices_chart" class="containers" style="height: 200px; width: 100%;"></div>
                        </div>
                    </div>
                </div>
            </div>--%>
            <%-- New layout --%>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-2" style="display: none">
                        <ul class="nav nav-tabs nav-stacked color_gray" role="tablist" id="mytab">
                            <li role="presentation" class="mag_tabv"><a href="#Agent_Activity_Tab" onclick="agentActivityTab.ShowTab(currentTeamInfo.TeamName, true)" role="tab" data-toggle="tab"><i class="fa fa-users mag_tabv_i"></i>Agent Activity</a></li>
                            <li role="presentation" class="mag_tabv"><a href="#Status_Of_Leads_Tab" onclick="LeadsStatusTab.ShowTab(currentTeamInfo.TeamName, currentTeamInfo.Users, true)" role="tab" data-toggle="tab"><i class="fa fa-pie-chart mag_tabv_i"></i>Status Of Leads</a></li>
                            <li role="presentation" class="mag_tabv"><a href="#Team_Activity_Tab" onclick="" role="tab" data-toggle="tab"><i class="fa fa-pie-chart mag_tabv_i"></i>Team Activity</a></li>
                            <% If IntranetPortal.Employee.IsAdmin(Page.User.Identity.Name) Then%>
                            <li role="presentation" class="mag_tabv"><a href="#Geo_Leads_tab" role="tab" data-toggle="tab"><i class="fa fa-map-marker mag_tabv_i"></i>Geo Leads</a></li>
                            <%End If%>
                            <%--  <li role="presentation" class="mag_tabv"><a href="#" role="tab" data-toggle="tab"><i class="fa fa-bar-chart mag_tabv_i"></i>Monthly  Intake</a></li>
                            <li role="presentation" class="mag_tabv"><a href="#" role="tab" data-toggle="tab"><i class="fa fa-line-chart mag_tabv_i"></i>Compare Offices</a></li>
                            <li role="presentation" class="mag_tabv"><a href="#" role="tab" data-toggle="tab"><i class="fa fa-clock-o mag_tabv_i"></i>Team Hours</a></li>--%>
                        </ul>
                    </div>
                    <div class="col-md-12">
                        <div style="min-height: 900px">
                            <div class="tab-content" style="padding-right: 10px">
                                <div role="tabpanel" class="tab-pane active" id="Agent_Activity_Tab">
                                    <div class="mag_tab_input_group">
                                        <div class="row">
                                            <div id="dateRange" class="containers" style="width: 100%;"></div>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 10px">
                                        <div class="col-md-12">
                                            <div id="agentActivityChart" class="containers" style="height: 440px; width: 100%;"></div>
                                        </div>
                                        <div class="">
                                            <div id="agentDetailChart" class="containers" style="height: 440px; width: 100%;"></div>
                                        </div>
                                    </div>
                                    <div id="gridPopup" style="width: 700px">
                                        <div id="agentLeadsGrid" style="height: 450px; max-width: 700px; width: 100%; margin: 0 auto;"></div>
                                    </div>
                                    <script type="text/javascript">
                                        var agentActivityTab = {
                                            TeamName: null,
                                            CurrentAgentName: null,
                                            ActivityDataSource: null,
                                            Visible: function () { return $("#Agent_Activity_Tab").hasClass("active") ? true : false },
                                            BarChart: function () {
                                                if ($("#agentActivityChart").has("svg").length)
                                                    return $("#agentActivityChart").dxChart("instance");
                                                else {
                                                    var tab = this;
                                                    $("#agentActivityChart").dxChart({
                                                        dataSource: {},
                                                        commonSeriesSettings: {
                                                            argumentField: "Name",
                                                            type: "bar",
                                                            hoverMode: "allArgumentPoints",
                                                            selectionMode: "allArgumentPoints",
                                                            label: {
                                                                visible: true,
                                                                format: "fixedPoint",
                                                                precision: 0
                                                            }
                                                        },
                                                        argumentAxis: {
                                                            argumentType: 'string'
                                                        },
                                                        series: [
                                                            { valueField: "CallOwner", name: "CallOwner", tag: "CallOwner" },
                                                            { valueField: "Comments", name: "Comments", tag: "Comments" },
                                                            { valueField: "UniqueBBLE", name: "UniqueBBLE", tag: "UniqueBBLE" },
                                                            { valueField: "Appointment", name: "Appointment", tag: "Appointment" }
                                                        ],
                                                        title: "Agents Activities in " + tab.TeamName,
                                                        legend: {
                                                            verticalAlignment: "bottom",
                                                            horizontalAlignment: "center"
                                                        },
                                                        loadingIndicator: {
                                                            show: true
                                                        },
                                                        onPointClick: function (info) {
                                                            var clickedPoint = info.target;
                                                            clickedPoint.isSelected() ? clickedPoint.clearSelection() : clickedPoint.select();

                                                            if (clickedPoint.isSelected()) {
                                                                var name = clickedPoint.argument;
                                                                var agentdata = DevExpress.data.query(tab.ActivityDataSource.items()).filter("Name", "=", name).toArray();
                                                                var data = agentdata[0];

                                                                var datasource = [];
                                                                for (var key in data) {
                                                                    if (key != "Name" && key != "UniqueBBLE") {
                                                                        datasource.push({ name: key, count: data[key] });
                                                                    }
                                                                }
                                                                tab.UpdateAgentDetailChart(name, datasource);
                                                            }
                                                        },
                                                        onPointSelectionChanged: function (info) {
                                                            //var selectedPoint = info.target;
                                                            //if (selectedPoint.isSelected()) {

                                                            //}
                                                        },
                                                        onLegendClick: function (info) {
                                                            var valueArray = [];
                                                            var series = info.target;
                                                            var action = series.tag;
                                                            tab.ShowLeadsDataGrid("", action);
                                                        }
                                                    });
                                                    return $("#agentActivityChart").dxChart("instance");
                                                }
                                            },
                                            PieChart: $("#agentDetailChart").has("svg").length ? $("#agentDetailChart").dxPieChart('instance') : $("#agentDetailChart").dxPieChart({
                                                size: {
                                                    width: 500
                                                },
                                                dataSource: {},
                                                series: [
                                                    {
                                                        argumentField: "name",
                                                        valueField: "count",
                                                        label: {
                                                            visible: true,
                                                            connector: {
                                                                visible: true,
                                                                width: 1
                                                            }
                                                        }
                                                    }
                                                ],
                                                AgentName: null
                                            }).dxPieChart("instance"),
                                            UrlEncodeDate: function (date) {
                                                return date.toLocaleDateString().replace(/\//g, "-");
                                            },
                                            DateRange: function () { return $('#dateRange').has("svg").length ? $('#dateRange').dxRangeSelector('instance') : null },
                                            InitalTab: function () {
                                                var tab = this;
                                                var dateNow = new Date();
                                                var endDate = new Date();
                                                endDate = endDate.setDate(dateNow.getDate() + 1);
                                                var startDate = new Date(dateNow.getFullYear(), dateNow.getMonth(), 1);
                                                $("#dateRange").dxRangeSelector({
                                                    margin: {
                                                        top: 5
                                                    },
                                                    size: {
                                                        height: 150
                                                    },
                                                    scale: {
                                                        startValue: new Date(2014, 8, 28),
                                                        endValue: endDate,
                                                        minorTickInterval: "day",
                                                        majorTickInterval: 'week',
                                                        minRange: "day",
                                                        showMinorTicks: false
                                                    },
                                                    sliderMarker: {
                                                        format: "monthAndDay"
                                                    },
                                                    selectedRange: {
                                                        startValue: new Date(dateNow.getFullYear(), dateNow.getMonth(), 1),
                                                        endValue: endDate
                                                    },
                                                    onSelectedRangeChanged: function (e) {
                                                        tab.UpdateActivityChart(e.startValue, e.endValue);
                                                    }
                                                });
                                            },
                                            ShowTab: function (name, noCheck) {
                                                if (this.Visible() || noCheck) {
                                                    if (this.TeamName == name)
                                                        return;

                                                    this.TeamName = name;
                                                    var range = this.DateRange();
                                                    var selectedRange = range.getSelectedRange();
                                                    this.UpdateActivityChart(selectedRange.startValue, selectedRange.endValue);
                                                }
                                            },
                                            LoadAgentActivityDs: function (startDate, endDate) {
                                                this.ActivityDataSource = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LoadAgentActivity/" + this.TeamName + "/" + startDate.toLocaleDateString().replace(/\//g, "-") + "/" + endDate.toLocaleDateString().replace(/\//g, "-"));
                                            },
                                            LoadGridLeadsData: function (agentName, action) {
                                                var tab = this;
                                                var customStore = new DevExpress.data.CustomStore({
                                                    load: function (loadOptions) {
                                                        var d = $.Deferred();
                                                        var selectedRange = tab.DateRange().getSelectedRange();
                                                        var dataApi = agentName == "" ? "LoadTeamActivityLeads/" + tab.TeamName : "LoadAgentActivityLeads/" + agentName;
                                                        $.getJSON("/WCFDataServices/PortalReportService.svc/" + dataApi + "/" + action + "/" + tab.UrlEncodeDate(selectedRange.startValue) + "/" + tab.UrlEncodeDate(selectedRange.endValue)).done(function (data) {
                                                            d.resolve(data, { totalCount: data.length });
                                                        });
                                                        return d.promise();
                                                    }
                                                });

                                                return customStore;
                                            },
                                            ShowLeadsDataGrid: function (name, action) {
                                                var titleName = name == "" ? this.TeamName : name;
                                                $("#gridPopup").dxPopup({
                                                    showTitle: true,
                                                    title: titleName + ' - ' + action,
                                                    showCloseButton: true,
                                                    //titleTemplate: "<div>" + agentName + ' - ' + point.originalArgument + "</div>",                                                           
                                                    width: 700,
                                                    height: 550,
                                                    closeOnOutsideClick: false
                                                });
                                                $("#gridPopup").dxPopup("instance").show();

                                                $("#agentLeadsGrid").dxDataGrid({
                                                    dataSource: this.LoadGridLeadsData(name, action),
                                                    showColumnLines: false,
                                                    showRowLines: true,
                                                    rowAlternationEnabled: true,
                                                    paging: { enabled: false },
                                                    remoteOperations: {
                                                        sorting: false
                                                    },
                                                    columns: [{
                                                        dataField: "LeadsName",
                                                        caption: "Leads Name",
                                                        width: 280,
                                                        cellTemplate: function (container, options) {
                                                            if (options.value != null) {
                                                                var fieldHTML = '<a target="_blank" href="javascript:ViewLeadsInfo(\'' + options.data.BBLE + '\')">' + options.value + "</a>"
                                                                container.html(fieldHTML);
                                                            }
                                                        }
                                                    }, {
                                                        dataField: "BBLE",
                                                        caption: "BBLE",
                                                        width: 100
                                                    }, {
                                                        dataField: "EmployeeName",
                                                        caption: "Employee Name"
                                                    }, {
                                                        dataField: "LastUpdate",
                                                        caption: "Last Update",
                                                        dataType: 'date'
                                                    }],
                                                    summary: {
                                                        totalItems: [{
                                                            column: 'BBLE',
                                                            summaryType: 'count'
                                                        }]
                                                    }
                                                });
                                            },
                                            UpdateActivityChart: function (startDate, endDate) {
                                                var chart = this.BarChart();
                                                chart.showLoadingIndicator();
                                                chart.clearSelection();
                                                this.LoadAgentActivityDs(startDate, endDate);
                                                chart.beginUpdate();
                                                chart.option("dataSource", this.ActivityDataSource);
                                                chart.option("title", "Agents Activities in " + this.TeamName);

                                                if ($("#agentActivityChart").parent().hasClass("col-md-7")) {
                                                    $("#agentActivityChart").parent().removeClass("col-md-7");
                                                    $("#agentActivityChart").parent().addClass("col-md-12");
                                                    var width = $("#agentActivityChart").parent().width();
                                                    if (width == 100)
                                                        $("#agentActivityChart").width("100%");
                                                    else
                                                        $("#agentActivityChart").width(width);
                                                    chart.render();
                                                    $("#agentDetailChart").parent().hide();
                                                }

                                                chart.endUpdate();
                                                //chart.hideLoadingIndicator();
                                            },
                                            UpdateAgentDetailChart: function (agentName, agentData) {
                                                this.CurrentAgentName = agentName;
                                                if (!$("#agentActivityChart").parent().hasClass("col-md-7")) {
                                                    $("#agentActivityChart").parent().removeClass("col-md-12");
                                                    $("#agentActivityChart").parent().addClass("col-md-7");
                                                    var width = $("#agentActivityChart").parent().width();
                                                    $("#agentActivityChart").width(width);
                                                    this.BarChart().render();
                                                    $("#agentDetailChart").parent().addClass("col-md-5");
                                                    $("#agentDetailChart").parent().show();
                                                }
                                                var tab = this;
                                                this.PieChart.option({
                                                    dataSource: agentData,
                                                    title: agentName + " Actions",
                                                    AgentName: agentName,
                                                    onPointClick: function (e) {
                                                        var point = e.target;
                                                        tab.ShowLeadsDataGrid(agentName, point.originalArgument);
                                                        return;

                                                        ////point.isVisible() ? point.hide() : point.show();
                                                        //$("#gridPopup").dxPopup({
                                                        //    showTitle: true,
                                                        //    title: agentName + ' - ' + point.originalArgument,
                                                        //    showCloseButton: true,
                                                        //    //titleTemplate: "<div>" + agentName + ' - ' + point.originalArgument + "</div>",                                                           
                                                        //    width: 700,
                                                        //    height:550,
                                                        //    closeOnOutsideClick: true
                                                        //});
                                                        //$("#gridPopup").dxPopup("instance").show();

                                                        //var customStore = new DevExpress.data.CustomStore({
                                                        //    load: function (loadOptions) {
                                                        //        var d = $.Deferred();
                                                        //        var selectedRange = tab.DateRange().getSelectedRange();
                                                        //        $.getJSON("/WCFDataServices/PortalReportService.svc/LoadAgentActivityLeads/" + agentName + "/" + point.argument + "/" + tab.UrlEncodeDate(selectedRange.startValue) + "/" + tab.UrlEncodeDate(selectedRange.endValue)).done(function (data) {
                                                        //            d.resolve(data, { totalCount: data.length });
                                                        //        });
                                                        //        return d.promise();
                                                        //    }
                                                        //});

                                                        //$("#agentLeadsGrid").dxDataGrid({
                                                        //    dataSource: customStore,
                                                        //    showColumnLines: false,
                                                        //    showRowLines: true,
                                                        //    rowAlternationEnabled: true,
                                                        //    paging: { enabled: false },
                                                        //    columns: [{
                                                        //        dataField: "LeadsName",
                                                        //        caption: "Leads Name",
                                                        //        width: 280,
                                                        //        cellTemplate: function (container, options) {
                                                        //            if (options.value != null) {
                                                        //                var fieldHTML = '<a target="_blank" href="javascript:ViewLeadsInfo(\'' + options.data.BBLE + '\')">' + options.value + "</a>"
                                                        //                container.html(fieldHTML);
                                                        //            }
                                                        //        }
                                                        //    }, {
                                                        //        dataField: "BBLE",
                                                        //        caption: "BBLE",
                                                        //        width: 100
                                                        //    },{
                                                        //        dataField: "EmployeeName",
                                                        //        caption: "Employee Name"
                                                        //    }, {
                                                        //        dataField: "LastUpdate",
                                                        //        caption: "Last Update",
                                                        //        dataType: 'date'
                                                        //    }],
                                                        //    summary: {
                                                        //        totalItems: [{
                                                        //            column: 'BBLE',
                                                        //            summaryType: 'count'
                                                        //        }]
                                                        //    }
                                                        //});
                                                    }
                                                });
                                            }
                                        }

                                    </script>
                                </div>
                                <div role="tabpanel" class="tab-pane " id="Status_Of_Leads_Tab">
                                    <div class="mag_tab_input_group">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <label for="selAgents" style="float: left">Select Agents:&nbsp;</label>
                                                <select class="form-control" style="width: 200px; float: left; margin-left: 20px;" id="selAgents" name="selAgents">
                                                    <option>All Agents</option>
                                                    <option>Agents 1</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 10px">
                                        <div class="col-md-6">
                                            <div>
                                                <div class="chart_text">
                                                    <div id="ProcessStatusChart" class="containers" style="height: 500px; width: 60%; float: left"></div>
                                                    <div id="InProcessLeadsChart" class="containers" style="height: 300px; width: 39%; float: left"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div style="border-left: 1px solid #dde0e7;">
                                                <div style="padding: 10px 15px; font-weight: 300; color: #2e2f31">
                                                    <div>
                                                        <i class="fa fa-table report_head_button report_head_button_padding tooltip-examples"></i><span class="font_black" id="gridTitle">Leads Data</span>
                                                    </div>
                                                    <div id="gridLeads" style="height: 600px; max-width: 1000px; width: 100%; margin-top: 5px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <script type="text/javascript">
                                        var LeadsStatusTab = {
                                            DataView: {
                                                Agent: {
                                                    Name: null,
                                                    LeadsDataSource: null,
                                                    LeadsInProcessDataSource: null,
                                                    LoadDataSource: function () {
                                                        this.LeadsDataSource = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LoadAgentLeadsReport/" + this.Name);
                                                        this.LeadsInProcessDataSource = new DevExpress.data.DataSource("/WCFDataServices/PortalReportService.svc/LoadAgentInProcessReport/" + this.Name);
                                                    },
                                                    GetLeadsData: function (status) {
                                                        var view = this;
                                                        var customStore = new DevExpress.data.CustomStore({
                                                            load: function (loadOptions) {
                                                                var d = $.Deferred();
                                                                $.getJSON("/WCFDataServices/PortalReportService.svc/LoadAgentLeadsData/" + view.Name + "/" + status).done(function (data) {
                                                                    d.resolve(data, { totalCount: data.length });
                                                                });
                                                                return d.promise();
                                                            }
                                                        });
                                                        return customStore;
                                                    }
                                                },
                                                Team: {
                                                    Name: null,
                                                    TeamUsers: null,
                                                    LeadsDataSource: null,
                                                    LeadsInProcessDataSource: null,
                                                    LoadDataSource: function () {
                                                        this.LeadsDataSource = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LoadTeamLeadsReport/" + this.Name);
                                                        this.LeadsInProcessDataSource = new DevExpress.data.DataSource("/WCFDataServices/PortalReportService.svc/LoadTeamInProcessReport/" + this.Name);
                                                    },
                                                    GetLeadsData: function (status) {
                                                        var view = this;
                                                        var customStore = new DevExpress.data.CustomStore({
                                                            load: function (loadOptions) {
                                                                var d = $.Deferred();
                                                                $.getJSON("/WCFDataServices/PortalReportService.svc/LoadTeamLeadsData/" + view.Name + "/" + status).done(function (data) {
                                                                    d.resolve(data, { totalCount: data.length });
                                                                });
                                                                return d.promise();
                                                            }
                                                        });
                                                        return customStore;
                                                    }
                                                }
                                            },
                                            DisplayView: null,
                                            DataGridLeads: $("#gridLeads").dxDataGrid({
                                                showColumnLines: false,
                                                showRowLines: true,
                                                rowAlternationEnabled: true,
                                                paging: { enabled: false },
                                                remoteOperations: {
                                                    sorting: false
                                                },
                                                columns: [{
                                                    dataField: "LeadsName",
                                                    caption: "Leads Name",
                                                    width: 240,
                                                    cellTemplate: function (container, options) {
                                                        if (options.value != null) {
                                                            var fieldHTML = '<a target="_blank" href="javascript:ViewLeadsInfo(\'' + options.data.BBLE + '\')">' + options.value + "</a>"
                                                            container.html(fieldHTML);
                                                        }
                                                    }
                                                }, {
                                                    dataField: "BBLE",
                                                    caption: "BBLE",
                                                    width: 100
                                                }, {
                                                    dataField: "EmployeeName",
                                                    caption: "Employee Name",
                                                    visible: false
                                                }, {
                                                    dataField: "DeadReason",
                                                    caption: "Dead Reason",
                                                    visible: false
                                                }, {
                                                    dataField: "Description",
                                                    caption: "Description",
                                                    visible: false
                                                }, {
                                                    dataField: "Callback",
                                                    caption: "Callback",
                                                    dataType: 'date',
                                                    visible: false
                                                }, , {
                                                    dataField: "LastUpdate",
                                                    caption: "Last Update",
                                                    dataType: 'date',
                                                    visible: true
                                                }],
                                                summary: {
                                                    totalItems: [{
                                                        column: 'BBLE',
                                                        summaryType: 'count'
                                                    }]
                                                }
                                            }).dxDataGrid("instance"),
                                            Visible: function () { return $("#Status_Of_Leads_Tab").hasClass("active") ? true : false },
                                            AgentSelect: $("#selAgents"),
                                            InitAgentSelect: function () {
                                                if (this.DisplayView != null) {
                                                    var tab = this;
                                                    tab.AgentSelect.html("");
                                                    $.each(tab.DisplayView.TeamUsers, function (key, value) {
                                                        tab.AgentSelect.append(
                                                       $("<option></option>")
                                                        .attr("value", value)
                                                        .text(value));
                                                    });
                                                    tab.AgentSelect.prepend("<option value='' selected='selected'>All</option>");

                                                    tab.AgentSelect.change(function () {
                                                        var agent = tab.AgentSelect.val();
                                                        if (agent != "") {
                                                            tab.ShowAgentChart(agent);
                                                        }
                                                        else {
                                                            tab.DisplayView = tab.DataView.Team;
                                                            tab.LoadChart();
                                                        }
                                                    });
                                                }
                                            },
                                            ShowTab: function (teamName, users, noCheck) {
                                                if (this.Visible() || noCheck) {
                                                    this.DataView.Team.Name = teamName;
                                                    this.DataView.Team.TeamUsers = users;
                                                    this.DisplayView = this.DataView.Team;
                                                    this.InitAgentSelect();
                                                    this.LoadChart();
                                                }
                                            },
                                            ShowAgentChart: function (agentName) {
                                                this.DataView.Agent.Name = agentName;
                                                this.DisplayView = this.DataView.Agent;
                                                this.LoadChart();
                                            },
                                            LoadChart: function () {
                                                this.DisplayView.LoadDataSource();
                                                var tab = this;
                                                if (!$("#InProcessLeadsChart").has("svg").length) {
                                                    var option = {
                                                        dataSource: tab.DisplayView.LeadsInProcessDataSource,
                                                        tooltip: {
                                                            enabled: true,
                                                            percentPrecision: 2,
                                                            customizeText: function () {
                                                                return this.argumentText + " - " + this.percentText;
                                                            }
                                                        },
                                                        legend: {
                                                            visible: true,
                                                            verticalAlignment: "bottom",
                                                            horizontalAlignment: "center"
                                                        },
                                                        series: [{
                                                            type: "doughnut",
                                                            argumentField: "Status",
                                                            valueField: "Count",
                                                            tagField: "StatusKey",
                                                            label: {
                                                                visible: true,
                                                                connector: {
                                                                    visible: true
                                                                }
                                                            },
                                                        }],
                                                        title: "In Process Leads",
                                                        palette: ['#a5bcd7', '#e97c82', '#da5859', '#f09777', '#fbc986', '#a5d7d0', '#a5bcd7']
                                                    }

                                                    option.onDone = function (e) {
                                                        DevExpress.data.query(tab.DisplayView.LeadsInProcessDataSource.items()).sum("Count").done(function (result) {
                                                            //$("#InProcessCount").html(result);
                                                            e.component.option("title", "In Process Leads");
                                                        });
                                                    }
                                                    $("#InProcessLeadsChart").dxPieChart(option);

                                                    option.dataSource = tab.DisplayView.LeadsDataSource;
                                                    option.onDone = function (e) {
                                                        DevExpress.data.query(tab.DisplayView.LeadsDataSource.items()).sum("Count").done(function (result) {
                                                            e.component.option("title", tab.DisplayView.Name + " Leads: <b>" + result + "</b>");
                                                        });
                                                    };
                                                    option.onPointClick = function (e) {
                                                        var point = e.target;
                                                        tab.LoadGridLeads(point.tag);
                                                        $("#gridTitle").html(point.originalArgument);
                                                        //point.isVisible() ? point.hide() : point.show();
                                                    };
                                                    $("#ProcessStatusChart").dxPieChart(option);
                                                }
                                                else {
                                                    var chart = $("#InProcessLeadsChart").dxPieChart("instance");
                                                    chart.option("dataSource", tab.DisplayView.LeadsInProcessDataSource);
                                                    //chart.render({ force: true });

                                                    chart = $("#ProcessStatusChart").dxPieChart("instance");
                                                    chart.option("dataSource", tab.DisplayView.LeadsDataSource);
                                                    //chart.render({ force: true });
                                                }
                                            },
                                            GridCustomColumn: function () {
                                                var columns = {};
                                                columns["Visible"] = ["Callback", "DeadReason", "Description", "EmployeeName"];
                                                //Call back
                                                columns["3"] = ["Callback"];
                                                //Dead end
                                                columns["4"] = ["DeadReason", "Description"];

                                                return columns;
                                            },
                                            LoadGridLeads: function (statusKey) {
                                                var tab = this;

                                                this.DataGridLeads.beginUpdate();

                                                var visibleColumns = tab.GridCustomColumn()["Visible"];
                                                if (visibleColumns) {
                                                    for (var i = 0; i < visibleColumns.length; i++) {
                                                        this.DataGridLeads.columnOption(visibleColumns[i], "visible", false);
                                                    }
                                                }

                                                var columns = tab.GridCustomColumn()[statusKey];
                                                if (columns) {
                                                    for (var i = 0; i < columns.length; i++) {
                                                        this.DataGridLeads.columnOption(columns[i], "visible", true);
                                                    }
                                                } else {
                                                    this.DataGridLeads.columnOption("EmployeeName", "visible", true);
                                                    this.DataGridLeads.columnOption("LastUpdate", "visible", true);
                                                }

                                                var ds = tab.DisplayView.GetLeadsData(statusKey);
                                                this.DataGridLeads.option("dataSource", ds);
                                                this.DataGridLeads.endUpdate();
                                            }
                                        };
                                    </script>
                                </div>
                                <%--<div role="tabpanel" class="tab-pane" id="Geo_Leads_tab">
                                    <iframe src="/Map/ZipMap.aspx" style="width: 100%; height: 800px"></iframe>
                                </div>--%>
                                <div role="tabpanel" class="tab-pane" id="Team_Activity_Tab">
                                   <div class="mag_tab_input_group">
                                        <div class="row">
                                            <div id="dateRange2" class="containers" style="width: 100%;"></div>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 10px" id="divTeamActivity">
                                        <div class="col-md-12">
                                            <div id="leadsImportChart" class="containers" style="height: 440px; width: 100%;"></div>
                                        </div>
                                    </div>

                                    <script type="text/javascript">
                                        var TeamActivityTab = {
                                            DateRange: function () { return $('#dateRange2').has("svg").length ? $('#dateRange2').dxRangeSelector('instance') : null },
                                            ShowTab: function() {
                                                var range = this.DateRange();
                                                var selectedRange = range.getSelectedRange();                                               
                                                this.UpdateChart(selectedRange.startValue, selectedRange.endValue);
                                            },
                                            InitalTab: function () {
                                                var tab = this;
                                                var dateNow = new Date();
                                                var endDate = new Date();
                                                endDate = endDate.setDate(dateNow.getDate() + 1);
                                                var startDate = new Date(dateNow.getFullYear(), dateNow.getMonth(), 1);
                                                $("#dateRange2").dxRangeSelector({
                                                    margin: {
                                                        top: 5
                                                    },
                                                    size: {
                                                        height: 80
                                                    },
                                                    scale: {
                                                        startValue: new Date(2016,0,1),
                                                        endValue: endDate,
                                                        minorTickInterval: "day",
                                                        majorTickInterval: 'week',
                                                        minRange: "day",
                                                        showMinorTicks: true
                                                    },
                                                    sliderMarker: {
                                                        format: "monthAndDay"
                                                    },
                                                    selectedRange: {
                                                        startValue: new Date(dateNow.getFullYear(), dateNow.getMonth(), 1),
                                                        endValue: endDate
                                                    },
                                                    onSelectedRangeChanged: function (e) {
                                                        tab.UpdateChart(e.startValue, e.endValue);
                                                    }
                                                });
                                            },
                                            UpdateChart: function (startDate, endDate) {
                                                var chart = this.BarChart();
                                                var tab = this;
                                                chart.showLoadingIndicator();
                                                chart.clearSelection();
                                                var ds = new DevExpress.data.DataSource("/api/portalreport/" + startDate.toLocaleDateString().replace(/\//g, "-") + "/" + endDate.toLocaleDateString().replace(/\//g, "-"));
                                                chart.beginUpdate();
                                                chart.option({
                                                    dataSource: ds,
                                                    series: [
                                                           { valueField: "ImportCount", name: "Import Leads", argumentField: "Name" },
                                                           { valueField: "DeadCount", name: "Dead Leads", argumentField: "Name" },
                                                    ],
                                                    argumentAxis: {
                                                        argumentType: 'string'
                                                    },
                                                    title: "Leads Import Amount of the Teams",
                                                    onPointClick: function (info) {
                                                        var clickedPoint = info.target;
                                                        tab.UpdateTeamChart(clickedPoint.argument);
                                                    },
                                                });
                                                chart.endUpdate();                                                
                                            },
                                            UpdateTeamChart: function (teamName) {
                                                var chart = this.BarChart();                                               
                                                chart.showLoadingIndicator();
                                                chart.clearSelection();
                                                var ds = new DevExpress.data.DataSource("/api/portalreport/" + teamName);
                                                chart.beginUpdate();                                                
                                                chart.option({
                                                    dataSource: ds,
                                                    series: [
                                                            { valueField: "Count", name: "Week No.", argumentField: "StartDate" },
                                                    ],
                                                    argumentAxis: {
                                                        argumentType: 'datetime',
                                                        tickInterval: 'week'
                                                    },
                                                    title: teamName + "'s Leads Importing Weekly Report",
                                                    onPointClick: function(info){},
                                                });
                                                chart.endUpdate();
                                            },
                                            BarChart: function () {
                                                if ($("#leadsImportChart").has("svg").length)
                                                    return $("#leadsImportChart").dxChart("instance");
                                                else {
                                                    var tab = this;
                                                    $("#leadsImportChart").dxChart({
                                                        dataSource: {},
                                                        commonSeriesSettings: {
                                                            argumentField: "Name",
                                                            type: "bar",
                                                            hoverMode: "allArgumentPoints",
                                                            selectionMode: "allArgumentPoints",
                                                            label: {
                                                                visible: true,
                                                                format: "fixedPoint",
                                                                precision: 0
                                                            }
                                                        },
                                                        series: [
                                                            { valueField: "ImportCount", name: "Import Leads", argumentField: "Name" },
                                                            { valueField: "DeadCount", name: "Dead Leads", argumentField: "Name" },
                                                        ],
                                                        argumentAxis: {
                                                            argumentType: 'string'
                                                        },                                                     
                                                        title: "Leads Import Amount of the Teams",
                                                        legend: {
                                                            verticalAlignment: "bottom",
                                                            horizontalAlignment: "center"
                                                        },
                                                        loadingIndicator: {
                                                            show: true
                                                        },                                                        
                                                        onPointSelectionChanged: function (info) {
                                                           
                                                        },
                                                        onLegendClick: function (info) {
                                                           
                                                        }
                                                    });
                                                    return $("#leadsImportChart").dxChart("instance");
                                                }
                                            },
                                            Visible: function () {
                                                return $('#divTeamActivity').is(":visible");
                                            }
                                        }

                                    </script>

                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function BindAgents() {
            if (currentTeamInfo != null) {
                $("#selAgents").html("");
                $.each(currentTeamInfo.Users, function (key, value) {
                    $('#selAgents')
                    .append($("<option></option>")
                    .attr("value", value)
                    .text(value));
                });

                $("#selAgents").prepend("<option value='' selected='selected'>All</option>");
            }
        }

        function LoadPhoneBarChart() {
            $("#chartContainer").show();
            var localCallLogs = null;
            var customStore = new DevExpress.data.CustomStore({
                load: function (loadOptions) {
                    var d = $.Deferred();
                    $.getJSON('/wcfdataservices/portalReportservice.svc/UserReports').done(function (data) {
                        d.resolve(data, { totalCount: data.length });
                    });
                    return d.promise();
                }
            });

            var gridDataSourceConfiguration = { store: customStore };

            var logDataSource = new DevExpress.data.DataSource({
                store: customStore,
                paginate: false
            });

            $("#chartContainer").dxChart({
                dataSource: customStore,
                commonSeriesSettings: {
                    argumentField: "EmployeeName",
                    type: "stackedbar"
                },
                series: [
                     { valueField: "Inbound", name: "Inbound" },
                     { valueField: "Outbound", name: "Outbound" },
                     { valueField: "Internal", name: "Internal" },
                     { valueField: "Count", name: "Total", type: 'spline', color: 'blue' }
                ],
                argumentAxis: {
                    argumentType: 'string'
                },
                tooltip: {
                    enabled: true
                },
                legend: {
                    verticalAlignment: 'bottom',
                    horizontalAlignment: 'center'
                },
                onPointClick: function (info) {
                    var clickedPoint = info.target;
                    clickedPoint.isSelected() ? clickedPoint.clearSelection() : clickedPoint.select();
                },
                onPointSelectionChanged: function (info) {
                    var selectedPoint = info.target;
                    ShowEmployeeReport(selectedPoint.originalArgument);
                }
            });
        }

        function LoadGrid() {
            $("#gridContainer").show();
            var agent = $("#selAgents").val();
            if (agent != "") {
                ShowEmployeeReport(agent);
                return;
            }

            var localCallLogs = null;
            var customStore = new DevExpress.data.CustomStore({
                load: function (loadOptions) {
                    var d = $.Deferred();
                    $.getJSON('/wcfdataservices/portalReportservice.svc/UserReports').done(function (data) {
                        DevExpress.data.query(data).sum("Count").done(function (result) {
                            $("#divPhoneSummary").show();
                            $("#CallTotalCount").html(result);
                        });
                        d.resolve(data, { totalCount: data.length });
                    });
                    return d.promise();
                }
            });

            var gridDataSourceConfiguration = { store: customStore };

            var logDataSource = new DevExpress.data.DataSource({
                store: customStore,
                paginate: false
            });

            $(function () {
                var datagrid = $("#gridContainer").dxDataGrid({
                    dataSource: logDataSource,
                    showColumnLines: false,
                    showRowLines: true,
                    rowAlternationEnabled: true,
                    paging: { enabled: false },
                    columns: [{
                        dataField: "EmployeeName",
                        caption: "Name",
                        cellTemplate: function (container, options) {
                            if (options.value != null) {
                                var fieldHTML = '<a href="javascript:ShowEmployeeReport(\'' + options.value + '\')">' + options.value + "</a>"
                                container.html(fieldHTML);
                            }
                        }
                    }, "Inbound", {
                        dataField: "Outbound",
                        caption: "Outbound"
                    }, {
                        dataField: "Count",
                        caption: "Phone Calls"
                    }, {
                        dataField: "Duration",
                        caption: "Total Time"
                    }],
                    summary: {
                        totalItems: [{
                            column: 'Count',
                            summaryType: 'sum'
                        }]
                    }
                });
            });
        }

        function ShowEmployeeReport(empName) {
            $("#gridContainer").show();
            var empCallLogs = null;
            var empCallLogsDs = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/CallLog/" + empName);
            empCallLogsDs.load().done(function (result) {
                empCallLogs = result;

                $("#gridContainer").dxDataGrid({
                    dataSource: empCallLogs,
                    showColumnLines: false,
                    showRowLines: true,
                    rowAlternationEnabled: true,
                    paging: { enabled: false },
                    columns: [{
                        dataField: "DateTime",
                        caption: "Date",
                        dataType: "date",
                        format: "shortDate",
                        calculateGroupValue: function (rowData) {
                            var callDate = new Date(rowData.DateTime);
                            return callDate.toLocaleDateString();
                        }
                    }, {
                        dataField: "DateTime",
                        caption: "Time",
                        dataType: "date",
                        format: "shortTime",
                    },
                    "CallingNumber", "TimeZone", "Direction", "Duration", "DialedNumber", "Talk", "Answer"
                    ],
                    groupPanel: {
                        visible: true
                    },
                    allowColumnReordering: true,
                    grouping: {
                        autoExpandAll: true,
                    },
                    searchPanel: {
                        visible: true
                    },
                    summary: {
                        totalItems: [{
                            column: 'CallingNumber',
                            summaryType: 'count'
                        }, {
                            column: 'Duration',
                            summaryType: 'sum'
                        }]
                    }
                });
            });
        }

        var palette_color = ['#a5bcd7', '#e97c82', '#da5859', '#f09777', '#fbc986', '#a5d7d0', '#a5bcd7'];
        function loadCharts(office) {

            $("#monthly_intake").dxChart({
                legend: { visible: false },
                rotated: true,
                dataSource: [
                    { day: "Monday", oranges: 3 },
                    { day: "Tuesday", oranges: 2 },
                    { day: "Wednesday", oranges: 3 },
                    { day: "Thursday", oranges: 4 },
                    { day: "Friday", oranges: 6 },
                    { day: "Saturday", oranges: 11 },
                    { day: "Sunday", oranges: 4 }],

                series: {
                    argumentField: "day",
                    valueField: "oranges",

                    type: "bar",

                },
                palette: palette_color,
            });
            var dataSource = [
                  { language: "English", percent: 55.5 },
                  { language: "Chinese", percent: 4.0 },
                  { language: "Spanish", percent: 4.3 },
                  { language: "Japanese", percent: 4.9 },
                  { language: "Portuguese", percent: 2.3 },
                  { language: "German", percent: 5.6 },
                  { language: "French", percent: 3.8 },
                  { language: "Russian", percent: 6.3 },
                  { language: "Italian", percent: 1.6 },
                  { language: "Polish", percent: 1.8 }
            ];

            $("#team_hours_chart").dxPieChart({

                dataSource: dataSource,
                legend: {
                    horizontalAlignment: "center",
                    verticalAlignment: "bottom",

                    visible: false
                },

                series: [{
                    smallValuesGrouping: {
                        mode: "topN",
                        topCount: 3
                    },
                    type: "doughnut",
                    argumentField: "language",
                    valueField: "percent",
                    label: {
                        visible: true,
                        format: "fixedPoint",

                        connector: {
                            visible: true,
                            width: 1
                        }
                    }
                }]
            });


            var dataSource = new DevExpress.data.DataSource({
                load: function (loadOptions) {
                    var d = $.Deferred();
                    $.getJSON('/WCFDataServices/PortalReportService.svc/LeadsInProcessReport/' + office).done(function (data) {
                        d.resolve(data);
                        var inporcessCount = data.reduce(function (a, b) {
                            return { Count: a.Count + b.Count };
                        });
                        $("#InProcessCount").html(inporcessCount.Count)
                    });
                    return d.promise();
                }
            });
            var leadstatusData = null;
            var dataSource2 = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LeadsStatusReport/" + office);


            dataSource2.load().done(function (result) {
                leadstatusData = result;
                DevExpress.data.query(leadstatusData).sum("Count").done(function (result) {
                    $("#spanTotalLeads").html(result);
                });
            });

            var option =
                {
                    dataSource: dataSource,
                    tooltip: {
                        enabled: true,

                        percentPrecision: 2,
                        customizeText: function () {

                            return this.argumentText + " - " + this.percentText;
                        }
                    },
                    legend: { visible: false },
                    series: [{
                        type: "doughnut",
                        argumentField: "Status",
                        valueField: "Count",
                        label: {
                            visible: true,

                            connector: {
                                visible: true
                            }
                        },

                    }],
                    palette: ['#a5bcd7', '#e97c82', '#da5859', '#f09777', '#fbc986', '#a5d7d0', '#a5bcd7']

                }
            $("#LeadsStatusChart").dxPieChart(option);
            option.dataSource = dataSource2;
            $("#current_leads").dxPieChart(option);



            var leadsProcess = [
                { state: "May", young: 6.7, middle: 28.6, older: 5.1 },
                { state: "Jun", young: 9.6, middle: 43.4, older: 9 },
                { state: "Jul", young: 13.5, middle: 49, older: 5.8 },
                { state: "Aug", young: 30, middle: 90.3, older: 14.5 }
            ];

            $("#leads_process_chart").dxChart({
                dataSource: leadsProcess,
                commonSeriesSettings: {
                    argumentField: "state",
                    type: "stackedBar"
                },
                series: [
                    { valueField: "young", name: "Closed" },
                    { valueField: "middle", name: "In Process" },
                    { valueField: "older", name: "Appointments" }
                ],
                legend: {
                    verticalAlignment: "bottom",
                    horizontalAlignment: "center",
                    itemTextPosition: 'top'
                },
                valueAxis: {
                    title: {
                        text: "millions"
                    },
                    position: "right"
                },

                tooltip: {
                    enabled: true,
                    location: "edge",
                    customizeText: function () {
                        return this.seriesName + " years: " + this.valueText;
                    }
                },
                palette: ['#a5bcd7', '#e97c82', '#da5859', '#f09777', '#fbc986', '#a5d7d0', '#a5bcd7']
            });
            var compateOfficeData = [
                { year: "November,2014", Queens: 190, Brooklyn: 180, Bronx: 100, Manhattan: 150 },
                { year: "December,2014", Queens: 263, Brooklyn: 280, Bronx: 230, Manhattan: 150 },
                { year: "January", Queens: 220, Brooklyn: 380, Bronx: 190, Manhattan: 150 },

            ];



            var chartOptions = {
                dataSource: compateOfficeData,
                commonSeriesSettings: {
                    type: "spline",
                    argumentField: "year"
                },
                commonAxisSettings: {
                    grid: {
                        visible: true
                    }
                },
                margin: {
                    bottom: 20
                },
                series: [
                    { valueField: "Queens", name: "Queens Office" },
                    { valueField: "Brooklyn", name: "Queens Office" },
                    { valueField: "Bronx", name: "Bronx Office" },
                    { valueField: "Manhattan", name: "Manhattan Office" }
                ],
                tooltip: {
                    enabled: true
                },
                legend: {
                    verticalAlignment: "bottom",
                    horizontalAlignment: "center",
                    itemTextPosition: 'top'
                },
                //title: "Architecture Share Over Time (Count)",
                commonPaneSettings: {
                    border: {
                        visible: true
                    }
                }
            };
            var chart = $("#compare_offices_chart").dxChart(chartOptions).dxChart("instance");
        }
        //loadCharts("RonTeam");
    </script>

    <script type="text/javascript">

        var currentTeamInfo = null;

        function ViewLeadsInfo(bble) {
            var url = '/ViewLeadsInfo.aspx?id=' + bble;
            var left = (screen.width / 2) - (1350 / 2);
            var top = (screen.height / 2) - (930 / 2);
            window.open(url, 'View Leads Info ' + bble, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
        }

        function LoadTeamInfo(teamName) {
            return $.getJSON('/WCFDataServices/PortalReportService.svc/LoadTeamInfo/' + teamName).done(function (data) {
                currentTeamInfo = data;
                var total_agent_count = data.TeamAgentCount
                $("#total_agent_count").html(total_agent_count)
                $("#total_deal_count").html(currentTeamInfo.TotalDeals);
                $('#teams_link').html(teamName);
            });
        }

        var dropDownMenuData = <%= AllTameJson()%>

           menuItemClicked = function (e) {
               DevExpress.ui.notify({ message: e.itemData + " Data Loaded", type: "success", displayTime: 2000 });
               //        $('#teams_link').html(e.itemData);
               //officeDropDown.option("buttonText", e.itemData );
               //loadCharts(e.itemData.replace("Office", '').trim());
               agentActivityTab.ShowTab(e.itemData);
               $.when(LoadTeamInfo(e.itemData)).done(function () {
                   LeadsStatusTab.ShowTab(currentTeamInfo.TeamName, currentTeamInfo.Users)
               });
               if(TeamActivityTab.Visible())
                TeamActivityTab.UpdateTeamChart(e.itemData);
           };
        var officeDropDown = $("#dropDownMenu").dxDropDownMenu({
            dataSource: dropDownMenuData,
            onItemClick: menuItemClicked,
            buttonIcon: 'arrowdown',
        }).dxDropDownMenu("instance");

        var reportList = {
            'Agent Activity': {
                text: "<i class=\"fa fa-users mag_tabv_i\"></i>Agent Activity",
                action: function () {
                    $('#mytab a[href="#Agent_Activity_Tab"]').tab('show');
                    agentActivityTab.ShowTab(currentTeamInfo.TeamName, true);

                }
            },
            'Status Of Leads': {
                text: "<i class=\"fa fa-pie-chart mag_tabv_i\"></i>Status Of Leads",
                action: function () {
                    $('#mytab a[href="#Status_Of_Leads_Tab"]').tab('show');
                    LeadsStatusTab.ShowTab(currentTeamInfo.TeamName, currentTeamInfo.Users, true);
                }
            },
            <% If User.IsInRole("Admin") %>
            'Team Activity': {
                text: "<i class=\"fa fa-pie-chart mag_tabv_i\"></i>Team Activity",
                action: function () {
                    $('#mytab a[href="#Team_Activity_Tab"]').tab('show');
                    TeamActivityTab.InitalTab();
                    TeamActivityTab.ShowTab();
                    //LeadsStatusTab.ShowTab(currentTeamInfo.TeamName, currentTeamInfo.Users, true);
                }
            }
            <% End If %>
        };

        var reportsName = [];
        for (var key in reportList) {
            reportsName.push(key);
        }

        var reportTypeDropdown = $("#reportType").dxDropDownMenu({
            dataSource: reportsName,
            onItemClick: function (e) {
                var report = reportList[e.itemData];
                $("#tdReportTitle").html(report.text);
                report.action();
            },
            buttonIcon: 'arrowdown',
        }).dxDropDownMenu("instance");

        $(document).ready(function () {
            agentActivityTab.InitalTab();
           
            if (dropDownMenuData && dropDownMenuData.length > 0)
                ShowTeamData(dropDownMenuData[0]);
        });

        function ShowTeamData(team) {
            $.when(LoadTeamInfo(team)).done(function () {
                agentActivityTab.ShowTab(team);
            });
        }

    </script>
</asp:Content>

