<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ZipMap.aspx.vb" Inherits="IntranetPortal.ZipMap" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="/css/dx.common.css" rel="stylesheet" />

    <link href="/css/dx.light.css" rel="stylesheet" />
    <script src="/Scripts/globalize/globalize.js"></script>
    <script src="/Scripts/dx.webappjs.js"></script>
    <script src="/Scripts/dx.chartjs.js"></script>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">



    <div class="container-fluid">
        <div id="map"></div>
        <div id="container" class="containers" style="height: 440px; width: 100%;"></div>
    </div>

    <script>
        //var map = $("#map").dxMap({
        //    center: "Brooklyn Bridge,New York,NY",
        //    zoom: 10,
        //    height: 500,
        //    width: "100%",
        //    provider: 'google',
        //    type: 'roadmap'
        //}).dxMap("instance");

        $("#container").dxVectorMap({
            mapData: '/Map/MapData/nyc-zip-code.geojson',
            bounds: [-180, 85, 180, -60],
            tooltip: {
                enabled: true,
                border: {
                    visible: false
                },
                font: { color: "#565656" },
                customizeTooltip: function (arg) {
                    var name = arg.attribute("name")
                        
                    return 'Test';
                }
            },
            areaSettings: {
                customize: function (arg) {
                    
                }
            },
            onAreaClick: function (e) {
                var target = e.target;
               
            }
        });
    </script>
</asp:Content>
