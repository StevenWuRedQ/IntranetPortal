<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleSubMenu.ascx.vb" Inherits="IntranetPortal.ShortSaleSubMenu" %>
<script type="text/javascript">
    var tmpCaseId = null;
    var tmpBBLE = null;
    function ShowCateMenu(s, caseId, bble) {
        ASPxPopupMenuCategory.Hide();
        tmpCaseId = caseId;
        tmpBBLE = bble;
        s.getBoundingClientRect();

        ASPxPopupMenuCategory.ShowAtElement(s);
        var popmenu = ASPxPopupMenuCategory.GetMainElement();
        var pop_postion = popmenu.getBoundingClientRect();
        var target_top = s.getBoundingClientRect().bottom;
        var pop_content = (popmenu.firstElementChild || popmenu.firstChild);
        if (Math.ceil(pop_postion.top) < Math.ceil(target_top)) {
            popmenu.style.top = target_top + 5;
            pop_content.className = pop_content.className + " dxm-popup-bottom";
            //alert(pop_postion.top+','+ target_top+' >>>here change to the arrow down and fix the postion ');
        }
        else {
            pop_content.className = "dxm-popupMain dxm-popup fix_pop_postion_s";
        }
    }

    function OnMenuItemClick(s, e) {
        e.item.SetChecked(false);
        if (tmpCaseId != null && tmpBBLE != null) {
            if (e.item.index == 0) {
                ShowPropertyMap(tmpBBLE);
            }

            if (e.item.index == 1)
            {
                SaveStatus(e.item.name, tmpCaseId, "NextWeek");
            }

            if (e.item.index > 1 && e.item.index <= 6) {
                SaveStatus(e.item.name, tmpCaseId);
            }

            if (e.item.name == "Reassign")
            {
                popupCtrReassignEmployeeListCtr.PerformCallback();
                popupCtrReassignEmployeeListCtr.ShowAtElement(s.GetMainElement());
            }

            if (e.item.name == "Upload") {
                var url = '/UploadFilePage.aspx?b=' + tmpBBLE;
              
                if (popupCtrUploadFiles) {
                    popupCtrUploadFiles.SetContentUrl(url);
                    popupCtrUploadFiles.Show();
                }
                else
                    window.open(url, 'Upload Files', popup_params(640, 400));
            }
        }
    }

    function LogClick(itemName, objData) {
        SaveStatus(itemName, ShortSaleCaseData.CaseId, objData);
    }

    function SaveStatus(status, caseId, objData) {
        if (caseStatusCallbackClient.InCallback()) {
            alert("Server is busy! Please wait!")
        } else {
            caseStatusCallbackClient.PerformCallback(status + "|" + caseId + "|" + objData);
        }
    }

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

    function OnSetStatusComplete(s, e) {
        if (typeof gridCase == "undefined") {
            //alert("undefined");
        }
        else
            gridCase.Refresh();

        if (typeof gridTrackingClient != "undefined")
            gridTrackingClient.Refresh();
    }
</script>

<dx:ASPxPopupMenu ID="popupMenuLeads" runat="server" ClientInstanceName="ASPxPopupMenuCategory" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="MouseOver" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <Items>
        <dx:MenuItem GroupName="Sort" Text="View Map" Name="GoogleStreet">
            <Image Url="/images/drap_map_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Follow Up" Name="FollowUp" Image-Url="/images/drap_follow_up_icons.png">
            <Image Url="/images/drap_inprocess_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="New File" Name="NewFile" Image-Url="/images/drap_prority_icons.png">
            <Image Url="/images/drop_new_icon.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Active Cases" Name="Active" Image-Url="/images/drap_prority_icons.png">
            <Image Url="/images/drop_active_icon.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Eviction" Name="Eviction" Image-Url="/images/drap_deadlead_icons.png">
            <Image Url="/images/drap_doorknock_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="On Hold" Name="OnHold" Image-Url="/images/drap_inprocess_icons.png">
            <Image Url="/images/drop_on_hold_icon.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Closed" Name="Closed" Image-Url="/images/drap_closed_icons.png">
            <Image Url="/images/drap_closed_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Reassign" Name="Reassign">
            <Image Url="/images/drap_reassign_icon.png"></Image>
        </dx:MenuItem>     
        <dx:MenuItem GroupName="Sort" Text="Upload Docs/Pics" Name="Upload">
            <Image Url="/images/drap_upload_icons.png"></Image>
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnMenuItemClick" />
    <ItemStyle Height="30px"></ItemStyle>
</dx:ASPxPopupMenu>
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

<dx:ASPxPopupControl ClientInstanceName="popupCtrReassignEmployeeListCtr" Width="300px" Height="300px"
    MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
    HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
    runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentReAssign">
            <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270"
                SelectedIndex="0" Width="100%">
            </dx:ASPxListBox>
            <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                <ClientSideEvents Click="function(s,e){
                                        var item = listboxEmployeeClient.GetSelectedItem();
                                        if(item == null)
                                        {
                                             alert('Please select employee.');
                                             return;
                                         }
                                        popupCtrReassignEmployeeListCtr.PerformCallback(tmpBBLE + '|' + item.text);
                                        popupCtrReassignEmployeeListCtr.Hide();   
                                        OnSetStatusComplete(s,e);                    
                                        }" />
            </dx:ASPxButton>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>

<dx:ASPxCallback runat="server" ClientInstanceName="getAddressCallback" ID="getAddressCallback" OnCallback="getAddressCallback_Callback">
    <ClientSideEvents CallbackComplete="OnGetAddressCallbackComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback ID="statusCallback" runat="server" ClientInstanceName="caseStatusCallbackClient" OnCallback="statusCallback_Callback">
    <ClientSideEvents CallbackComplete="OnSetStatusComplete" />
</dx:ASPxCallback>
<dx:ASPxPopupControl ClientInstanceName="popupCtrUploadFiles" Width="950px" Height="840px" ID="ASPxPopupControl2"
    HeaderText="Upload Files" AutoUpdatePosition="true" Modal="true" CloseAction="CloseButton"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
