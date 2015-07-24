<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="StreetView.aspx.vb" Inherits="IntranetPortal.StreetView" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Street View containers</title>
    <style>
        html, body, #map-canvas {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
    <script>
        var myPano = null;
        var geocoder;
        var isMap = false;
        function initialize() {
            geocoder = new google.maps.Geocoder();

            var bryantPark = new google.maps.LatLng(37.869260, -122.254811);
            var panoramaOptions = {
                position: bryantPark,
                pov: {
                    heading: 165,
                    pitch: 0
                },
                zoom: 1
            };

            if (window.location.search.indexOf("map") > 0) {
                isMap = true;
                var newyork = new google.maps.LatLng(40.714623, -74.006605);
                var mapOptions = {
                    zoom: 8,
                    center: newyork
                };
                myPano = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
                return;
            }
            else {
                myPano = new google.maps.StreetViewPanorama(
                document.getElementById('map-canvas'),
                panoramaOptions);
            }

            myPano.setVisible(true);
        }

        window.showAddress = function (address) {
            //alert(geocoder.geocode);
            geocoder.geocode({ 'address': address }, function (results, status) {
                //alert(status);
                if (status == google.maps.GeocoderStatus.OK) {
                    //alert(isMap);
                    if (isMap) {

                        if (myPano != null) {
                            myPano.setCenter(results[0].geometry.location, 12);
                            var marker = new google.maps.Marker({
                                position: results[0].geometry.location,
                                title: address
                            });

                            marker.setMap(myPano);
                            myPano.setZoom(17);
                            //alert("Finish");
                        }
                    }
                    else {
                        if (myPano != null) {
                            //alert(results[0].formatted_address);
                            //alert(address);
                            myPano.setPosition(results[0].geometry.location);

                        }
                    }

                } else {
                    alert('Geocode was not successful for the following reason: ' + status + ". Address is " + address);
                }
            });

        }

        google.maps.event.addDomListener(window, 'load', initialize);             


    </script>
</head>
<body>
    <div id="map-canvas"></div>
    <script type="text/javascript">
        google.maps.event.addDomListener(window, 'load', function () {
            showAddress('<%= Address%>');
        });
    </script>
</body>
</html>
