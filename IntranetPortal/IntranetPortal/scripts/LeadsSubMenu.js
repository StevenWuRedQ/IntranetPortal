var tmpBBLE = null;
function ShowCateMenu(s, bble) {
    ASPxPopupMenuCategory.Hide();
    tmpBBLE = bble;
    s.getBoundingClientRect();
   
    
    ASPxPopupMenuCategory.ShowAtElement(s);
    var popmenu = document.getElementById("UserSummary_LeadsSubMenu_popupMenuLeads");
    var pop_postion = popmenu.getBoundingClientRect();
    var target_top = s.getBoundingClientRect().bottom;
    var pop_content = document.getElementById('UserSummary_LeadsSubMenu_popupMenuLeads_DXME_');
    if (pop_postion.top < target_top)
    {
        popmenu.style.top = target_top + 5;
        pop_content.className = pop_content.className + " dxm-popup-bottom";
        //alert(pop_postion.top+','+ target_top+' >>>here change to the arrow down and fix the postion ');
    }
    else {
        pop_content.className = "dxm-popupMain dxm-popup fix_pop_postion_s";
    }
     
   
  
}

function PopupControlMapTabChange(s, e) {
    if (e.tab.index == 0) {
        if (tmpBBLE != null) {
            if (getAddressCallback.InCallback()) {
                alert("Server is busy, try later!");
            }
            else {
                var streetViewFrm = "streetViewFrm";

                var iframe = document.getElementById(streetViewFrm);
                if (iframe.src != "/StreetView.aspx") {
                    iframe.src = "/StreetView.aspx";
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
        }
    }

    if (e.tab.index == 1) {
        if (tmpBBLE != null) {
            if (getAddressCallback.InCallback()) {
                alert("Server is busy, try later!");
            }
            else {
                var streetViewFrm = "streetViewFrm";

                var iframe = document.getElementById(streetViewFrm);
                if (iframe.src != "/StreetView.aspx?t=map") {
                    iframe.src = "/StreetView.aspx?t=map";
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
        }
    }

    if (e.tab.index == 2) {
        if (tmpBBLE != null) {
            if (getAddressCallback.InCallback()) {
                alert("Server is busy, try later!");
            }
            else {
                var streetViewFrm = "streetViewFrm";

                var iframe = document.getElementById(streetViewFrm);
                if (iframe.src != "/BingViewMap.aspx") {
                    iframe.src = "/BingViewMap.aspx";
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
        }
    }
}

function OnLeadsCategoryClick(s, e) {
    if (tmpBBLE != null) {
        if (e.item.index == 0) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var streetViewFrm = "streetViewFrm";
                    if (ASPxPopupMapControl.GetHeaderText() != e.item.GetText()) {
                        document.getElementById(streetViewFrm).src = "/StreetView.aspx";
                        ASPxPopupMapControl.SetHeaderText(e.item.GetText());
                    }
                    getAddressCallback.PerformCallback(tmpBBLE);
                }
            }

            e.item.SetChecked(false);
            return;
        }

        if (e.item.name == "Priority") {
            SetLeadStatus('5' + '|' + tmpBBLE);
        }

        if (e.item.name == "DoorKnock")
            SetLeadStatus('4' + '|' + tmpBBLE);

        if (e.item.name == "Callback")
            SetLeadStatus('Tomorrow' + '|' + tmpBBLE);

        if (e.item.name == "DeadLead")
            SetLeadStatus('6' + '|' + tmpBBLE);

        if (e.item.name == "InProcess")
            SetLeadStatus('7' + '|' + tmpBBLE)

        if (e.item.name == "Closed")
            SetLeadStatus('8' + '|' + tmpBBLE)

        if (e.item.name == "ViewLead") {
            var url = '/ViewLeadsInfo.aspx?id=' + tmpBBLE;
            window.showModalDialog(url, 'View Leads Info', 'dialogWidth:1350px;dialogHeight:810px');
        }

        if (e.item.name == "Delete") {
            SetLeadStatus('11' + '|' + tmpBBLE)
        }


        if (e.item.name == "Reassign") {
            popupCtrReassignEmployeeListCtr.ShowAtElement(s.GetMainElement());
        }

        if (e.item.name == "Upload") {
            var url = '/UploadFilePage.aspx?b=' + tmpBBLE;
            window.showModalDialog(url, 'Upload Files', 'dialogWidth:640px;dialogHeight:400px');
        }
    }

    e.item.SetChecked(false);
}

function SetLeadStatus(status) {
    if (leadStatusCallbackClient.InCallback()) {
        alert("Server is busy! Please wait!")
    } else {
        leadStatusCallbackClient.PerformCallback(status);
    }
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
    tempAddress = e.result;
    var streetViewFrm = "streetViewFrm";
    var streenViewWinFrm = document.getElementById(streetViewFrm);
    var streenViewWin = (streenViewWinFrm.contentWindow || streenViewWinFrm.contentDocument);

    if (streenViewWin != null) {
        if (streenViewWin.showAddress) {
            streenViewWin.showAddress(e.result);
        }
        else {
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
}

function NavigateURL(type, bble) {
    window.location.href = "/LeadAgent.aspx?c=" + type + "&id=" + bble;
}
