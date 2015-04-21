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
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>

    <style>
        body {
            text-align: center;
            margin: 0;
            background: none;
            /*background:url(https://static0.twilio.com/resources/quickstart/whitey.png) center top repeat;*/
        }

        button.call, button.hangup {
            margin-top: 118px;
        }
    </style>
    <script type="text/javascript">
        var CallNumber = '<%= CalledNumber%>';
        var BBLE = '<%= BBLE%>';
        var Montor = "<%= Monitor %>";
        Twilio.Device.setup('<%= TwilioToken%>');

        Twilio.Device.ready(function (device) {
            $("#log").text("Ready");
            //if (Montor) {
            call(Montor);
            
            $(function ()
            {
                InitConfrence(CallNumber)
            }).delay(2000)

            //}else
            //{
            //    call(null);
            //}
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
        function logCall(BBLE, log) {
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

        function call(confrenceName) {


            var params = { "ConfrenceName": (confrenceName ? confrenceName : $('#userName').val()) };
            if (confrenceName) {
                params.muted = "true";

            }
            Twilio.Device.connect(params
                );
            //$.getJSON('/AutoDialer/DialerAjaxService.svc/CallNumber/' + pn);
        }

        function InitConfrence(cn) {
            //params = { "Confrece": pn };
            //Twilio.Device.connect(params);
            
            var pn = cn?cn:$("#number").val();

            if (pn)
            {
                $.getJSON('/AutoDialer/DialerAjaxService.svc/CallNumber/' + pn + ',' + $('#userName').val());
            }
            
        }
        function hangup() {
            Twilio.Device.disconnectAll();
        }
        function getJsonAuth(url, success_func) {
            $.ajax({
                type: 'GET',
                url: url,
                dataType: 'jsonp',
                crossDomain: true,
                //whatever you need
                beforeSend: function (xhr) {
                    xhr.setRequestHeader('Authorization', make_base_auth());
                },
                username: 'AC7a286d92694557dd36277876d0c1564d',
                password: '4d10548e8f394c399ff01bb21038dc53',
                success: success_func
            });
        }

        function GetCallInfo() {
            getJsonAuth('https://api.twilio.com/2010-04-01/Accounts/AC7a286d92694557dd36277876d0c1564d/Calls/CA0a89cb94cc85fa339559607409b11dce.json',
                function (data) {
                    $("#javascriptApi").html(JSON.stringify(data))
                })
        }

        function make_base_auth() {
            var tok = 'AC7a286d92694557dd36277876d0c1564d:4d10548e8f394c399ff01bb21038dc53';
            var hash = btoa(tok);
            return hash;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <button class="call" onclick="InitConfrence();" type="button">
                        Call
                    </button>
                    <input type="hidden" id="userName" value="<%=Page.User.Identity.Name%>" />
                    <button class="hangup" onclick="hangup();" type="button">
                        Hangup
                    </button>
                    <%--<button class="call" onclick="InitConfrence();" type="button">
                        Confrence
                    </button>--%>
                    <input type="text" id="number" name="number"
                        placeholder="Enter a phone number to call" style="margin: 29px 0 0 46px;" />

                    <%-- <button onclick="GetCallInfo()" type="button">Try javascprit aip  </button>--%>

                    <div id="log" style="height: 46px">Loading pigeons...</div>
                    <div id="javascriptApi"></div>
                </div>
                <% If String.IsNullOrEmpty(Monitor) Then%>
                <div class="col-md-6">
                    <iframe src="/Chat/ChatDefault.aspx" style="width: 574px; height: 400px; border: none"></iframe>
                </div>
                <%End If%>
            </div>
        </div>

    </form>
</body>
</html>
