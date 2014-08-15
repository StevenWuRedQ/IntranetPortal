<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AgentCharts.ascx.vb" Inherits="IntranetPortal.AgentCharts" %>
<%--use jquery 2.1.1 can't show the tooltips--%>
<%--<script src="/Scripts/jquery-2.1.1.min.js"></script>--%>
<script src="/Scripts/globalize/globalize.js"></script>
<script src="/Scripts/dx.chartjs.js"></script>
<div id="container" style=" max-width: 1200px; height: 400px;"></div>
<div id="pieChart" style="max-width: 1200px; height: 400px;"></div>
<script type="text/javascript">

    //var dataSource = [
    //    {day: "Monday", oranges: 3},
    //    {day: "Tuesday", oranges: 2},
    //    {day: "Wednesday", oranges: 3},
    //    {day: "Thursday", oranges: 4},
    //    {day: "Friday", oranges: 6},
    //    {day: "Saturday", oranges: 11},
    //    {day: "Sunday", oranges: 4} 
    //];
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
    function change_chart_time(e)
    {
        var time = $(e).text();
        var chart = $("#container").dxChart("instance");
        chart.option("title", time);
    }
    function clear_chart(show_pie)
    {
        if (show_pie)
        {
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
    function show_bar_chart(ds) {
        var dataFormSever = ds!=null?ds:$.parseJSON('<%=ChartSource()%>');
        clear_chart()
        
        var charts = $("#container").dxChart({
            dataSource: dataFormSever,

            series: {
                argumentField: "Name",
                valueField: "Count",
                name: "name",
                type: "bar",
                color: '#ffa500'
            },
            title: "In the last 6 months",
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
                this.select();
            }
        });     
    }

    function show_pie_chart( ds ) {
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
       
        if (ds)
        {
            dataSource = ds;
        }
        $("#pieChart").dxPieChart({
            dataSource: dataSource,
            title: "Chart of last 6 months",
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
    function LoadStatusBarChart(status)
    {
        callbackDsClient.PerformCallback(status);
    }
    function LoadOfficeBarChart(office)
    {
        callbackOfficeLeads.PerformCallback(office);
    }

    function LoadEmployeeBarChart(empId)
    {
        callbackEmployeeClient.PerformCallback(empId);
    }
    function LoadAngentTodayReport(empId)
    {
        callbackAgentClinet.PerformCallback(empId);
    }
    function AgentDateSourceLoadedComplete(s, e)
    {        
        show_bar_chart($.parseJSON(e.result));
    }
    function DataSourceLoadedComplete(s, e)
    {
        show_bar_chart( $.parseJSON(e.result) );
    }
    function AgentZoningData(empId)
    {
        callbackAgentZoning.PerformCallback(empId);
    }
    function AgentDateSourceZoningComplete(s, e)
    {
        show_pie_chart($.parseJSON(e.result))
    }
    function ChangeDataSource()
    {
        var ds = eval('<% ChartSource()%>');        
        show_bar_chart(ds);
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