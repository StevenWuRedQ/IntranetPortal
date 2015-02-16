<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Management.aspx.vb" Inherits="IntranetPortal.Management1" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="/css/dx.common.css" rel="stylesheet" />
    <link href="/Content/dx.ios7.default.css" rel="stylesheet" />
    <link href="/css/dx.light.css" rel="stylesheet" />
    <style>
        .nofoucs:focus {
            border: none !important;
        }
    </style>
   
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">

    <script src="/Scripts/globalize/globalize.js"></script>
    <script src="/Scripts/dx.chartjs.js"></script>
    <script src="/Scripts/dx.webappjs.js"></script>
    <script src="/Scripts/dx.phonejs.js"></script>
    <div class="container-fluid">
        <%--Head--%>
        <div style="padding-top: 30px">
            <div style="font-size: 48px; color: #234b60">

                <div class="row">
                    <div class="col-md-4">
                        <span class="border_right" style="padding-right: 30px; font-weight: 300;">Management Summary</span>
                    </div>
                    <div class="col-md-2">

                        <table>
                            <tr>
                                <td>
                                    <span style="font-size: 30px" id="teams_link">Queens Team</span>
                                </td>
                                <td>
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
                                <span class="magement_font magement_number">23</span>
                            </div>
                            <div style="display: inline-block; margin-left: 20px">
                                <span class="magement_font">total deals within last 30 days</span>
                                <span class="magement_font magement_number">241</span>
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
            <div class="row">
                <div class="col-md-7">
                    <div role="tabpanel" class="mag_tab_panel">

                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active mag_tab"><a class="mag_tab_text" href="#phone_callsTab" aria-controls="phone_callsTab" role="tab" data-toggle="tab"><i class="fa fa-phone"></i>
                                <br />
                                Phone Calls</a></li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#profile" aria-controls="profile" role="tab" data-toggle="tab"><i class="fa fa-sign-in"></i>
                                <br />
                                Door Knocks</a></li>
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
                                            <select class="form-control">
                                                <option>All Agents</option>
                                                <option>Agents 1</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1">
                                            <input type="button" value="Display" class="rand-button bg_color_blue rand-button-padding" onclick="LoadGrid()" />
                                        </div>
                                    </div>
                                </div>
                                <div style="margin: 30px 0; font-size: 24px; color: #234b60">
                                    <span style="font-weight: 900" id="CallTotalCount">52,013 </span>Phone Calls<br />
                                    <span style="font-size: 14px; color: #77787b">January 1, 2015 - January 31, 2015</span>
                                </div>
                                <div style="font-size: 14px;">
                                    <div id="gridContainer" style="height: 450px; max-width: 1000px; width: 100%; margin: 0 auto"></div>

                                    <table class="table table-striped" style="display: none">
                                        <thead style="text-transform: uppercase">
                                            <tr>
                                                <td>Name</td>
                                                <td>Phone Calls </td>
                                                <td>Total Time</td>
                                                <td>Longest Call TO</td>
                                                <td>Last Called #</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row">BiBi Khan</th>
                                                <td>1,234</td>
                                                <td>37H 23M</td>
                                                <td>718-123-4567</td>
                                                <td>800-324-4567</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">Prakash Maharaj</th>
                                                <td>1,234</td>
                                                <td>37H 23M</td>
                                                <td>718-123-4567</td>
                                                <td>800-324-4567</td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>


                            </div>
                            <div role="tabpanel" class="tab-pane" id="profile">...</div>
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
            </div>
        </div>
    </div>
   
    <script type="text/javascript">
        function LoadGrid() {
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
                select: "Count"
            });

            logDataSource.load().done(function (result) {
                debugger;
                DevExpress.data.query(result).sum("Count").done(function (result) {
                    $("#CallTotalCount").html(result);
                });
            });

            $(function () {
                var datagrid = $("#gridContainer").dxDataGrid({
                    dataSource: gridDataSourceConfiguration,
                    showColumnLines: false,
                    showRowLines: true,
                    rowAlternationEnabled: true,
                    paging: { enabled: false },
                    columns: [{
                        dataField: "EmployeeName",
                        caption: "Name",
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
    </script>


    <script>
        function loadCharts(office) {

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
                        }
                    }]
                }
            $("#container").dxPieChart(option);
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
                }
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
        loadCharts("Queens");
    </script>
    <script>
        dropDownMenuData = <%= AllTameJson()%>
        //dropDownMenuData = [
        //    "Queens Team",
        //    "Bronx Team",
        //    "Rockaway Team"

        //];
        menuItemClicked = function (e) {
           
            DevExpress.ui.notify({ message: e.itemData + " Data Loaded", type: "success", displayTime: 2000});
            $('#teams_link').html(e.itemData);
            //officeDropDown.option("buttonText", e.itemData );
            loadCharts(e.itemData.replace("Office",'').trim());
        };
        var officeDropDown = $("#dropDownMenu").dxDropDownMenu({
            dataSource: dropDownMenuData,
            itemClickAction: menuItemClicked,
            buttonIcon: 'arrowdown',
        }).dxDropDownMenu("instance");

    </script>
</asp:Content>

