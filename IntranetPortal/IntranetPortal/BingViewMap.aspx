<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BingViewMap.aspx.vb" Inherits="IntranetPortal.BingViewMap" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
        html, body, #mapDiv {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }
    </style>

    <script type="text/javascript" src="http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=7.0"></script>

    <script type="text/javascript">

        var map = null;

        function GetMap() {

            map = new Microsoft.Maps.Map(document.getElementById("mapDiv"), {
                credentials: "<%= ConfigurationManager.AppSettings("BingMapKey").ToString %>",
                center: new Microsoft.Maps.Location(47.592, -122.332),
                mapTypeId: Microsoft.Maps.MapTypeId.birdseye,
                zoom: 17,
                showScalebar: false
            });

            //// Define the pushpin location
            //var loc = new Microsoft.Maps.Location(47.592, -122.332);

            //// Add a pin to the map
            //var pin = new Microsoft.Maps.Pushpin(loc);
            //map.entities.push(pin);

            //// Center the map on the location
            //map.setView({ center: loc, zoom: 17 });
        }

        var propertyAddress = null;
        window.showAddress = function (address) {
            propertyAddress = address;
            map.getCredentials(MakeGeocodeRequest);
        }

        function MakeGeocodeRequest(credentials) {

            var geocodeRequest = "http://dev.virtualearth.net/REST/v1/Locations?query=" + encodeURI(propertyAddress) + "&output=json&jsonp=GeocodeCallback&key=" + credentials;
            //alert(geocodeRequest);
            CallRestService(geocodeRequest);
        }

        function GeocodeCallback(result) {
            //alert("Found location: " + result.resourceSets[0].resources[0].name);

            if (result &&
                   result.resourceSets &&
                   result.resourceSets.length > 0 &&
                   result.resourceSets[0].resources &&
                   result.resourceSets[0].resources.length > 0) {
                // Set the map view using the returned bounding box
                var bbox = result.resourceSets[0].resources[0].bbox;
                var viewBoundaries = Microsoft.Maps.LocationRect.fromLocations(new Microsoft.Maps.Location(bbox[0], bbox[1]), new Microsoft.Maps.Location(bbox[2], bbox[3]));
                map.setView({ bounds: viewBoundaries });

                // Add a pushpin at the found location
                var location = new Microsoft.Maps.Location(result.resourceSets[0].resources[0].point.coordinates[0], result.resourceSets[0].resources[0].point.coordinates[1]);
                var pushpin = new Microsoft.Maps.Pushpin(location);
                map.entities.push(pushpin);

                map.setView({ center: location, zoom: 18 });
            }
        }

        function CallRestService(request) {
            var script = document.createElement("script");
            script.setAttribute("type", "text/javascript");
            script.setAttribute("src", request);
            document.body.appendChild(script);
        }


    </script>
</head>
<body onload="GetMap();">
    <div id='mapDiv'></div>
</body>
</html>
