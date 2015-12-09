<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MapTest.aspx.vb" Inherits="IntranetPortal.MapTest" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Draggable directions</title>
    <style>
        html, body, #map-canvas {
            height: 100%;
            margin: 0px;
            padding: 0px;
        }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
    <script src="/bower_components/protyotypejs/prototype.min.js"></script>
    <script>

        var rendererOptions = {
            draggable: true
        };
        var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);;
        var directionsService = new google.maps.DirectionsService();
        var map;

        var australia = new google.maps.LatLng(-25.274398, 133.775136);

        function initialize() {

            var mapOptions = {
                zoom: 7,
                center: australia
            };
            map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
            directionsDisplay.setMap(map);
            directionsDisplay.setPanel(document.getElementById('directionsPanel'));

            google.maps.event.addListener(directionsDisplay, 'directions_changed', function () {
                computeTotalDistance(directionsDisplay.getDirections());
            });

            calcRoute();
        }

        function calcRoute() {
            var originAdd = null;
            var waypointsAdd = [];
            var destinationAdd = null;

            var tableObj = document.getElementById("target_table");
                   
            if (tableObj.rows.length > 1)
            {              
                originAdd = tableObj.rows[1].cells[1].innerHTML;
                               
                for (var i=2; i<tableObj.rows.length-1; i++)
                {             
                    var loc = tableObj.rows[i].cells[1].innerHTML;
                    waypointsAdd.push({location:loc});
                }

                destinationAdd = tableObj.rows[tableObj.rows.length - 1].cells[1].innerHTML;
            }                

            var request = {
                //origin: 'Westbury, NY',
                //destination: 'Woodhaven, NY',
                //waypoints: [{ location: 'Jamaica, NY' }, { location: 'Flushing, NY' }],

                origin: originAdd,
                destination: destinationAdd,
                waypoints:waypointsAdd,
                travelMode: google.maps.TravelMode.DRIVING
            };
            directionsService.route(request, function (response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    directionsDisplay.setDirections(response);
                }
            });
        }

        function computeTotalDistance(result) {
            var total = 0;
            var myroute = result.routes[0];
            for (var i = 0; i < myroute.legs.length; i++) {
                total += myroute.legs[i].distance.value;
            }
            total = total / 1000.0;
            document.getElementById('total').innerHTML = total + ' km';
        }

        google.maps.event.addDomListener(window, 'load', initialize);

      
        //move a row up and down a table
        //available dir option: 'up', 'down'
        //row_num_column is the column of the row number, starts with 1
        function move_row(selected_row, dir, row_num_column) {
            var siblings;
            var pos_pair = [];

            if (dir == 'up')
                siblings = selected_row.previousSiblings();
            else if (dir == 'down')
                siblings = selected_row.nextSiblings();

            if (siblings.size() > 0) {
                var sibling = siblings.first();

                //swop row number
                row_num_column -= 1;
                var selected_pos = selected_row.childElements()[row_num_column].innerHTML;
                var target_pos = sibling.childElements()[row_num_column].innerHTML;
                pos_pair = [selected_pos, target_pos]

                sibling.childElements()[row_num_column].innerHTML = selected_pos;
                selected_row.childElements()[row_num_column].innerHTML = target_pos;


                if (dir == 'up')
                    sibling.insert({ 'before': selected_row });
                else
                    sibling.insert({ 'after': selected_row });

            }

            calcRoute();
            return pos_pair;
        }

        function get_selected_row() {
            var selected_row = null;
            $$('#target_table tr').each(function (row) {
                if (row.hasClassName('selected')) {
                    selected_row = row;
                    throw $break;
                }
            });
            return selected_row;
        }

        var currentRow = null;
        function MouseOver(row) {
            row.bgColor = "red";
            currentRow = row;
        }

        function MouseOut(row) {
            row.bgColor = "white";
            currentRow = null;
        }

    </script>
</head>
<body>

    <table style="width: 1200px; height: 100%">
        <tr>
            <td style="width: 200px; background-color: #efefef; vertical-align: top;">
                <form runat="server" id="form1">                   
                    <table id="target_table" width="100%">
                        <thead>
                            <tr>
                                <td>No</td>
                                <td>Address</td>
                                <td>Action</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr onmouseover="MouseOver(this)" onmouseout="MouseOut(this)">
                                <td>1</td>
                                <td>Westbury, NY</td>
                                <td><a href="#" onclick="move_row(currentRow, 'up', 1)">UP</a><a href="#" onclick="move_row(currentRow, 'down', 1)">Down</a></td>
                            </tr>
                            <tr onmouseover="MouseOver(this)" onmouseout="MouseOut(this)">
                                <td>2</td>
                                <td>Flushing, NY</td>
                                <td><a href="#" onclick="move_row(currentRow, 'up', 1)">UP</a><a href="#" onclick="move_row(currentRow, 'down', 1)">Down</a></td>
                            </tr>
                            <tr onmouseover="MouseOver(this)" onmouseout="MouseOut(this)">
                                <td>3</td>
                                <td>Woodhaven, NY</td>
                                <td><a href="#" onclick="move_row(currentRow, 'up', 1)">UP</a><a href="#" onclick="move_row(currentRow, 'down', 1)">Down</a></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </td>
            <td style="width: 700px;">
                <div id="map-canvas" style="float: left; width: 100%; height: 100%"></div>
            </td>
            <td style="width: 200px">
                <div id="directionsPanel" style="float: right; width: 100%; height:100%">
                    <p>Total Distance: <span id="total"></span></p>
                </div>
            </td>
        </tr>
    </table>

</body>
</html>
