var tmpBBLE = null;
function ShowCateMenu(s, bble) {
    ASPxPopupMenuCategory.Hide();
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

function popupControlMapTabClick(index) {
    $("#leads_address_popup").css("display", index == 4 ? "inherit" : "none");
    if (index == 0) {
        if (tmpBBLE != null) {
            if (getAddressCallback.InCallback()) {
                alert("Server is busy, try later!");
            }
            else {
                var url = "/StreetView.aspx"
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
    if (index == 5) {

        if (tmpBBLE != null) {
            var url = "https://maps.googleapis.com/maps/api/streetview?size=800x600&location=" + encodeURIComponent(tempAddress);

            var iframe = ASPxPopupMapControl.GetContentIFrame();
            iframe.onload = function () { };
            ASPxPopupMapControl.SetContentHtml('<img style="width:100%;height:600px" src="' + url + '"></img>');
        }
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

function OnLeadsCategoryClick(s, e) {

    var idx = e.item.index;
    if (tmpBBLE != null) {

        if (e.item.index == 0) {
            ShowPropertyMap(tmpBBLE);
        }

        if (e.item.name == "Priority") {
            SetLeadStatus('5' + '|' + tmpBBLE);
        }

        if (e.item.name == 'LoanMod') {
            SetLeadStatus('x' + '|' + 'LoanMod' + '|' + '20' + '|' + tmpBBLE);
        }

        if (e.item.name == 'Warmer') {
            SetLeadStatus('x' + '|' + 'Warmer' + '|' + '21' + '|' + tmpBBLE);
        }

        if (e.item.name == "DoorKnock")
            SetLeadStatus('4' + '|' + tmpBBLE);

        if (e.item.name == "Callback")
            SetLeadStatus('Tomorrow' + '|' + tmpBBLE);

        if (e.item.name == "DeadLead") {
            ShowDeadLeadsPopup(tmpBBLE);
        }

        if (e.item.name == "InProcess") {
            //SetLeadStatus('7' + '|' + tmpBBLE);
            ShowInProcessPopup(tmpBBLE);
        }

        if (e.item.name == "Closed")
            SetLeadStatus('8' + '|' + tmpBBLE)

        if (e.item.name == "ViewLead") {
            var url = '/ViewLeadsInfo.aspx?id=' + tmpBBLE;
            var left = (screen.width / 2) - (1350 / 2);
            var top = (screen.height / 2) - (930 / 2);
            window.open(url, 'View Leads Info ' + tmpBBLE, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
            //window.open(url, 'View Leads Info', 'Width=1350px,Height=930px');
        }

        //if (e.item.name == "Shared") {
        //    var url = '/PopupControl/ShareLeads.aspx?bble=' + leadsInfoBBLE;
        //    AspxPopupShareleadClient.SetContentUrl(url);
        //    AspxPopupShareleadClient.Show();
        //}

        if (e.item.name == "Shared") {
            var url = '/PopupControl/ShareLeads.aspx?bble=' + tmpBBLE;
            AspxPopupShareleadClient.SetContentUrl(url);
            AspxPopupShareleadClient.Show();
        }

        if (e.item.name == "Reassign") {
            popupCtrReassignEmployeeListCtr.PerformCallback();
            popupCtrReassignEmployeeListCtr.ShowAtElement(s.GetMainElement());
        }

        if (e.item.name == "Upload") {
            var url = '/UploadFilePage.aspx?b=' + tmpBBLE;
            //var centerLeft = parseInt((window.screen.availWidth - 640) / 2);
            //var centerTop = parseInt(((window.screen.availHeight - 400) / 2) - 50);          
            if (popupCtrUploadFiles) {
                popupCtrUploadFiles.SetContentUrl(url);
                popupCtrUploadFiles.Show();
            }
            else
                window.open(url, 'Upload Files', popup_params(640, 400)); //'Width=640px,Height=400px,top=' + centerTop + ",left=" + centerLeft);            
        }

        if (e.item.name == "ViewFiles") {
            if (popupViewFiles) {
                popupViewFiles.Show();
                popupViewFiles.PerformCallback("Show|" + tmpBBLE)
            }
            else
                alert("No View files");
        }
    }

    e.item.SetChecked(false);
}

var popupShow = true;
function ShowDeadLeadsPopup(tmpBBLE) {
    popupShow = true;
    aspxPopupDeadLeadsClient.PerformCallback("Show|" + tmpBBLE);
}

function ShowInProcessPopup(tmpBBLE) {
    popupShow = true;
    aspxPopupInprocessClient.PerformCallback("Show|" + tmpBBLE);
}

function popup_params(width, height) {
    var a = typeof window.screenX != 'undefined' ? window.screenX : window.screenLeft;
    var i = typeof window.screenY != 'undefined' ? window.screenY : window.screenTop;
    var g = typeof window.outerWidth != 'undefined' ? window.outerWidth : document.documentElement.clientWidth;
    var f = typeof window.outerHeight != 'undefined' ? window.outerHeight : (document.documentElement.clientHeight - 22);
    var h = (a < 0) ? window.screen.width + a : a;
    var left = parseInt(h + ((g - width) / 2), 10);
    var top = parseInt(i + ((f - height) / 2.5), 10);
    return 'width=' + width + ',height=' + height + ',left=' + left + ',top=' + top + ',scrollbars=1';
}
var SEND_STATUS = null;

function SetLeadStatus(status) {
    ChangeStatusResonTextClient.SetText("");
    if (leadStatusCallbackClient.InCallback()) {
        alert("Server is busy! Please wait!")
    } else {

        SEND_STATUS = status;
        aspxPopupChangeLeadsStatusClient.Show();

        // show up substatus selection for loan mod
        if (status.startsWith("x|LoanMod|20")) {
            if (panel_LoanModSubStatus) {
                //debugger;
                panel_LoanModSubStatus.SetVisible(true);
            }
        } else {
            if (panel_LoanModSubStatus) {

                panel_LoanModSubStatus.SetVisible(false);
            }
            //leadStatusCallbackClient.PerformCallback(status);
        }
    }
}

function CofrimLeadStatusChange() {
    debugger;
    var comments = ChangeStatusResonTextClient.GetText();
    var loanModSubStatus = "";

    if (panel_LoanModSubStatus && panel_LoanModSubStatus.clientVisible) {
        loanModSubStatus = String(radios_LoanModSubStatus.GetSelectedIndex().toString());
    }


    if (!comments) {
        alert("The reason can not be empty please make sure you input change reason !");
        return;
    }
    if (SEND_STATUS) {
        var sendData = SEND_STATUS + "|" + comments;
        debugger;
        if (loanModSubStatus != "") {
            sendData += "|" + loanModSubStatus;
        }
        leadStatusCallbackClient.PerformCallback(sendData);

    } else {
        alert("Cofrim LeadStatus Change faled SEND_STATUS is null");
    }
    aspxPopupChangeLeadsStatusClient.Hide();
}
function OnGetAddressCallbackError(s, e) {
    alert(e.message);
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
            streenViewWin.showAddress(tempAddress);
        }
        else {
            //alert(streenViewWin.showAddress)
            setTimeout(function () { OnGetAddressCallbackComplete(s, e); }, 1000);
        }
    }

    ASPxPopupMapControl.Show();
}

function OnSetStatusComplete(s, e) {
    if (typeof gridPriorityClient != "undefined")
        gridPriorityClient.Refresh();

    if (typeof gridAppointmentClient != "undefined")
        gridAppointmentClient.Refresh();

    if (typeof gridTaskClient != "undefined")
        gridTaskClient.Refresh();

    if (typeof gridCallbackClient != "undefined")
        gridCallbackClient.Refresh();

    if (typeof gridLeads != "undefined")
        gridLeads.Refresh();

    if (typeof gridTrackingClient != "undefined")
        gridTrackingClient.Refresh();
}

function NavigateURL(type, bble) {
    window.location.href = "/LeadAgent.aspx?c=" + type + "&id=" + bble;
}


var isSendRequest = false;

function OnRequestUpdate(bble) {
    isSendRequest = false;
    if (ASPxPopupRequestUpdateControl.InCallback()) {

    }
    else {
        ASPxPopupRequestUpdateControl.SetHeaderText("Request Update - " + bble);
        ASPxPopupRequestUpdateControl.PerformCallback(bble);
    }
}

function OnEndCallbackPanelRequestUpdate(s, e) {
    if (isSendRequest) {
        if (typeof gridLeads != "undefined") {
            gridLeads.CancelEdit();
        }

        //gridLeads.Refresh();
        alert("Request update is send.");
    }
    else {
        s.Show();
    }
}