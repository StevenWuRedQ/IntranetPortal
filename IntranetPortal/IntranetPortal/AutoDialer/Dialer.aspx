<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dialer.aspx.vb" Inherits="IntranetPortal.Dialer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://static.twilio.com/libs/twiliojs/1.2/twilio.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js">
    </script>
    <link href="http://static0.twilio.com/bundles/quickstart/client.css" type="text/css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sprintf/1.0.1/sprintf.js"></script>
    
    <style>
        /*body {
            text-align: center;
            margin: 0;
            background:url(whitey.png) center top repeat;
        }*/
    </style>
    <script type="text/javascript">
        var CallNumber = '<%= CalledNumber%>';
        var BBLE = '<%= BBLE%>';
        Twilio.Device.setup('<%= TwilioToken%>');

        Twilio.Device.ready(function (device) {
            $("#log").text("Ready");
            if (CallNumber != null && CallNumber.length > 0) {
                call(CallNumber);
            }
        });

        Twilio.Device.error(function (error) {
            $("#log").text("Error: " + error.message);
        });
       
        Twilio.Device.connect(function (conn) {
            if (BBLE) {
                var log = sprintf("%s did phone (%s) call", $("#userName").val(), CallNumber);
                logCall(BBLE, log);
            }
            $("#log").text("Successfully established call");
        });
        function logCall(BBLE,log)
        {
            var url = '/autoDialer/DialerAjaxservice.svc/CallLog/' + BBLE + ',' + log;
            $.getJSON(url, function (d) { });
        }
        Twilio.Device.disconnect(function (conn) {
            $("#log").text("Call ended");
            var callId = conn.parameters.CallSid;
            var url = '/AutoDialer/DialerAjaxService.svc/GetCallDuration/' + callId;
            $.getJSON(url, function (duration) {
                var log = sprintf("%s did phone (%s) call duration %s", $("#userName").val(), CallNumber, duration);
                logCall(BBLE, log)
            });

        });

        Twilio.Device.incoming(function (conn) {
            $("#log").text("Incoming connection from " + conn.parameters.From);
            // accept the incoming connection and start two-way audio
            conn.accept();
        });

        function call(PhoneNumber) {
            // get the phone number to connect the call to
            //var pn;
            if (PhoneNumber) {
                pn = PhoneNumber
            } else {
                pn = $("#number").val();
            }


            //params = { "PhoneNumber": pn };
            //Twilio.Device.connect(params);
            $.getJSON('/AutoDialer/DialerAjaxService.svc/CallNumber/' + pn);
        }

        function InitConfrence()
        {
            params = { "Confrece": pn };
            Twilio.Device.connect(params);
        }
        function hangup() {
            Twilio.Device.disconnectAll();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <button class="call" onclick="call();" type="button">
            Call
        </button>
        <input type="hidden" id="userName" value="<%=Page.User.Identity.Name%>" />
        <button class="hangup" onclick="hangup();" type="button">
            Hangup
        </button>
        <button class="call" runat="server" id="InitConfrence" onserverclick="CallManger_ServerClick" type="button" style="">
            Confrence
        </button>
        <input type="text" id="number" name="number"
            placeholder="Enter a phone number to call" />

        <div id="log">Loading pigeons...</div>
    </form>
</body>
</html>
