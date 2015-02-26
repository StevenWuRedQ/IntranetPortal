<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ZipMap.aspx.vb" Inherits="IntranetPortal.ZipMap" %>

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
    <%--<link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />--%>
    <%--<script src="/scrollbar/jquery.mCustomScrollbar.js"></script>--%>
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
    </style>
    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/leaflet.markercluster.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.css' rel='stylesheet' />
    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-markercluster/v0.4.0/MarkerCluster.Default.css' rel='stylesheet' />

    <link href='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.css' rel='stylesheet' />
    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-draw/v0.2.2/leaflet.draw.js'></script>
    <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/leaflet-geodesy/v0.1.0/leaflet-geodesy.js'></script>
    <script src="https://www.mapbox.com/mapbox.js/assets/data/realworld.388.js"></script>

</head>

<body>

    <%--</asp:Content>
<asp:content contentplaceholderid="MainContentPH" runat="server">--%>



    <div class="container-fluid">
        <div id="map"></div>
        <%--<div id="container" class="containers" style="height: 600px; width: 100%;"></div>--%>
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
        var LatLonData = <%= LatLonData%>
            function f() {

            }
        var zipMap;
        var geocoder;
        var zipLeads = <%= leadsByZip%>
            function f() {
            }

        var CountDateSet = <%= CountJosn%>
            function FindNumberByName(typeName, zipCode) {

                for (var i = 0; i < CountDateSet.length; i++) {
                    var c = CountDateSet[i];
                    if (c.TypeName == typeName && c.ZipCode == zipCode) {
                        return String(c.Count)
                    }
                }
                return 0;
            }

       //function codeAddress(zip,Count) {
       //    geocoder = new google.maps.Geocoder();
       //    var address = 'New York, NY ' + zip;
       //    geocoder.geocode({ 'address': address }, function (results, status) {
       //        if (status == google.maps.GeocoderStatus.OK) {
       //            var lat = results[0].geometry.location;
       //            zipMap = zipMap || [];
       //            zipMap[zip] = { coordinates: lat, attributes: { name: zip } };
       //            //vmaps = $('#container').dxVectorMap('instance');
       //            //vmaps.option("markers", zipMap);
       //        } else {
       //            alert("Geocode was not successful for the following reason: " + status);
       //        }
       //    });
       //}
       // function initMaker()
       // {
       //     for (var i =0 ; i<zipLeads.length;i++ )
       //     {
       //         var a = zipLeads[i];
       //         codeAddress(a.ZipCode, a.Count);
       //     }
       // }
       // initMaker();

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

        $.getJSON("/Map/MapData/nyc-zip-code.js", function (data) {
            initMapBox();
            var statesLayer = L.geoJson(data, {
                style: getStyle,
                onEachFeature: onEachFeature
            }).addTo(map);


            function getStyle(feature) {
                return {
                    weight: 2,
                    opacity: 0.1,
                    color: 'black',
                    fillOpacity: 0.7,
                    fillColor: getColor(findCountNum(feature.properties.postalCode))
                };
            }

            function getColor(d) {

                return d > 1000 ? '#1976D2' :
                    d > 500 ? '#1E88E5' :
                    d > 200 ? '#2196F3' :
                    d > 100 ? '#42A5F5' :
                    d > 50 ? '#64B5F6' :
                    d > 20 ? '#90CAF9' :
                    d > 10 ? '#BBDEFB' :
                    '#E3F2FD';
            }

            function onEachFeature(feature, layer) {
                layer.on({
                    mousemove: mousemove,
                    mouseout: mouseout,
                    click: ClickZip
                });
            }

            var closeTooltip;

            function mousemove(e) {
                var layer = e.target;

                popup.setLatLng(e.latlng);
                popup.setContent('<div class="marker-title">' + layer.feature.properties.postalCode + '</div>' +
                    findCountNum(layer.feature.properties.postalCode) + ' leads');

                if (!popup._map) popup.openOn(map);
                window.clearTimeout(closeTooltip);

                // highlight feature
                layer.setStyle({
                    weight: 3,
                    opacity: 0.3,
                    fillOpacity: 0.5
                });

                if (!L.Browser.ie && !L.Browser.opera) {
                    layer.bringToFront();
                }
            }

            function mouseout(e) {
                statesLayer.resetStyle(e.target);
                closeTooltip = window.setTimeout(function () {
                    map.closePopup();
                }, 100);
            }

            
            function ClickZip(e) {
                $('#divMsgTest').animate({ top: "25" }, 500);
                var zip = e.target.feature.properties.postalCode;
                $('#spanZip').html("Zip: " + zip);
                $('#tdLeadsCount').html(findCountNum(zip));
                $(".ZipCount").each(function (index) {
                    var c = FindNumberByName(this.id, zip);

                    $(this).html(c);

                });
                //map.fitBounds(e.target.getBounds());
            }

            map.legendControl.addLegend(getLegendHTML());

            function getLegendHTML() {
                var grades = [0, 10, 20, 50, 100, 200, 500, 1000],
                labels = [],
                from, to;

                for (var i = 0; i < grades.length; i++) {
                    from = grades[i];
                    to = grades[i + 1];

                    labels.push(
                      '<li><span class="swatch" style="background:' + getColor(from + 1) + '"></span> ' +
                      from + (to ? '&ndash;' + to : '+')) + '</li>';
                }

                return '<span>Leads in Zip</span><ul>' + labels.join('') + '</ul>';
            }
            
            map.on('zoomend', function () {
                // here's where you decided what zoom levels the layer should and should
                // not be available for: use javascript comparisons like < and > if
                // you want something other than just one zoom level, like
                // (map.getZoom > 10)
                var bound = map.getBounds();
                debugger;
            });
            
            return;


            zipMap = zipMap || [];// data.features;
            //initMapBox();
            var geoJson = []
            var myLayer = L.mapbox.featureLayer();

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

            myLayer.on('layeradd', function (e) {
                var marker = e.layer,
                feature = marker.feature;

                marker.setIcon(feature.properties.icon);
            });

            var z = zipMap;
            myLayer.setGeoJSON(geoJson);

            /*add layer swicher */
            L.control.layers({
                'Base Map': L.mapbox.tileLayer('examples.map-i87786ca'),
                'Grey Map': L.mapbox.tileLayer('examples.map-20v6611k')
            }, {
                'Leads Count Portal': myLayer,

            }).addTo(map);
            /******/
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
        function initMapBox() {
            L.mapbox.accessToken = 'pk.eyJ1IjoicG9ydGFsIiwiYSI6ImtCdG9ac00ifQ.p2_3nTko4JskYcg0YIgeyw';
            map = L.mapbox.map('map', 'portal.c0410d46')
               .addControl(L.mapbox.geocoderControl('mapbox.places'))
             .setView([40.7127, -74.0059], 11);

           
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
            background-image: linear-gradient(135deg, rgba(255, 255, 255, .05) 25%, transparent 25%, transparent 50%, rgba(255, 25,  25, .05) 50%, 
             255, .05) 5%, tasparn 75%,  transparent);
            
            x-shad w: ins
            ba(255, 55,55,.4)
             width  300p
              border  1px 
                  col r: #ff
            padding: 15px;
  tion: fixed;
                     _position:
                      ext-shadow 0 1px 0 gba(0,0,0
         
        ation  
            linear infinite;
                    info {
           ba
        o

        ;
           bor e
            b5;
        }

            
            ge .msgtit e {
            
          5px 0;
          size: 1 px
         
         .message  {

   keyframes animate-bg {
                 m

               n: 0 0;
        }


         kground-position: -80px 0
            }
        }
    </style>

    <div id="divMsgTest" class="info message" style="top: -500px; right: 25px">
        <div class="msgtitle">
            <i class="fa fa-database with_circle" style="color: white; font-size: 14px; width: 30px; height: 30px; line-height: 30px; text-align: center"></i>&nbsp; <span id="spanZip"></span>
            <span style="float: right; line-height: 30px; font-weight: 600; cursor: pointer" onclick="HideMessages()">X</span>
        </div>
        <table style="width: 100%; font-size: 14px">
            <tr>
                <td>Leads in Portal: </td>
                <td id="tdLeadsCount"></td>
            </tr>
            <tr>
                <td>Leads LP NYC: </td>
                <td id="Zip_LPCount" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Vacant Land in NYC: </td>
                <td id="Zip_VacantLand" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Condo: </td>
                <td id="Zip_Condo" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Single Family Home: </td>
                <td id="Zip_Single_Family_Home" class="ZipCount"></td>
            </tr>
            <tr>
                <td>2-4 Family: </td>
                <td id="Zip_2_4_Family" class="ZipCount"></td>
            </tr>
            <tr>
                <td>5-6 Family: </td>
                <td id="Zip_5_6_Family" class="ZipCount"></td>
            </tr>
            <tr>
                <td>7+ Family: </td>
                <td id="Zip_7MoreFamily" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Church / Synagogue: </td>
                <td id="Zip_Church_Synagogue" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Co-Op: </td>
                <td id="Zip_Co_Op" class="ZipCount"></td>
            </tr>

            <tr>
                <td>Garage: </td>
                <td id="Zip_Garage" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Office Building: </td>
                <td id="Zip_Office_Building" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Residential w/ Store: </td>
                <td id="Zip_Residential_w_Store" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Warehouse/Factory: </td>
                <td id="Zip_Warehouse_Factory" class="ZipCount"></td>
            </tr>
            <tr>
                <td>Total : </td>
                <td id="Zip_Total" class="ZipCount"></td>
            </tr>

        </table>
    </div>
</body>

<%--</asp:Content>--%>
</html>
