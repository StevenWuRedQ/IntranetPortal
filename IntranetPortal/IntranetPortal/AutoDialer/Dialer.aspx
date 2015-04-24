﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Dialer.aspx.vb" Inherits="IntranetPortal.Dialer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel='stylesheet' type='text/css' />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
    <script type="text/javascript" src="https://static.twilio.com/libs/twiliojs/1.2/twilio.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js">
    </script>
    <link href="/css/stevencss.css" rel="stylesheet" type="text/css" />

    <%-- <link href="http://static0.twilio.com/bundles/quickstart/client.css" type="text/css" rel="stylesheet" />--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sprintf/1.0.1/sprintf.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>

    <style>
        /*body {
            text-align: center;
            margin: 0;
            background: none;
           
        }

        button.call, button.hangup {
            margin-top: 118px;
        }*/
        .close:focus {
            outline: none;
        }

        button.close:focus {
            outline: none;
        }

        .dailer_input {
            background: inherit;
            height: 40px;
            color: white;
        }

        .dailer_input_addon {
            background: inherit;
            font-size: 18px;
            color: white;
        }

        .call_btn {
            font-size: 30px;
            padding: 18px 25px;
            background: inherit;
            border-radius: 50%;
        }
        .call_btn_nomal
        {
            border: 1px white solid;
        }
        .call_btn_hangup
        {
            background:#ff400d;
            transform:rotate(135deg);
        }
        .no_outline:focus {
            outline: none !important;
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

            $(function () {
                InitConfrence(CallNumber)
            }).delay(5000)

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
            if (callId && typeof callId !== 'undefined') {
                var url = '/AutoDialer/DialerAjaxService.svc/GetCallDuration/' + callId;
                $.getJSON(url, function (duration) {
                    var log = sprintf("%s did phone (%s) call duration %s", $("#userName").val(), CallNumber, duration);
                    logCall(BBLE, log)
                });
            }


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

            var pn = cn ? cn : $("#number").val();

            if (pn) {
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
        <input type="hidden" id="userName" value="<%=Page.User.Identity.Name%>" />
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background: #1a3847; color: white">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <i class="fa fa-times" style="color:white"></i>

                                </button>
                                <h4 class="modal-title">
                                    <i class="fa fa-phone with_circle message_pupup_icon"></i>

                                    <span style="font-size: 22px; padding-left: 5px;" class="">Dailer</span>

                                </h4>
                            </div>
                            <div class="modal-body">

                                <div class="input-group">
                                    <input type="text" class="form-control dailer_input" placeholder="Dail or Search" aria-describedby="basic-addon2">
                                    <span class="input-group-addon dailer_input_addon" id="basic-addon2"><i class="fa fa-times-circle"></i></span>
                                </div>
                                <div align="center" style="margin: 15px;">
                                    <span style="font-size: 30px" class="font_light">(347) 123-4567</span>

                                </div>

                                <div align="center">
                                    <button type="button" class="call_btn no_outline call_btn_nomal">
                                        <i class="fa fa-phone"></i>
                                    </button>
                                </div>

                                <%--<button class="call" onclick="InitConfrence();" type="button">
                                    Call
                                </button>
                                
                                <button class="hangup" onclick="hangup();" type="button">
                                    Hangup
                                </button>--%>

                                <%-- <input type="text" id="number" name="number"
                                    placeholder="Enter a phone number to call" />--%>

                                <%-- <button onclick="GetCallInfo()" type="button">Try javascprit aip  </button>--%>

                                <div id="log" style="padding: 20px;">Loading pigeons...</div>
                                <div id="javascriptApi"></div>
                            </div>

                        </div>
                    </div>

                </div>
                <% If String.IsNullOrEmpty(Monitor) And Not CallModel Then%>
                <div class="col-md-6">
                    <iframe src="/Chat/ChatDefault.aspx" style="width: 574px; height: 400px; border: none"></iframe>
                </div>
                <%End If%>
            </div>
        </div>

    </form>
</body>
</html>
