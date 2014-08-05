<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AgentCharts.ascx.vb" Inherits="IntranetPortal.AgentCharts" %>

<script src="/Scripts/jquery-2.1.1.min.js"></script>
<script src="/Scripts/globalize/globalize.js"></script>
<script src="/Scripts/dx.chartjs.js"></script>
<div id="chartContainer" style="max-width:800px;height: 400px;"></div>
<script type="text/javascript">
    $("#chartContainer").dxChart({
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
            name: "My oranges",
            type: "bar",
            color: '#ffa500'
        }
    });
</script>