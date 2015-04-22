<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CallManagement.aspx.vb" Inherits="IntranetPortal.CallManagement" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/MapsPopup.ascx" TagPrefix="uc1" TagName="MapsPopup" %>



<asp:Content ContentPlaceHolderID="head" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.2/handlebars.min.js"></script>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div align="center">
                    <button class="btn" type="button" onclick="getCallList()"><i class="icon_btn fa fa-fre fa-refresh"></i>refresh</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>From</th>
                            <th>To</th>
                            <th>Duration</th>
                            <th>Join</th>
                        </tr>
                    </thead>
                    <tbody id="callTable">
                        <tr>
                            <th>9298883289</th>
                            <td>Chris</td>
                            <td>10:00</td>
                            <td><i class="fa fa-phone icon_btn"></i></td>
                        </tr>
                        <%--  <%For Each c In CallList%>
                        <tr>

                            <th><%= c.FriendlyName%></th>
                            <td><%= c.AccountSid%></td>
                            <td><%= c.Status%></td>
                            <td><i class="fa fa-phone icon_btn" onclick="MonitorCall('<%=c.FriendlyName %>')"></i></td>
                        </tr>
                        <% Next%>--%>
                    </tbody>
                </table>
            </div>
            <div class="col-md-6">
                <iframe src="/Chat/ChatDefault.aspx" style="width: 574px; height: 400px; border: none"></iframe>
            </div>
        </div>

    </div>
    <script id="entry-template" type="text/x-handlebars-template">
        <tr>
            {{#each list}}
            <th>{{FriendlyName}}</th>
            <td>{{AccountSid}}</td>
            <td>{{Status}}</td>
            <td><i class="fa fa-phone icon_btn" onclick="MonitorCall('{{ FriendlyName }}')"></i></td>
            {{/each}}
        </tr>
    </script>
    <script>
        $(document).ready(function () {
            getCallList();
        });
        function getCallList()
        {
            $.getJSON('/AutoDialer/DialerAjaxService.svc/GetInporcesCallList', function (data) {
                var source = $("#entry-template").html();
                var template = Handlebars.compile(source);
                var html = template({ list: data });
                $("#callTable").html(html);
            });
        }
        function MonitorCall(name) {
            popUpAtBottomRight('/AutoDialer/Dialer.aspx?Monitor=' + name, "monitor", 560, 460)
        }
        function popUpAtBottomRight(pageToLoad, winName, width, height) {
            xposition = 0; yposition = 0;
            if ((parseInt(navigator.appVersion) >= 4)) {
                xposition = (screen.width - width);
                yposition = (screen.height - height);
            }

            var args = "";
            args += "width=" + width + "," + "height=" + height + ","
            + "location=0,"
            + "menubar=0,"
            + "resizable=0,"
            + "scrollbars=0,"
            + "statusbar=false,dependent,alwaysraised,"
            + "status=false,"
            + "titlebar=no,"
            + "toolbar=0,"
            + "hotkeys=0,"
            + "screenx=" + xposition + ","  //NN Only
            + "screeny=" + (yposition - 100) + ","  //NN Only
            + "left=" + xposition + ","     //IE Only
            + "top=" + yposition;           //IE Only
            var dmcaWin = window.open(pageToLoad, winName, args);
            dmcaWin.focus();
        }
    </script>
</asp:Content>
