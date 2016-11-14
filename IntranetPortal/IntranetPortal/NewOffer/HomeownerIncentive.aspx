<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="HomeownerIncentive.aspx.vb" Inherits="IntranetPortal.HomeownerIncentivePage" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .wizard-content {
            min-height: 400px;
        }

        .online {
            width: 100% !important;
        }

        .avoid-check {
            text-decoration: line-through;
        }

        a.dx-link-MyIdealProp:hover {
            font-weight: 500;
            cursor: pointer;
        }

        .myRow:hover {
            background-color: #efefef;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="preSignId" value='<%= Request.QueryString("preSignId")%>' />
    <input type="hidden" id="BBLE" value='<%= Request.QueryString("BBLE")%>' />
    <input type="hidden" id="currentUser" value='<%=Page.User.Identity.Name %>' />
    <div ng-view class="container"></div>
    <div ng-controller="preAssignCtrl" class="container" id="dataPanelDiv">
        <div class="row">
            <div class="col-md-12" ng-hide="!preSignList">
                <div style="padding: 20px">
                    <h2 ng-if="role==null">Homeowner Incentive Request List</h2>
                    <input type="text" hidden="hidden" value="1234" />
                    <h2 ng-if="role=='finance'">Check Requests List</h2>
                    <div dx-data-grid="preSignRecordsGridOpt">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        portalApp.config(['$httpProvider', function ($httpProvider) {
            $httpProvider.interceptors.push('PortalHttpInterceptor');
        }]);
    </script>

</asp:Content>
