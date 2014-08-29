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
    if (Math.ceil(pop_postion.top) < Math.ceil(target_top))
    {        
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
    if (tmpBBLE != null) {
       
        if (e.item.index == 0) {
            ShowPropertyMap(tmpBBLE);
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
            window.showModalDialog(url, 'View Leads Info', 'dialogWidth:1350px;dialogHeight:930px');
        }

        if (e.item.name == "Delete") {
            SetLeadStatus('11' + '|' + tmpBBLE)
        }

        if (e.item.name == "Shared") {
            var url = '/PopupControl/ShareLeads.aspx?bble=' + tmpBBLE;
            AspxPopupShareleadClient.SetContentUrl(url);
            AspxPopupShareleadClient.Show();
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
