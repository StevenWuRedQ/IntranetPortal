<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingRequest.aspx.vb" Inherits="IntranetPortal.UnderwritingRequest" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>


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

    <hr />
    <% If Page.User.IsInRole("PropertyStory-Auditor") OrElse Page.User.IsInRole("Admin") Then %>
    <div id='uwrhistory' class="container" style="max-width: 800px; margin-bottom: 20px">
        <script type="text/javascript">
            function getUWRID() {
                //debugger;
                var scope = angular.element('#uwrview').scope();
                return scope.data.Id;

            }
            function showHistory() {
                var id = getUWRID()
                if (id) {
                    auditLog.toggle('UnderwritingRequest', id);
                }
            }
        </script>
        <button type="button" class="btn btn-info" onclick="showHistory()">History</button>
        <uc1:AuditLogs runat="server" ID="AuditLogs" />
    </div>
    <% End if %>
</asp:Content>
