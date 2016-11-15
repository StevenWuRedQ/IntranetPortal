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
    <div id="dataPanelDiv">
        <div ng-view class="container"></div>
    </div>

    <div ng-controller="ptPreAssignAccoutingCtrl" >
        <div id="pt-preassign-accouting-ctrl">
        <script type="text/ng-template" id="pt-preassign-accouting-modal">
                <div class="modal-body">
                    <table>
                        <tr>
                            <td>Check No.</td>
                            <td>
                                <input ng-model="data.CheckNo"></input></td>
                        </tr>
                        </tr>
                                    <td>Confirm Amount</td>
                        <td>
                            <input ng-model="data.ConfirmedAmount"></input></td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-danger" type="button" ng-click="closeModal()">Cancel</button>
                    <button class="btn btn-primary" type="button" ng-click="update()">Update</button>
                </div>
        </script>
            
        </div>
    </div>

    <script>
        portalApp.config(['$httpProvider', function ($httpProvider) {
            $httpProvider.interceptors.push('PortalHttpInterceptor');
        }]);
    </script>
</asp:Content>
