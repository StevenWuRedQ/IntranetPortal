<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DoorKnockMap.ascx.vb" Inherits="IntranetPortal.DoorKnockMap" %>
<style>
    #map-canvas {
        height: 100%;
        margin: 0px;
        padding: 0px;
    }

    #mapContent {
        font-family: Tahoma;
        font-size: 12px;
    }
</style>
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
<script src="scripts/prototype.js" type="text/javascript"></script>
<script>

    var rendererOptions = {
        draggable: true
    };
    var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);;
    var directionsService = new google.maps.DirectionsService();
    var map;

    var newyork = new google.maps.LatLng(40.714623, -74.006605);

    function initialize() {

        var mapOptions = {
            zoom: 7,
            center: newyork
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

        if (tableObj.rows.length > 1) {
            //originAdd = tableObj.rows[1].cells[1].innerHTML;
            originAdd = originPoint.GetText(); //document.getElementById("originPoint").value;

            if (originAdd == "") {
                alert("Please input start point address!");
                return;
            }

            for (var i = 2; i < tableObj.rows.length - 1; i++) {
                var loc = tableObj.rows[i].cells[1].innerHTML;
                waypointsAdd.push({ location: loc });
            }

            destinationAdd = tableObj.rows[tableObj.rows.length - 1].cells[1].innerHTML;
        }
        else
            return;


        var request = {
            //origin: 'Westbury, NY',
            //destination: 'Woodhaven, NY',
            //waypoints: [{ location: 'Jamaica, NY' }, { location: 'Flushing, NY' }],

            origin: originAdd,
            destination: destinationAdd,
            waypoints: waypointsAdd,
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
        total = total / 1609.34;
        total = Math.round(total * 100) / 100;
        document.getElementById('total').innerHTML = total + ' miles';
    }

    //var mapContent = document.getElementById("mapContent");
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
    function OnAddressMouseOver(row) {
        row.bgColor = "#D1DEFB";
        row.cells[2].style.visibility = "visible";
        currentRow = row;
    }

    function OnAddressMouseOut(row) {
        row.bgColor = "white";
        row.cells[2].style.visibility = "hidden";
        currentRow = null;
    }

    var currentBBLE = null;
    window.AddAddress = function (bble) {
        if (GetAddressCallback.InCallback())
            alert("Server is busy now, Please try later.");
        else {
            currentBBLE = bble;
            GetAddressCallback.PerformCallback(bble);
        }
    }

    window.RemoveAddress = function (bble) {
        var tableObj = document.getElementById("target_table");

        var row = [];

        for (var i = 1; i < tableObj.rows.length; i++) {
            var cell = tableObj.rows[i].cells[3];

            if (cell.innerHTML == bble) {
                tableObj.deleteRow(i);
                i = i - 1;
                //row.push(i);
            }
        }

        //if (row != null && row.length > 0)
        //{
        //    for (var i = 0; i < row.length; i++)
        //        tableObj.deleteRow(row[i]);
        //}

        if (tableObj.rows.length > 1) {
            for (var i = 1; i < tableObj.rows.length; i++) {
                tableObj.rows[i].cells[0].innerHTML = i;
            }
        }        
        calcRoute();
    }

    var saveAddress = false;
    function OnGetAddressComplete(s, e) {     

        var address = e.result;

        if (address == "" || address == null) {
            alert("The Address is empty, please check.");
            return;
        }

        var adds = address.split("|");
        if (adds.length == 1) {
            AddAddressToTable(adds[0]);
            calcRoute();
        }
        else {
                listboxAddressClient.BeginUpdate();
                listboxAddressClient.ClearItems();
            for (var i = 0; i < adds.length; i++) {
                listboxAddressClient.AddItem(adds[i]);              
            }
            listboxAddressClient.EndUpdate();
            popupSelectDoornockAddress.Show();
        }    
    }

    function AddSelectedAddress()
    {
        var items = listboxAddressClient.GetSelectedItems();
        for(var i=0; i<items.length;i++)
        {
            AddAddressToTable(items[i].text);
        }

        calcRoute();
    }

    function AddAddressToTable(address) {

        if (address == "" || address == null) {
            alert("The Address is empty, please check.");
            return;
        }

        var table = document.getElementById("target_table");

        // Create an empty <tr> element and add it to the 1st position of the table:
        var row = table.insertRow(table.rows.length);
        row.onmouseover = function () { OnAddressMouseOver(this) };
        row.onmouseout = function () { OnAddressMouseOut(this) };

        // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var cell4 = row.insertCell(3);

        // Add some text to the new cells:
        cell1.innerHTML = table.rows.length - 1;
        cell2.innerHTML = address;
        cell3.innerHTML = "<a href=\"#\" onclick=\"move_row(currentRow, 'up', 1)\"><img src=\"/images/Arrows-Up-icon.png\" width='16px' height='16px'></a><a href=\"#\" onclick=\"move_row(currentRow, 'down', 1)\"><img src=\"/images/Arrows-Down-icon.png\" width='16px' height='16px'></a>";
        cell3.style.visibility = "hidden";
        cell4.innerHTML = currentBBLE;
        cell4.hidden = "hidden";
    }

    function SetOriginPoint() {
    
        var data = 'OriginPoint|' + originPoint.GetText();
        SaveAddressCallback.PerformCallback(data);
        //document.cookie = 'OriginPoint=' + originPoint.GetText() + ';';
        calcRoute();
    }

</script>
<div style="position: relative; width: 100%; height: 100%" id="mapContent">
    <div style="width: 350px; position: absolute; z-index: 20; margin-top: 10px; margin-left: 80px; background-color: white;">
        <table id="target_table" style="width: 100%; font-size: 12px; border-spacing: 0px; border-collapse: collapse; line-height: 24px;">
            <thead>
                <tr style="font-weight: bold; background-color: #efefef;">
                    <td style="width: 25px">No.</td>
                    <td>Address</td>
                    <td style="width: 40px; visibility: visible;"></td>
                    <td hidden="hidden">BBLE</td>
                </tr>
            </thead>
            <tr>
                <td>1</td>
                <td>
                    <dx:ASPxTextBox runat="server" ID="txtOriginPoint" ClientInstanceName="originPoint" Width="100%" Text=""></dx:ASPxTextBox>
                </td>
                <td style="vertical-align: middle">
                    <dx:ASPxButton runat="server" RenderMode="Button" Image-Height="16px" Text="Set" Image-Width="16px" AutoPostBack="false">
                        <FocusRectPaddings PaddingLeft="2" PaddingRight="2" PaddingBottom="0" PaddingTop="0" />
                        <ClientSideEvents Click="function() {SetOriginPoint();}" />
                    </dx:ASPxButton>
                </td>
                <td hidden="hidden"></td>
            </tr>
            <tbody>
            </tbody>
        </table>
    </div>
    <div style="float: left; width: 1000px; display: block; height: 100%;">
        <div id="map-canvas" style="height: 100%; width: 100%;"></div>
    </div>
    <div id="directionsPanel" style="float: left; width: 300px; height: 100%; right: 0px; overflow: auto; z-index: 999; padding:5px">
        <table style="">
            <tr>
                <td style="width: 160px;">Total Distance: <span id="total"></span></td>
                <td>
                    <dx:ASPxButton runat="server" RenderMode="Button"  Text="Print" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                       
                        <ClientSideEvents Click="function(){window.print();}" />
                      
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>

    </div>
</div>
<dx:ASPxCallback runat="server" ClientInstanceName="GetAddressCallback" ID="callbackGetAddress" OnCallback="callbackGetAddress_Callback">
    <ClientSideEvents CallbackComplete="OnGetAddressComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ClientInstanceName="SaveAddressCallback" ID="ASPxCallback1" OnCallback="callbackGetAddress_Callback">    
</dx:ASPxCallback>
<dx:ASPxPopupControl ClientInstanceName="popupSelectDoornockAddress" Width="300px" Height="300px"
    MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl2"
    HeaderText="Select Address" AutoUpdatePosition="true" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
    runat="server">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            <dx:ASPxListBox runat="server" ID="listboxAddress" ClientInstanceName="listboxAddressClient" Height="270" Width="100%" SelectionMode="CheckColumn">
            </dx:ASPxListBox>
            <dx:ASPxButton Text="Ok" runat="server" ID="btnOk" AutoPostBack="false">
                <ClientSideEvents Click="function(s,e){      
                                            AddSelectedAddress();   
                                            popupSelectDoornockAddress.Hide();                             
                                        }" />
            </dx:ASPxButton>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
