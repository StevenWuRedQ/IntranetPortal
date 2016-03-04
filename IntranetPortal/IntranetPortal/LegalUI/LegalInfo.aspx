<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalInfo.aspx.vb" Inherits="IntranetPortal.LegalInfo" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <script>
        var AllContact, AllJudges, AllRoboSignor;
        $(function () {
            var LegalCtrlScope = angular.element(document.getElementById('LegalCtrl')).scope();
            var logid = function () {
                return <%= logid %>
            }();
            if (logid) {
                LegalCtrlScope.loadHistoryData(logid);
            }

        });
    </script>
    <div>
        <div style="position: absolute; top: -60px; bottom: 0px; width:100%; overflow:auto" id="LegalCtrl" ng-controller="LegalCtrl">
            <uc1:LegalTab runat="server" ID="LegalTab" height="100%" />
        </div>
    </div>
</asp:Content>
