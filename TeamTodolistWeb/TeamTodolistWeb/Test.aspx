﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Test.aspx.vb" Inherits="Test" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Client-Side JavaScript Code Sample</title>
        <script src="constants.js"></script>
        <script src="//js.live.net/v5.0/wl.js"></script>
    </head>
    <body>
        <div id="signin"></div>
        <label id="info"></label>
        <script>
            WL.Event.subscribe("auth.login", onLogin);
            WL.init({
                client_id: APP_CLIENT_ID,
                redirect_uri: REDIRECT_URL,
                scope: "wl.signin",
                response_type: "token"
            });
            WL.ui({
                name: "signin",
                element: "signin"
            });
            function onLogin (session) {
                if (!session.error) {
                    WL.api({
                        path: "me",
                        method: "GET"
                    }).then(
                        function (response) {
                            document.getElementById("info").innerText =
                                "Hello, " + response.first_name + " " + response.last_name + "!";
                        },
                        function (responseFailed) {
                            document.getElementById("info").innerText =
                                "Error calling API: " + responseFailed.error.message;
                        }
                    );
                }
                else {
                    document.getElementById("info").innerText =
                        "Error signing in: " + session.error_description;
                }
            }
        </script>                   
    </body>
</html>
