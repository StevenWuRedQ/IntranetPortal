<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="MapsPopup.ascx.vb" Inherits="IntranetPortal.MapsPopup" %>
<script>

    function ShowPropertyMap(propBBLE) {
        tmpBBLE = propBBLE;
        if (propBBLE != null) {

            if (getAddressCallback.InCallback()) {
                alert("Server is busy, try later!");
            }
            else {
                var url = "/StreetView.aspx"
                ASPxPopupMapControl.SetContentUrl(url);
                //var streetViewFrm = "streetViewFrm";
                var iframe = ASPxPopupMapControl.GetContentIFrame();
                if (iframe.src == "") {
                    ASPxPopupMapControl.SetContentUrl(url);
                    iframe.onload = function () {
                        getAddressCallback.PerformCallback(propBBLE);
                    };
                } else {
                    getAddressCallback.PerformCallback(propBBLE);
                }
            }
        }
    }

    var tempAddress = null;
    function OnGetAddressCallbackComplete(s, e) {

        if (e.result == null) {
            alert("Property Address is empty!");
            return;
        }

        tempAddress = e.result.split("|")[0];

        $('#leads_address_popup').html(tempAddress + "(" + e.result.split("|")[1] + ")");
        //var streetViewFrm = "streetViewFrm";
        var streenViewWinFrm = ASPxPopupMapControl.GetContentIFrame(); //document.getElementById(streetViewFrm);

        var streenViewWin = (streenViewWinFrm.contentWindow || streenViewWinFrm.contentDocument);


        if (streenViewWin != null) {
            //alert(streenViewWin);
            if (streenViewWin.showAddress) {
                //alert(streenViewWin);
                streenViewWin.showAddress(e.result);
            }
            else {
                //alert(streenViewWin.showAddress)
                setTimeout(function () { OnGetAddressCallbackComplete(s, e); }, 1000);
            }
        }

        ASPxPopupMapControl.Show();
    }

    function popupControlMapTabClick(index) {
        $("#leads_address_popup").css("display", index == 4 ? "inherit" : "none");
        if (index == 0) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var url = "/StreetView.aspx";
                    SetPopupControlMapURL(url);
                }
            }
        }

        if (index == 1) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var url = "/StreetView.aspx?t=map";
                    SetPopupControlMapURL(url);
                }
            }
        }

        if (index == 2) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var url = "/BingViewMap.aspx";
                    SetPopupControlMapURL(url);
                }
            }
        }

        if (index == 3) {
            if (tmpBBLE != null) {
                var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + tmpBBLE;

                var iframe = ASPxPopupMapControl.GetContentIFrame();
                iframe.onload = function () { };
                ASPxPopupMapControl.SetContentUrl(url);
            }
        }

        if (index == 4) {
            if (tmpBBLE != null) {
                var url = "http://gis.nyc.gov/doitt/nycitymap/template?applicationName=ZOLA";

                var iframe = ASPxPopupMapControl.GetContentIFrame();
                iframe.onload = function () { };
                ASPxPopupMapControl.SetContentUrl(url);
            }
        }

    }

    function SetPopupControlMapURL(url) {
        var iframe = ASPxPopupMapControl.GetContentIFrame(); //document.getElementById(streetViewFrm);
        if (ASPxPopupMapControl.GetContentUrl() != url) {
            ASPxPopupMapControl.SetContentUrl(url);
            iframe.onload = function () {
                var mapDocument = (iframe.contentWindow || iframe.contentDocument);
                if (mapDocument.showAddress) {
                    mapDocument.showAddress(tempAddress);
                }
            };
        } else {
            getAddressCallback.PerformCallback(tmpBBLE);
        }
    }

    function AdjustPopupSize(popup) {
        if (popup.GetMaximized()) {
            //popup.SetWindowMaximized(false);
            popup.SetMaximized(false);
        }
        else {
            //popup.SetWindowMaximized(true);
            popup.SetMaximized(true);
        }

        popup.AdjustControl();
    }

</script>
<dx:ASPxPopupControl ClientInstanceName="ASPxPopupMapControl" Width="900px" Height="700px"
    ID="ASPxPopupControl1"
    HeaderText="Street View" AutoUpdatePosition="true" Modal="true" ContentUrlIFrameTitle="streetViewFrm"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div style="float: right; position: relative; margin-right: 10px; margin-bottom: -27px; color: #2e2f31">
                <i class="fa fa-expand icon_btn" style="margin-right: 10px" onclick="AdjustPopupSize(ASPxPopupMapControl)"></i>
                <i class="fa fa-times icon_btn" onclick="ASPxPopupMapControl.Hide()"></i>
            </div>
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" style="border: 0px" role="tablist">
                <li class="active"><a href="#streetView" class="popup_tab_text" role="tab" data-toggle="tab" onclick="popupControlMapTabClick(0)">Street View</a></li>
                <li><a href="#mapView" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(1)">Map View</a></li>
                <li><a href="#BingBird" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(2)">Bing Bird</a></li>
                <li><a href="#Oasis" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(3)">Oasis</a></li>
                <li><a href="#ZOLA" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(4)">ZOLA</a></li>
            </ul>

            <!-- Tab panes -->
            <div class="tab-content" style="display: none">
                <div class="tab-pane active" id="streetView">streetView</div>
                <div class="tab-pane" id="mapView">mapView</div>
                <div class="tab-pane" id="BingBird">BingBird</div>
                <div class="tab-pane" id="Oasis">Oasis</div>
                <div class="tab-pane" id="ZOLA">ZOLA</div>
            </div>
            <div style="width: 100%; text-align: center; display: none" id="leads_address_popup"></div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
<dx:ASPxCallback runat="server" ClientInstanceName="getAddressCallback" ID="getAddressCallback" OnCallback="getAddressCallback_Callback">
    <ClientSideEvents CallbackComplete="OnGetAddressCallbackComplete" />
</dx:ASPxCallback>