<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingRequest.aspx.vb" Inherits="IntranetPortal.UnderwritingRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <script>
        angular.module("PortalApp").config(function ($stateProvider) {
            var underwriterRequest = {
                name: 'underwritingRequest',
                url: '/',
                controller: 'UnderwritingRequestController',
                templateUrl: '/js/Views/Underwriter/underwriting_request.tpl.html'
            }

            $stateProvider.state(underwriterRequest);
        });
    </script>
    <ui-view></ui-view>
</asp:Content>
