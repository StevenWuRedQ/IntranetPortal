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
    <% If Page.User.IsInRole("Accounting-*") OrElse Page.User.IsInRole("Admin") %>
        <input type="hidden" id="accoutingMode" value="true"/>
    <% End If %>
    <div id="dataPanelDiv">
        <div ng-view class="container"></div>
    </div>

    <div ng-controller="ptPreAssignAccoutingCtrl">
        <div id="pt-preassign-accouting-ctrl">
            <script type="text/ng-template" id="pt-preassign-accouting-modal">
                <div class="modal-body">
                    <button class="btn btn-default pull-right" type="button" ng-click="toggleEdit()">{{editmode?'Lock':'Edit'}}</button>
                    <br />
                    <br />
                    <table class="table">
                        <tr ng-show="data.ProcessedDate">
                            <td colspan="2"><b>Last Processed By {{data.ProcessedBy}} on {{data.ProcessedDate| date: 'medium'}}</b></td>
                        </tr>
                        <tr>
                            <td>Check No.</td>
                            <td>
                                <input class="form-control" ng-model="data.CheckNo" ng-disabled="!editmode"></input></td>
                        </tr>
                        </tr>
                            <td>Confirm Amount</td>
                            <td>
                                <div class="input-group">
                                <span class="input-group-addon">$</span>
                                <input class="form-control" ng-model="data.ConfirmedAmount" ng-disabled="!editmode"></input></td>
                                </div>
                            </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-danger" type="button" ng-click="closeModal()">Cancel</button>
                    <button class="btn btn-primary" type="button" ng-click="update()" ng-show="editmode">Update</button>
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
