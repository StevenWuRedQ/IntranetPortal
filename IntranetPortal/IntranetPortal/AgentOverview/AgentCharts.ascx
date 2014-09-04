<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AgentCharts.ascx.vb" Inherits="IntranetPortal.AgentCharts" %>
<%--use jquery 2.1.1 can't show the tooltips--%>
<%--<script src="/Scripts/jquery-2.1.1.min.js"></script>--%>
<script src="/Scripts/globalize/globalize.js"></script>
<script src="/Scripts/dx.chartjs.js"></script>
<div style="padding-top: 43px;padding-bottom:20px; font-size: 30px; color: #ff400d; text-align: center;" id="chartsTitle">Charts Title</div>

<div style="overflow: auto; width: 871px" id="chars_with_scorll">
    <div id="container" style="height: 350px;"></div>
    <div id="pieChart" style="height: 350px;"></div>
</div>

<script type="text/javascript">
    /*
       show UI elemnt and function with diffrent stauts 
       1. when status user or offices provide activity log function 
       2. system or office and x-axis is employees name status show bar click function
       3.status user could choice most fild x-axis in dropdown menu
    */
    var chart_status_enum =
        {
            status_user: 0,
            status_office: 1,
            status_system: 2

        };
    $(document).ready(function () {

        //$(window).resize(function () {
        //    var chart_div = $('#chars_with_scorll')
        //    $('#chars_with_scorll').width(chart_div.width());
        //    $("#chars_with_scorll_wh").html("w =" + chart_div.width() + ";h =" + chart_div.height());
        //})
    });
    var char_show_status = chart_status_enum.status_office;
    function chart_resize() {
        var chart_div = $('#chars_with_scorll')
        alert(chart_div);
        $("#chars_with_scorll_wh").html("w =" + chart_div.width() + ";h =" + chart_div.height());
    }
    function change_chart_type(e) {
        //alert($(e).text());
        var type = $(e).text();
        var functions = {
            Line: show_line_chart,
            Bar: show_bar_chart,
            Pie: show_pie_chart,
        }
        //alert(functions[type])
        functions[type]();
    };
    function change_chart_x_axis(e) {

        if (empId == null) {
            alert("empId is null")
            return;
        }
        var x_axis = $(e).text();
        change_x_axis_clinet.PerformCallback(x_axis + "|" + empId)
    }
    function change_chart_time(e) {
        var time = e;
        //alert(" " + e + "," + empId);
        LoadAngentTodayReport(empId + "," + time);
        //var chart = $("#container").dxChart("instance");

        //chart.option("title", time);

    }
    function clear_chart(show_pie) {
        if (show_pie) {
            $('#pieChart').show();

            $('#container').hide();
        }
        else {
            $('#pieChart').hide();

            $('#container').show();
        }

    }
    function show_line_chart() {
        clear_chart()
        var dataSource = [
            { year: 1950, europe: 546, americas: 332, africa: 227 },
            { year: 1960, europe: 605, americas: 417, africa: 283 },
            { year: 1970, europe: 656, americas: 513, africa: 361 },
            { year: 1980, europe: 694, americas: 614, africa: 471 },
            { year: 1990, europe: 721, americas: 721, africa: 623 },
            { year: 2000, europe: 730, americas: 836, africa: 797 },
            { year: 2010, europe: 728, americas: 935, africa: 982 },
            { year: 2020, europe: 721, americas: 1027, africa: 1189 },
            { year: 2030, europe: 704, americas: 1110, africa: 1416 },
            { year: 2040, europe: 680, americas: 1178, africa: 1665 },
            { year: 2050, europe: 650, americas: 1231, africa: 1937 }
        ];

        $("#container").dxChart({
            dataSource: dataSource,
            commonSeriesSettings: {
                argumentField: "year"
            },
            series: [
                { valueField: "europe", name: "Europe" },
                { valueField: "americas", name: "Americas" },
                { valueField: "africa", name: "Africa" }
            ],
            argumentAxis: {
                grid: {
                    visible: true
                }
            },
            tooltip: {
                enabled: true
            },
            title: "Historic, Current and Future Population Trends",
            legend: {
                verticalAlignment: "bottom",
                horizontalAlignment: "center"
            },
            commonPaneSettings: {
                border: {
                    visible: true,
                    right: false
                }
            }
        });
    }
    function show_element() {
        var provide_activity = char_show_status == chart_status_enum.status_office || char_show_status == chart_status_enum.status_user;
        var display_style = provide_activity ? 'inline' : 'none';
        $('#id_activity_log').css('display', display_style);
        $('#id_change_range_drop_down').css('display', display_style);
    }
    function show_bar_chart(ds) {
        var dataFormSever = ds != null ? ds : $.parseJSON('<%=ChartSource()%>');
        clear_chart();
        show_element();

        var chartData = dataFormSever.DataSource;
        //var item = chartData[0]
        //for (var i = 1; i < 30; i++) {
        //    var addItem =
        //        {
        //            Name: item["Name"] + i,
        //            Count: item["Count"] + i
        //        }
        //    chartData.push(addItem);
        //}
        var chartTitle = dataFormSever.Title == null ? "Leads" : dataFormSever.Title;
        $('#chartsTitle').text(chartTitle);
        //$("#container").width(600);
        $("#container").width(40);
        var charsWidth = $("#container").width();
        var tagertWidth = 40 * chartData.length + 80;

        if (charsWidth < tagertWidth) {

            $("#container").width(tagertWidth);
        }
       
       
        var charts = $("#container").dxChart({
            dataSource: chartData,
            commonSeriesSettings: {
                argumentField: "state",
                type: "bar",
                hoverMode: "allArgumentPoints",
                selectionMode: "allArgumentPoints",
                label: {
                    visible: true,
                    format: "fixedPoint",
                    precision: 0
                }
            },
            series: {
                argumentField: "Name",
                valueField: "Count",
                name: "name",
                type: "bar",
                color: '#B0BF1A'
            },
            //title: chartTitle,
            legend: {
                visible: false,
                verticalAlignment: "bottom",
                horizontalAlignment: "center"
            },
            tooltip: {
                enabled: true,
                customizeText: function () {

                    return this.valueText;
                }
            }
        ,
            pointClick: function (point) {
                //this.select();
                //alert('-1|' + point.originalArgument)
                //BindEmployee('-1|' + point.originalArgument);
                char_show_status = chart_status_enum.status_user
                /* only with name get if all status then remove it*/
                if (parseInt(point.originalArgument) > 0) {
                    alert("can't find employee " + point.originalArgument)
                    return;
                }
                getEmployeeIDByNameClinet.PerformCallback(point.originalArgument);
            }
        });
        if (char_show_status == chart_status_enum.status_user) {
            $("#container").dxChart("instance").option({
                pointClick: null
            });
        }
        //alert('char_show_status' + char_show_status);
    }



    function show_pie_chart(ds) {
        clear_chart(true);

        var dataSource = [
          { Name: "USA", Count: 110 },
          { Name: "China", Count: 100 },
          { Name: "Russia", Count: 72 },
          { Name: "Britain", Count: 47 },
          { Name: "Australia", Count: 46 },
          { Name: "Germany", Count: 41 },
          { Name: "France", Count: 40 },
          { Name: "South Korea", Count: 31 }
        ];

        var chartTitle = "Pie Chart";
        if (ds) {
            dataSource = ds.DataSource;
            chartTitle = ds.Title;
        }
        $("#pieChart").dxPieChart({
            dataSource: dataSource,
            title: chartTitle,
            legend: {
                orientation: "horizontal",
                itemTextPosition: "right",
                horizontalAlignment: "right",
                verticalAlignment: "bottom",
                rowCount: 2
            },
            series: [{
                argumentField: "Name",
                valueField: "Count",
                label: {
                    visible: true,
                    font: {
                        size: 16
                    },
                    connector: {
                        visible: true,
                        width: 0.5
                    },
                    position: "columns",
                    customizeText: function (arg) {
                        return arg.valueText + " ( " + arg.percentText + ")";
                    }
                }
            }]
        });
    }

    function LoadStatusBarChart(status) {
        char_show_status = chart_status_enum.status_system;
        callbackDsClient.PerformCallback(status);
    }

    function LoadOfficeBarChart(office) {
        char_show_status = chart_status_enum.status_office;
        callbackOfficeLeads.PerformCallback(office);
    }

    function LoadEmployeeBarChart(empId) {
        char_show_status = chart_status_enum.status_user;
        callbackEmployeeClient.PerformCallback(empId);
    }
    function LoadAngentTodayReport(empId) {
        callbackAgentClinet.PerformCallback(empId);
    }
    function AgentDateSourceLoadedComplete(s, e) {
        show_bar_chart($.parseJSON(e.result));
    }

    function DataSourceLoadedComplete(s, e) {
        show_bar_chart($.parseJSON(e.result));
    }

    function AgentZoningData(empId) {
        callbackAgentZoning.PerformCallback(empId);
    }
    function AgentDateSourceZoningComplete(s, e) {
        show_pie_chart($.parseJSON(e.result))
    }
    function ChangeDataSource() {
        var ds = eval('<% ChartSource()%>');
            show_bar_chart(ds);
        }
        function change_x_axis_complete(s, e) {
            show_bar_chart($.parseJSON(e.result))
        }
        show_bar_chart();
</script>
<dx:ASPxCallback runat="server" ID="callbackDs" OnCallback="callbackDs_Callback" ClientInstanceName="callbackDsClient">
    <ClientSideEvents CallbackComplete="DataSourceLoadedComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ID="ASPxCallback1" OnCallback="ASPxCallback1_Callback" ClientInstanceName="callbackEmployeeClient">
    <ClientSideEvents CallbackComplete="DataSourceLoadedComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ID="loadAgentCallBack" OnCallback="loadAgentCallBack_Callback" ClientInstanceName="callbackAgentClinet">
    <ClientSideEvents CallbackComplete="AgentDateSourceLoadedComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ID="loadAgentZoning" OnCallback="loadAgentZoning_Callback" ClientInstanceName="callbackAgentZoning">
    <ClientSideEvents CallbackComplete="AgentDateSourceZoningComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ID="loadOfficeLeadsCallback" OnCallback="loadOfficeLeadsCallback_Callback" ClientInstanceName="callbackOfficeLeads">
    <ClientSideEvents CallbackComplete="DataSourceLoadedComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ID="char_change_x_axis_id" OnCallback="char_change_x_axis_id_Callback" ClientInstanceName="change_x_axis_clinet">
    <ClientSideEvents CallbackComplete="change_x_axis_complete" />
</dx:ASPxCallback>
