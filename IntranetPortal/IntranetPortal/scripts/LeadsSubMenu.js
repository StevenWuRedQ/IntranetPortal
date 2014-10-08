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
            window.open(url, 'View Leads Info', 'Width=1350px,Height=930px');
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
            popupCtrReassignEmployeeListCtr.PerformCallback();
            popupCtrReassignEmployeeListCtr.ShowAtElement(s.GetMainElement());
        }

        if (e.item.name == "Upload") {
            var url = '/UploadFilePage.aspx?b=' + tmpBBLE;
            //var centerLeft = parseInt((window.screen.availWidth - 640) / 2);
            //var centerTop = parseInt(((window.screen.availHeight - 400) / 2) - 50);          
            if (popupCtrUploadFiles)
            {
                popupCtrUploadFiles.SetContentUrl(url);
                popupCtrUploadFiles.Show();
            }
            else
                window.open(url, 'Upload Files', popup_params(640, 400)); //'Width=640px,Height=400px,top=' + centerTop + ",left=" + centerLeft);            
        }
    }

    e.item.SetChecked(false);
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
   
    tempAddress = e.result.split("|")[0];

    $('#leads_address_popup').html(tempAddress + "(" + e.result.split("|")[1]+")");
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
