﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalInfo.aspx.vb" Inherits="IntranetPortal.LegalInfo" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>



<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <script>
        var AllContact, AllJudges,AllRoboSignor;
        $(function () {
            var LegalCtrlScope = angular.element(document.getElementById('LegalCtrl')).scope();
            var historyid = function () {
                return <% %>
            }
            //LegalCtrlScope.loadHistory(historyid);
        });
    </script>
    <uc1:LegalTab runat="server" ID="LegalTab" />
    
</asp:Content>
