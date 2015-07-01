var EnableClientRefresh = true;
var EnablePopupMsg = true;
var callIntervalTime = 10000;

function init() {
    if (EnableClientRefresh) {
        RefreshLeadsCount();
    }

    if (EnablePopupMsg) {
        AwayMsg();
    }
}

function RefreshLeadsCount() {

    var url = 'RefreshLeadsCountHandler.ashx';
    var request = getRequestObject();

    request.onreadystatechange = function () {
        try {
            if (request.readyState == 4) {
                if (request.status == 200) {
                    var leadsCounts = null;
                    if (request.responseText != "") {
                        leadsCounts = eval("(" + request.responseText + ")");
                        //alert(msg);
                        if (leadsCounts != null) {
                            for (var i = 0; i < leadsCounts.length; i++) {
                                var item = leadsCounts[i];
                                
                                if (item.Count > 0) {

                                    if (item.Name == "SpanAmount_MyTask") {
                                        var count = parseInt(document.getElementById(item.Name).innerText);
                                        if (item.Count > count) {
                                            NewTask();
                                        }
                                        document.getElementById("SpanAmount_TotalTask").innerText = item.Count;
                                    }

                                    document.getElementById(item.Name).innerText = item.Count;
                                }
                                else
                                    document.getElementById(item.Name).innerText = "";


                            }
                        }
                    }

                    window.setTimeout(function () { RefreshLeadsCount(); }, callIntervalTime);
                }
                else {
                    document.getElementById('errorMsg').innerHTML +=
                              request.responseText + '< br />';
                    window.setTimeout(function () { RefreshLeadsCount(); }, callIntervalTime);
                }
            }
        }
        catch (e) {
            document.getElementById('errorMsg').innerHTML = "Error: " + e.message;
        }
    };
    request.open('POST', url, true);
    request.send(null);
}

function AwayMsg() {
    var url = 'WhileImAwayMessagerHandler.ashx';
    var request = getRequestObject();

    request.onreadystatechange = function () {
        try {
            if (request.readyState == 4) {
                if (request.status == 200) {
                    if (request.responseText != "") {
                        if (request.responseText != null) {
                            if (!ASPxPopupAwayControlClient.GetVisible()) {
                                ASPxPopupAwayControlClient.SetContentUrl("/PopupControl/WhileAwayMsgs.aspx");
                                ASPxPopupAwayControlClient.Show();
                            }
                        }
                    }
                    else
                        window.setTimeout(function () { hook(); }, callIntervalTime);
                }
                else {
                    document.getElementById('errorMsg').innerHTML +=
                              request.responseText + '< br />';
                }
            }
        }
        catch (e) {
            document.getElementById('errorMsg').innerHTML = "Error: " + e.message;
        }
    };
    request.open('POST', url, true);
    request.send(null);
}


var currentMsgId = null;
var popupBBLE = null;
function hook() {
    var url = 'MessagerAsyncHandler.ashx';
    var request = getRequestObject();

    request.onreadystatechange = function () {
        try {
            if (request.readyState == 4) {
                if (request.status == 200) {
                    var msg = null;
                    if (request.responseText != "") {
                        msg = eval("(" + request.responseText + ")");
                        //alert(msg);
                        if (msg != null) {
                            currentMsgId = msg.MsgID;
                            popupBBLE = msg.BBLE;
                            document.getElementById('tdMsgTitle').innerHTML = msg.Title;
                            document.getElementById('tdMsgContent').innerHTML = msg.Message;


                            $('#divMsgTest').animate({ bottom: "25" }, 500);


                            //if (!ASPxPopupMessagerControlClient.GetVisible())
                            //    ASPxPopupMessagerControlClient.Show();
                        }
                    }
                    else
                        window.setTimeout(function () { hook(); }, callIntervalTime);
                }
                else {
                    document.getElementById('errorMsg').innerHTML +=
                              request.responseText + '< br />';
                }
            }
        }
        catch (e) {
            document.getElementById('errorMsg').innerHTML = "Error: " + e.message;
        }
    };
    request.open('POST', url, true);
    request.send(null);
}

function ReadMsg() {
    var msgId = currentMsgId;
    var url = 'MessagerHandler.ashx?msgId=' + msgId;
    var request = getRequestObject();
    var params = 'msgId=' + msgId;
    request.onreadystatechange = function () {
        if (request.readyState == 4 && request.status != 200)
            alert('Error ' + request.status + ' trying to send request');
        if (request.status == 200) {
            HideMessages();
            //ASPxPopupMessagerControlClient.Hide();
            hook();
        }
    };

    request.open('POST', url, true);
    request.send(params);
}

function PopupViewLead() {
    if (popupBBLE != null) {
        var iframe = document.getElementById("contentUrlPane");
        if (iframe && iframe != null) {
            var frmDocument = (iframe.contentWindow || iframe.contentDocument);
            if (frmDocument.ReloadPage) {
                debugger;
                if (frmDocument.ReloadPage(popupBBLE)) {
                    ReadMsg()
                    return;
                }
            }
        }

        ShowSearchLeadsInfo(popupBBLE);
        ReadMsg();
    }
}

function send() {
    var message = document.getElementById('message').value;
    var recipient = document.getElementById('').value;
    var request = getRequestObject();
    var url = 'MyMessageHandler.ashx?message=' + message + '&recipient=' + recipient;
    var params = 'message=' + message + '&recipient=' + recipient;

    document.getElementById('incoming').innerHTML += '' + message + '< br />';

    request.onreadystatechange = function () {
        if (request.readyState == 4 && request.status != 200)
            alert('Error ' + request.status + ' trying to send message');
    };

    request.open('POST', url, true);
    request.send(params);
}

function getRequestObject() {
    var req;

    if (window.XMLHttpRequest && !(window.ActiveXObject)) {
        try {
            req = new XMLHttpRequest();
        }
        catch (e) {
            req = false;
        }
    }
    else if (window.ActiveXObject) {
        try {
            req = new ActiveXObject('Msxml2.XMLHTTP');
        }
        catch (e) {
            try {
                req = new ActiveXObject('Microsoft.XMLHTTP');
            }
            catch (e) {
                req = false;
            }
        }
    }

    return req;
}

function HideMessages() {
    var msgHeight = $("#divMsgTest").outerHeight() + 10;
    $('#divMsgTest').css('bottom', -msgHeight);
}

