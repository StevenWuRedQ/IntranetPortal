<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dialer.aspx.vb" Inherits="IntranetPortal.Dialer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript"
        src="//static.twilio.com/libs/twiliojs/1.2/twilio.min.js"></script>
    <script type="text/javascript"
        src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js">
    </script>
    <link href="http://static0.twilio.com/bundles/quickstart/client.css"
        type="text/css" rel="stylesheet" />
    <style>
        /*body {
            text-align: center;
            margin: 0;
            background:url(whitey.png) center top repeat;
        }*/
    </style>
    <script type="text/javascript">
        var CallNumber = '<%= CalledNumber%>';
        Twilio.Device.setup('<%= TwilioToken%>');

        Twilio.Device.ready(function (device) {
            $("#log").text("Ready");
            if(CallNumber!=null)
            {
               call(CallNumber);
            }
        });

        Twilio.Device.error(function (error) {
            $("#log").text("Error: " + error.message);
        });

        Twilio.Device.connect(function (conn) {
            $("#log").text("Successfully established call");
        });

        Twilio.Device.disconnect(function (conn) {
            $("#log").text("Call ended");
        });

        Twilio.Device.incoming(function (conn) {
            $("#log").text("Incoming connection from " + conn.parameters.From);
            // accept the incoming connection and start two-way audio
            conn.accept();
        });

        function call(PhoneNumber) {
            // get the phone number to connect the call to
            params = { "PhoneNumber": PhoneNumber != null ? PhoneNumber : PhoneNumber$("#number").val() };
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

        <button class="hangup" onclick="hangup();" type="button">
            Hangup
        </button>

        <input type="text" id="number" name="number"
            placeholder="Enter a phone number to call" />

        <div id="log">Loading pigeons...</div>
    </form>
</body>
</html>
