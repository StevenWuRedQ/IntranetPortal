<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AgentCharts.ascx.vb" Inherits="IntranetPortal.AgentCharts" %>
<%--<dx:WebChartControl ID="WebChartControl1" runat="server" CrosshairEnabled="True" Height="200px" Width="300px">
    <diagramserializable>
        <dx:XYDiagram>
            <axisx visibleinpanesserializable="-1">
            </axisx>
            <axisy visibleinpanesserializable="-1">
            </axisy>
        </dx:XYDiagram>
    </diagramserializable>
    <seriesserializable>
        <dx:Series LabelsVisibility="True" Name="NewLeads">
            <points>
                <dx:SeriesPoint ArgumentSerializable="Bob" Values="12">
                </dx:SeriesPoint>
                <dx:SeriesPoint ArgumentSerializable="John" Values="10">
                </dx:SeriesPoint>
                <dx:SeriesPoint ArgumentSerializable="Sarah" Values="8">
                </dx:SeriesPoint>
                <dx:SeriesPoint ArgumentSerializable="Paul" Values="9">
                </dx:SeriesPoint>
            </points>
        </dx:Series>
    </seriesserializable>
    <titles>
        <dx:ChartTitle Text="Hot leads by Agent" />
    </titles>
</dx:WebChartControl>--%>
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