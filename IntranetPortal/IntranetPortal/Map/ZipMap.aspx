<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ZipMap.aspx.vb" Inherits="IntranetPortal.ZipMap" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
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
    
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">



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
            function f()
            {

            }
        var zipMap;
        var geocoder;
        var zipLeads = <%= leadsByZip%>

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
        $.getJSON("/Map/MapData/nyc-zip-code.js", function (data) {
            zipMap = zipMap || [];// data.features;
            initMapBox();
            var geoJson = []
            var myLayer = L.mapbox.featureLayer().addTo(map);
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
                            description: 'Leads: '+count,
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
            map = L.mapbox.map('map', 'portal.l8711nb2')
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

    </script>
</asp:Content>
