<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ZipMap.aspx.vb" Inherits="IntranetPortal.ZipMap" %>

<%@ Import Namespace="IntranetPortal" %>

<html>
<%--<asp:Content ContentPlaceHolderID="head" runat="server">--%>
<head>
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel='stylesheet' type='text/css' />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.0/handlebars.min.js'></script>
    <script src='https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.2/underscore-min.js'></script>

    <script src="/scripts/bootstrap-datepicker.js"></script>
    <link rel="stylesheet" href="/Content/bootstrap-datepicker3.css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%-- <link href="/css/dx.common.css" rel="stylesheet" />

    <link href="/css/dx.light.css" rel="stylesheet" />
    <script src="/Scripts/globalize/globalize.js"></script>
    <script src="/Scripts/dx.webappjs.js"></script>
    <script src="/Scripts/dx.chartjs.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true"></script>--%>
    <script src='https://api.tiles.mapbox.com/mapbox.js/v2.1.5/mapbox.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox.js/v2.1.5/mapbox.css' rel='stylesheet' />

    <style>
        body {
            margin: 0;
            padding: 0;
        }

        #map {
            position: absolute;
            top: 0;
            bottom: 0;
            width: 100%;
            left: 0px;
        }

        .count-icon {
            background: #FF400D;
            border: 5px solid rgba(255,255,255,0.5);
            color: #fff;
            font-weight: bold;
            text-align: center;
            border-radius: 50%;
            line-height: 30px;
        }

        #color_panle {
            position: absolute;
            left: 10px;
            bottom: 0;
            padding: 20px;
            margin-bottom: 34px;
            visibility:hidden;
        }

        .color_box {
            display: inline-block;
            padding: 0 5px;
            cursor: pointer;
        }

        .color_dot {
            text-align: center;
        }

        .color_dot_c {
            padding: 0 6px;
        }
    </style>
    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/leaflet.markercluster.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.css' rel='stylesheet' />
    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.Default.css' rel='stylesheet' />

    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.css' rel='stylesheet' />
    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.js'></script>
    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-geodesy/v0.1.0/leaflet-geodesy.js'></script>

    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v0.0.4/Leaflet.fullscreen.min.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v0.0.4/leaflet.fullscreen.css' rel='stylesheet' />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.0/handlebars.min.js"></script>


</head>

<body>

    <%--</asp:Content>
<asp:content contentplaceholderid="MainContentPH" runat="server">--%>

    <form id="form1" runat="server">
        <dx:ASPxGridView runat="server" ID="gridZipCountInfo" Visible="false" KeyFieldName="Id">
            <Columns>
                <dx:GridViewDataColumn FieldName="KeyCode" Caption="ZipCode"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="TypeName"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Count"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="PercentWDBStr" Caption="Percent"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Transactions"></dx:GridViewDataColumn>
            </Columns>
        </dx:ASPxGridView>
        <input type="hidden" id="isAdminLogIn" value="<%= Employee.IsAdmin(Page.User.Identity.Name)%>" />
        <input type="hidden" id="LogInTeam" value="<%= Employee.GetMyEmployeesByTeam(Page.User.Identity.Name).Select(Function(e) e.TeamName).FirstOrDefault%>" />
        <dx:ASPxGridViewExporter runat="server" GridViewID="gridZipCountInfo" ID="gridZipCountExporter"></dx:ASPxGridViewExporter>

        <!-- Modal -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header msgtitle">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">
                            <asp:LinkButton ID="btnExport" runat="server" OnClick="btnExport_Click" Text='<i class="fa fa-file-excel-o with_circle message_pupup_icon" style="cursor:pointer"  title="Export to Excel"></i>'></asp:LinkButton>
                            <%--<i class="fa fa-envelope with_circle message_pupup_icon"></i>--%>&nbsp; <span id="spanZip" style="font-size: 22px;"></span>

                        </h4>
                    </div>
                    <div class="modal-body">
                        <div id="divMsgTest">
                            <%--<div class="msgtitle message_popup_title">

                               <span style="float: right; line-height: 30px; font-weight: 600; cursor: pointer; font-size: 18px" onclick="HideMessages()"><i class="fa fa-times" style="color: #2e2f31"></i></span>
                            </div>--%>
                            <div class="message_pupup_content">
                                <div role="tabpanel">

                                    <!-- Nav tabs -->
                                    <ul class="nav nav-tabs" role="tablist">
                                        <li role="presentation" class="active"><a href="#team_leads" aria-controls="team_leads" role="tab" data-toggle="tab">Team Leads</a></li>
                                        <li role="presentation"><a href="#leads_infos" aria-controls="leads_infos" role="tab" data-toggle="tab">Leads Infos</a></li>

                                    </ul>

                                    <!-- Tab panes -->
                                    <div class="tab-content">
                                        <div role="tabpanel" class="tab-pane active" id="team_leads">
                                            <div>
                                                <table class="table table-striped info_table ">
                                                    <tbody id="team_leads_table"></tbody>
                                                </table>
                                            </div>

                                        </div>
                                        <div role="tabpanel" class="tab-pane" id="leads_infos">
                                            <table id="zipCountTable" class="info_table table table-striped">
                                                <tr id="tablehead">
                                                    <th>Type Name </th>
                                                    <th>Count </th>
                                                    <th>Percent</th>
                                                    <th>Transactions</th>
                                                </tr>
                                            </table>
                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
        <script id="team-color-template" type="text/x-handlebars-template">
            {{#each  list}}
            <div class="color_box" onclick="SelectTeam('{{Team}}')">
                <div class="color_dot"><span class="count-icon color_dot_c" style="background: {{Color}}">&nbsp;</span> </div>
                <div>{{Team}}</div>
            </div>
            {{/each}}
            <div class="color_box">
                <i class="fa fa-spinner fa-spin " id="loadingSpin" style="font-size: 48px"></i>
            </div>
        </script>
        <div class="container-fluid">
            <div id="map"></div>
            <%--<div id="container" class="containers" style="height: 600px; width: 100%;"></div>--%>
            <div id="color_panle" class="map-legends wax-legends leaflet-control" style="max-width: 1000px">
            </div>
        </div>

        <script type="text/javascript">
            //var map = $("#map").dxMap({
            //    center: "Brooklyn Bridge,New York,NY",
            //    zoom: 10,
            //    height: 500,
            //    width: "100%",
            //    provider: 'google',
            //    type: 'roadmap'
            //}).dxMap("instance");

            UNBUILD_COLOR = '14,70,134';
            UNBUILD_RAGNE = [100000, 50000, 20000, 10000, 5000, 2000, 1000];
            var isAdminLogIn = $("#isAdminLogIn").val() == 'True';
            if (isAdminLogIn) {
                $.getJSON("/map/mapdataservice.svc/LoadAllTeamColor", function (data) {
                    var source = $("#team-color-template").html();
                    var template = Handlebars.compile(source);
                    var context = { list: data };
                    var html = template(context);
                    $("#color_panle").html(html)
                });
            } else {
                $("#color_panle").css("display", "none")
            }

            var SHOW_ALL_PORTAL_LOT = true;

            if (isAdminLogIn) {
                SHOW_ALL_PORTAL_LOT = true;
            } else {
                SHOW_ALL_PORTAL_LOT = false;
            }
            var LatLonData = <%= LatLonData%>
                function f() {

                }
            var zipMap;
            var geocoder;
            var zipLeads = <%= leadsByZip%>
            function f() {
            }


            function FindNumberByName(typeName, zipCode) {

                for (var i = 0; i < CountDateSet.length; i++) {
                    var c = CountDateSet[i];
                    if (c.TypeName == typeName && c.ZipCode == zipCode) {
                        return String(c.Count)
                    }
                }
                return 0;
            }



            function findCount(zip) {
                for (var i = 0 ; i < zipLeads.length; i++) {
                    var e = zipLeads[i];
                    if (zip == e.ZipCode) {
                        return ', Leads :' + e.Count;
                    }
                }
                return ''
            }

            function findCountNum(zip) {
                for (var i = 0 ; i < zipLeads.length; i++) {
                    var e = zipLeads[i];
                    if (zip == e.ZipCode) {
                        return e.Count;
                    }
                }
                return 0;
            }

            var popup = new L.Popup({ autoPan: false });
            var ZipPolygonLayer;

            function ShowSearchLeadsInfo(bble) {
                var url = '/ViewLeadsInfo.aspx?id=' + bble;
                var left = (screen.width / 2) - (1350 / 2);
                var top = (screen.height / 2) - (930 / 2);
                window.open(url, 'View Leads Info ' + bble, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
            }

            function getMessgae(properties) {
                //var is_Blcok = map.hasLayer(BlockLayer);
                //var is_Lot = map.hasLayer(LotLayer)

                if (properties.BBLE != null) {
                    var html = '<div class="marker-title">' + 'BBLE:' + properties.BBLE + '</div>';
                    
                    if (properties.description != null) {
                        html += '<div> Leads Name : ' + properties.description + '</div>'
                        + '<div> Team : ' + properties.Team + '</div>'
                    }
                    if (properties.Unbuild_SQFT != null) {
                        html += '<div> Unbuild SQFT : ' + properties.Unbuild_SQFT + '</div>'
                    }
                    return html;
                }

                if (properties.Boro != null) {
                    return '<div class="marker-title">' + 'Borough:' + properties.Boro + '</div>' + 'Block :' +
                      properties.block;
                }

                return '<div class="marker-title">' + properties.postalCode + '</div>' +
                    findCountNum(properties.postalCode) + ' leads';
            }
            var oldStyle = null;
            function mousemove(e) {
                var layer = e.target;

                popup.setLatLng(e.latlng);

                popup.setContent(getMessgae(layer.feature.properties));

                if (!popup._map) popup.openOn(map);
                window.clearTimeout(closeTooltip);

                // highlight feature
                oldStyle = this.options.style(this.feature);
                layer.setStyle({
                    weight: 3,
                    opacity: 0.3,
                    fillOpacity: 0.5
                });

                if (!L.Browser.ie && !L.Browser.opera) {
                    layer.bringToFront();
                }
            }
            var closeTooltip;
            function mouseout(e,layer) {
                var layer = e.target;
                layer.setStyle(oldStyle);

                closeTooltip = window.setTimeout(function () {
                    map.closePopup();
                }, 100);
            }
            function getLegendHTMLUnBuild()
            {
                return getLegendHTML(UNBUILD_COLOR, UNBUILD_RAGNE);
            }
            function overlayadd(e) {
                if ("Zip Count" == e.name) {
                    map.legendControl.addLegend(getLegendHTML());
                }
                if( "Unbuild" == e.name)
                {
                    var html = getLegendHTMLUnBuild()
                    map.legendControl.addLegend(getLegendHTMLUnBuild());
                }
                if("Team Lot"==e.name)
                {
                    $("#color_panle").css("visibility", 'visible')
                }
            }
            function overlayremove(e) {
                if ("Zip Count" == e.name) {
                    map.legendControl.removeLegend(getLegendHTML());
                }
                if ("Unbuild" == e.name)
                {
                    map.legendControl.removeLegend(getLegendHTMLUnBuild());
                }
                if ("Team Lot" == e.name) {
                    $("#color_panle").css("visibility", 'hidden');
                }
            }
            //if (isAdminLogIn) {
            //    map.legendControl.addLegend(getLegendHTML());
            //}

            var zipMakerLayer
            function getLegendHTML(baseColor, baseRange) {
                var grades = baseRange != null ? baseRange : [0, 10, 20, 50, 100, 200, 500, 1000],
                labels = [],
                from, to;

                for (var i = 0; i < grades.length; i++) {
                    from = grades[i];
                    to = grades[i + 1];

                    labels.push(
                      '<li><span class="swatch" style="background:' + getColor(from + 1, baseColor, baseRange) + '"></span> ' +
                      from + (to ? '&ndash;' + to : '+')) + '</li>';
                }
                var title = baseColor != null ? "Unbuild" : 'Leads in Zip'
                return '<span>' + title + ' </span> <ul style="list-style-type: none;">' + labels.join('') + '</ul>';
            }
            function getColor(d,baseColor,baseRange) {



                var color = 'rgba(' + (baseColor != null ? baseColor : '223,48,0') + ','//'rgba('+baseColor!=null?baseColor:'223,48,0'+',';
                var percent = 0.13
                var values = baseRange!=null? baseRange : [1000, 500, 200, 100, 50, 20, 10];

                for (var i = 0; i < values.length; i++) {
                    if (d > values[i]) {
                        var optacty = (1 - percent * i);
                        return color + optacty + ')'
                    }
                }
                var optacty = (1 - percent * values.length);
                return color + optacty + ')'

                return d > 1000 ? '#287aa6' :
                    d > 500 ? '#3890bf' :
                    d > 200 ? '#469fcf' :
                    d > 100 ? '#58acd9' :
                    d > 50 ? '#6ebfea' :
                    d > 20 ? '#8ccef2' :
                    d > 10 ? '#a6dcf8' :
                    '#c7ebff';
            }
            var layersControl = null;
            function initLayers(layers) {
                var v = layersControl;
                
                /*add layer swicher */
                var layer_swicher = {

                    'Leads Count Portal': zipMakerLayer

                };
                if (isAdminLogIn) {

                    layer_swicher['Zip Count'] = ZipPolygonLayer
                    // layer_swicher['Lot Layer'] = TeamLotLayer
                }
                if (layersControl!=null)
                {
                    _.each(layersControl._layers, function (v, k) {
                        var name = _.find(_.keys(layers), function (l) { return l == v.name });
                        if (name != null) {
                            layersControl.removeLayer(v.layer);
                        }

                    });
                    _.each(layers, function (v, k) {
                        // layer_swicher[k]= v

                        layersControl.addOverlay(v, k);
                    })
                }
               

                if (layersControl == null)
                {
                    layersControl =  L.control.layers({

                    }, layer_swicher).addTo(map);
                }
               
                /******/
            }
            $.getJSON("/Map/MapData/nyc-zip-code.js", function (data) {
                initMapBox();

                ZipPolygonLayer = L.geoJson(data, {
                    style: getStyle,
                    onEachFeature: onEachFeature
                })

                if (isAdminLogIn)
                {
                    ShowPloyons(SHOW_ZIP);
                    
                }
                function getStyle(feature) {
                    return {
                        weight: 2,
                        opacity: 0.1,
                        color: 'black',
                        fillOpacity: 0.7,
                        fillColor: getColor(findCountNum(feature.properties.postalCode))
                    };
                }



                function onEachFeature(feature, layer) {
                    layer.on({
                        mousemove: mousemove,
                        mouseout: mouseout,
                        click: ClickZip
                    });
                }





                function ClickZip(e) {
                    if (!isAdminLogIn) {
                        return;
                    }
                    var zip = e.target.feature.properties.postalCode;
                    $.getJSON('/map/mapdataservice.svc/ZipCount/' + zip, function (data) {

                        //$('#divMsgTest').animate({ top: "25" }, 500);
                        $("#myModal").modal();

                        $('#spanZip').html("Zip: " + zip);
                        
                        //$('#tdLeadsCount').html(findCountNum(zip));
                        var zipCountData = data;
                        var html = $('#tablehead')[0].outerHTML;
                        var team_info_html = '';
                        var source = $("#zipCountTrTemplate").html();
                        var template = Handlebars.compile(source);
                        for (var i = 0; i < zipCountData.length; i++) {

                            var context = zipCountData[i];
                            if (context.TypeName.indexOf("Team") > 0) {
                                team_info_html += template(context);
                            } else {
                                html += template(context);
                            }

                        }
                        $("#zipCountTable").html(html);
                        $("#team_leads_table").html(team_info_html);
                        //$(".ZipCount").each(function (index) {
                        //    var c = FindNumberByName(this.id, zip);

                        //    $(this).html(c);

                        //});
                    })


                    //map.fitBounds(e.target.getBounds());
                }


                zipMap = zipMap || [];// data.features;

                var geoJson = []

                zipMakerLayer = L.mapbox.featureLayer();

                for (var i = 0 ; i < data.features.length; i++) {

                    var feature = data.features[i];
                    var lant = getCenter(feature.geometry.coordinates[0]);
                    var count = findCount(feature.properties.postalCode).replace(', Leads :', ' ');
                    if (count != '') {
                        //zipMap.push({ coordinates: lant, text: count });
                        geoJson.push({
                            // this feature is in the GeoJSON format: see geojson.org
                            // for the full specification
                            type: 'Feature',
                            geometry: {
                                type: 'Point',
                                // coordinates here are in longitude, latitude order because
                                // x, y is the standard for GeoJSON and many formats
                                coordinates: lant
                            },
                            properties: {
                                title: feature.properties.postalCode,
                                description: 'Leads: ' + count,
                                // one can customize markers by adding simplestyle properties
                                // https://www.mapbox.com/guides/an-open-platform/#simplestyle

                                icon: L.divIcon({
                                    // Specify a class name we can refer to in CSS.
                                    className: 'count-icon',
                                    // Define what HTML goes in each marker.
                                    html: count,
                                    // Set a markers width and height.
                                    iconSize: [40, 40]
                                }),
                            }
                        });
                    }
                }


                zipMakerLayer.on('layeradd', function (e) {
                    var marker = e.layer,
                    feature = marker.feature;

                    marker.setIcon(feature.properties.icon);
                });

                var z = zipMap;
                zipMakerLayer.setGeoJSON(geoJson);

                initLayers();

                map.on("overlayadd", overlayadd);
                map.on("overlayremove", overlayremove);


                return;
                //var markers = new L.MarkerClusterGroup();

                //for (var i = 0; i < LatLonData.length; i++) {
                //    var a = LatLonData[i];
                //    var title = a.PropertyAddress;
                //    var marker = L.marker(new L.LatLng(a.Latitude, a.Longitude), {
                //        icon: L.mapbox.marker.icon({ 'marker-symbol': 'building', 'marker-color': '0044FF' }),
                //        title: title
                //    });
                //    marker.bindPopup(title);
                //    markers.addLayer(marker);
                //}

                //map.addLayer(markers);
                //initMap();
            });
            function getCenter(array) {
                var lat = []
                var max = getMax(array)
                var min = getMin(array)
                lat[0] = (max.x + min.x) / 2;
                lat[1] = (max.y + min.y) / 2;
                return lat;
            }
            function getMax(array) {
                var x = array[0][0], y = array[0][1];
                for (var i = 0; i < array.length; i++) {
                    var x = Math.max(array[i][0], x)
                    var y = Math.max(array[i][1], y)
                }
                return { x: x, y: y };
            }
            function getMin(array) {
                var x = array[0][0], y = array[0][1];
                for (var i = 0; i < array.length; i++) {
                    var x = Math.min(array[i][0], x)
                    var y = Math.min(array[i][1], y)
                }
                return { x: x, y: y };
            }
            //function initMap() {
            //    var vmaps = $("#container").dxVectorMap({
            //        mapData: '/Map/MapData/nyc-zip-code.js',
            //        bounds: [-74, 41, -73, 40.4],
            //        zoomFactor: 30,
            //        tooltip: {
            //            enabled: true,
            //            border: {
            //                visible: false
            //            },
            //            font: { color: "#565656" },
            //            customizeTooltip: function (arg) {
            //                var name = arg.attribute("postalCode")
            //                var zipCount = findCount(name);

            //                return { text: name + zipCount };
            //            }
            //        },
            //        areaSettings: {
            //            customize: function (arg) {

            //            }
            //        },
            //        onAreaClick: function (e) {
            //            var target = e.target;

            //        },

            //        markerSettings: {
            //            label: {
            //                font: { size: 11 }
            //            }
            //        },
            //        markers: zipMap,

            //    })
            //    var vmaps = $('#container').dxVectorMap('instance');
            //}
            var map
            function ZoomEndMapBox() {

            }

            /*zoom out to zoom*/
            var SHOW_ZIP = 1 << 1;
            var SHOW_BLOCK = 1 << 2;
            var SHOW_LOT = 1 << 3;

            function ShowPloyons(layers) {

                showLayer(layers & SHOW_ZIP, ZipPolygonLayer)

                //showLayer(layers & SHOW_BLOCK, BlockLayer)
                showLayer(layers & SHOW_LOT, LotLayer)

            }

            function showLayer(isShow, layer) {
                if (isShow) {
                    if (!map.hasLayer(layer)) {
                        map.addLayer(layer)
                    }
                } else {
                    if (map.hasLayer(layer)) {
                        map.removeLayer(layer)
                    }
                }
            }

            function ZoomOut(zoom) {
                if (isAdminLogIn) {
                    if (zoom < 16) {
                        ShowPloyons(SHOW_ZIP)
                    }
                }


                //if (zoom >= 16 && zoom < 18) {
                //    ShowPloyons(SHOW_BLOCK);
                //}
            }
            var BlockLayer;
            var LotLayer
            function ClickLot(e) {
                var layer = e.target
                var feature = layer.feature;
                if (feature.properties.title != null) {
                    ShowSearchLeadsInfo(feature.properties.title);
                }
            }
            function onEachFeatureBlock(feature, layer) {
                layer.on({
                    mousemove: mousemove,
                    mouseout: mouseout,
                    click: ClickLot,
                });
            }


            var TeamLot = null;
            function LoadTeam(Team) {
                if (TeamLot != null) {
                    if (map.hasLayer(TeamLot)) {
                        map.removeLayer(layer);
                    }

                }
                var geoJsonUrl = '/map/mapdataservice.svc/LoadLotByTeam/' + Team;
                $.getJSON(geoJsonUrl, function (data) {

                    var geoJson = data;
                    TeamLot = LoadLotMap(geoJson)

                });

            }
            $(document).ready(function () {
                if (isAdminLogIn) {
                    //LoadLotPortal();
                } else {
                    LoadTeam($("#LogInTeam").val())
                }

            }).delay(3000)
            var loadBBLE = "0"
            var TeamLotLayer = null
            function LoadLotPortal() {
                var geoJsonUrl = '/map/mapdataservice.svc/LoadLotByBBLE/' + loadBBLE;
                $.getJSON(geoJsonUrl, function (data) {

                    var geoJson = data;

                    if (geoJson.features.length > 0) {
                        TeamLotLayer = TeamLotLayer || LoadLotMap(geoJson)
                        loadBBLE = geoJson.features[geoJson.features.length - 1].properties.BBLE
                        LoadLotPortal()
                    } else {
                        if (TeamLotLayer != null) {
                            /*add layer swicher */
                            var layer_swicher = {

                                'Leads Count Portal': zipMakerLayer

                            };
                            if (isAdminLogIn) {

                                layer_swicher['Zip Count'] = ZipPolygonLayer
                                layer_swicher['Team Lot Layer'] = TeamLotLayer
                            }


                            L.control.layers({

                            }, layer_swicher).addTo(map);
                            /******/
                        }
                    }

                });
            }
            function LoadLotMap(geoJson, styleHandler) {
                
                
                return L.geoJson(geoJson, {
                    style:styleHandler != null?styleHandler : function (feature) {
                        var fColor = feature.properties.color != null ? feature.properties.color : '#18FFFF';
                        if (feature.LPBBLE != null) {
                            fColor = '#D50000'
                        } else if (feature.Unbuild_SQFT != null) {
                            fColor = '#4A148C'
                        }
                        return {
                            weight: 2,
                            opacity: 0.1,
                            color: 'black',
                            fillOpacity: 0.7,
                            fillColor: fColor
                        };

                    },
                    onEachFeature: onEachFeatureBlock
                })//.addTo(map)

            }
            function buildGeoJson(Features)
            {
                var geojson = {};
                geojson['type'] = 'FeatureCollection';
                geojson['features'] = Features;
                return geojson
            }
            function ZoomIn(zoom) {
                //if (zoom === 16) {
                //    // here's where you decided what zoom levels the layer should and should
                //    // not be available for: use javascript comparisons like < and > if
                //    // you want something other than just one zoom level, like
                //    // (map.getZoom > 17)
                //    var bounds = map.getBounds();
                //    var northEast = bounds.getNorthEast();
                //    var southWest = bounds.getSouthWest();

                //    var string = [northEast.lat, northEast.lng, southWest.lat, southWest.lng].join(',');
                //    var geoJsonUrl = '/map/mapdataservice.svc/BlockData/' + string;

                //    $.getJSON(geoJsonUrl, function (data) {

                //        var geoJson = data;
                //        //if (BlockLayer != null)
                //        //{
                //        //    showLayer(false, BlockLayer)
                //        //}
                //        BlockLayer = L.geoJson(geoJson, {
                //            style: {
                //                weight: 2,
                //                opacity: 0.1,
                //                color: 'black',
                //                fillOpacity: 0.7,
                //                fillColor: '#42A5F5'
                //            },
                //            onEachFeature: onEachFeatureBlock
                //        });
                //        ShowPloyons(SHOW_BLOCK);

                //    });
                //}
                
                if (zoom === 18) {
                    var bounds = map.getBounds();
                    var northEast = bounds.getNorthEast();
                    var southWest = bounds.getSouthWest();

                    var string = [northEast.lat, northEast.lng, southWest.lat, southWest.lng].join(',');
                    var geoJsonUrl = '/map/mapdataservice.svc/LoadLotData/' + string;

                    $.getJSON(geoJsonUrl, function (data) {

                        var geoJson = data;
                        var teamLotFeatures = _.filter(geoJson.features, function (f) {
                            return f.properties.title != null;
                        })

                        LotLayer = LoadLotMap(buildGeoJson(teamLotFeatures));
                        LPLayer = LoadLotMap(buildGeoJson(_.filter(geoJson.features, function (f) {
                            return f.properties.LPBBLE != null && f.properties.title == null;
                        })));

                        function UnBuildStyle(feature) {
                            var fColor = getColor(parseInt(feature.properties.Unbuild_SQFT), UNBUILD_COLOR, UNBUILD_RAGNE)
                            return {
                                weight: 2,
                                opacity: 0.1,
                                color: '#0e4686',
                                fillOpacity: 0.7,
                                fillColor: fColor
                            };

                        }
                        var unbuild = _.filter(geoJson.features, function (f) {
                            return f.properties.title == null && f.properties.Unbuild_SQFT != null;
                        })
                        unbuild = _.sortBy(unbuild, function (f) { return f.properties.Unbuild_SQFT });
                        UnbuildLayer = LoadLotMap(buildGeoJson(_.filter(geoJson.features, function (f) {
                            return f.properties.title == null && f.properties.Unbuild_SQFT!=null;
                        })), UnBuildStyle);
                        
                        //L.control.layers().addOverlay(LotLayer, "Team Lot")
                        //LotLayer.addTo(map);
                        initLayers({ "Team Lot": LotLayer, "LP Lot": LPLayer, 'Unbuild': UnbuildLayer });
                        ShowPloyons(SHOW_LOT);

                    });

                }
            }

            function MapZoomLevelChange() {
                var nowZoom = map.getZoom();
                nowZoom > ZoomLevel ? ZoomIn(nowZoom) : ZoomOut(nowZoom);
                ZoomLevel = nowZoom;
            }

            var ZoomLevel = 11;
            function initMapBox() {
                L.mapbox.accessToken = 'pk.eyJ1IjoicG9ydGFsIiwiYSI6ImtCdG9ac00ifQ.p2_3nTko4JskYcg0YIgeyw';
                map = L.mapbox.map('map', 'examples.map-i87786ca', { loadingControl: true })
                    .addControl(L.mapbox.geocoderControl('mapbox.places').on("found", function (e) {

                    }))
                    .setView([40.7127, -74.0059], 11);

                L.control.fullscreen().addTo(map);
                /* add Draw Polyon contorl*/
                var featureGroup = L.featureGroup().addTo(map);

                var drawControl = new L.Control.Draw({
                    edit: {
                        featureGroup: featureGroup
                    },
                    draw: {
                        polygon: true,
                        polyline: false,
                        rectangle: false,
                        circle: false,
                        marker: false
                    }
                }).addTo(map);

                map.on('draw:created', showPolygonArea);
                map.on('draw:edited', showPolygonAreaEdited);
                /******************/

                map.on("zoomend", MapZoomLevelChange);
                function showPolygonAreaEdited(e) {
                    e.layers.eachLayer(function (layer) {
                        showPolygonArea({ layer: layer });
                    });
                }
                function showPolygonArea(e) {
                    featureGroup.clearLayers();
                    featureGroup.addLayer(e.layer);
                    e.layer.bindPopup((LGeo.area(e.layer) / 1000000).toFixed(2) + ' km<sup>2</sup>');
                    e.layer.openPopup();
                }
            }

            function HideMessages() {
                var msgHeight = $("#divMsgTest").outerHeight() + 10;
                $('#divMsgTest').css('top', -msgHeight);
            }

        </script>

        <style type="text/css">
            .map-legend .swatch {
                width: 20px;
                height: 20px;
                float: left;
                margin-right: 10px;
            }

            .leaflet-popup-close-button {
                display: none;
            }

            .leaflet-popup-content-wrapper {
                pointer-events: none;
            }

            .message {
                background-size: 40px 40px;
                background-image: linear-gradient(135deg, rgba(255, 255, 255, .05) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, .05) 50%, rgba(255, 255, 255, .05) 75%, transparent 75%, transparent);
                box-shadow: inset 0 -1px 0 rgba(255,255,255,.4);
                width: 300px;
                border: 1px solid;
                color: #fff;
                padding: 15px;
                position: fixed;
                _position: absolute;
                text-shadow: 0 1px 0 rgba(0,0,0,.5);
                animation: animate-bg 5s linear infinite;
            }

            .info {
                background-color: #4ea5cd;
                border-color: #3b8eb5;
            }

            .message .msgtitle {
                margin: 0 0 5px 0;
                font-size: 14px;
            }

            .message p {
        
      @keyframes animate b {
                f

                   : 0 0;
               }                                        
                  nd-position: - 0
                     }
          .mess ge_popup
                  backgroun : whit
                  color: #7778 b;
                 kground  whit
                  border-ra ius: 12p;                
             boder none;
                box-shad w: -
            p

            0, 0.25);
          
           }

                 e_popup_title 
                             d;
            10px 0px 0px 
                    font-siz : 22
                   color  #399
             
            ht: 300;
          ;
           }
                essage pupup
                       ont-s
                          wi th: 3
                    height: 32px;                
                ne-height: 32p ;                
  -align: cener;
                  
            0px;
                o
                           }                ssage_pupu _cont
                     p dding: 0px;
     t

                        mporta t;                
                           info_
                      width: 00%;
     t

            
                color:##77787b !important;
            }
        </style>

        <script id="zipCountTrTemplate" type="text/x-handlebars-template">

            <tr>
                <td>{{TypeName}}  </td>
                <td>{{ Count}}</td>
                <td>{{ PercentWDBStr}}</td>
                <td>{{Transactions}}</td>
            </tr>
        </script>

        <script>
            $('[title]').tooltip({ placement: 'bottom' })
        </script>

        <script>
            $(document).ajaxSend(function () {
                ShowLoading(true);
            });
            $(document).ajaxComplete(function (event, request, settings) {
                ShowLoading(false);
            });

            function ShowLoading(isloading) {
                if (isloading) {
                    //$('#LoadingSpin').addClass("fa-spin")
                    $('#loadingSpin').css("display",'')

                } else {
                    //$('#LoadingSpin').removeClass("fa-spin")
                    $('#loadingSpin').css("display", 'none')
                }
            }
        </script>
    </form>


</body>

<%--</asp:Content>--%>
</html>
