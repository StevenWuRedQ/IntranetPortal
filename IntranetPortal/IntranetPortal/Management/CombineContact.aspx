<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CombineContact.aspx.vb" Inherits="IntranetPortal.CombineContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:ng="http://angularjs.org" ng-app="PortalApp">
<head runat="server">
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.min.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
</head>
<body ng-controller="PortalCtrl">
    <form id="form1" runat="server">
        <div >
            <h4>Table properties </h4>
            <div>
                {{GetSelected()}}
                {{Selected1}}
            </div>

            <table class="table">
               <thead>
                   <tr>
                       <th>#</th>
                       <th>Key</th>
                       <th>value</th>
                   </tr>
               </thead>
                <tr ng-repeat="(key,v) in Case">
                    <td><input type="checkbox" ng-model="Selected[key]" /></td>
                    <td>{{key}}</td>
                    <td>{{v}}

                        <table class="table" ng-if="">
                           
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div>
            FindConatctId:
            <asp:TextBox ID="FindConatctId" runat="server"></asp:TextBox>
            
            <asp:Button ID="ViewFind" runat="server" Text="ViewInCase" />
            RepaceContactID:
            <asp:TextBox ID="RepaceContactID" runat="server"></asp:TextBox>
            <asp:Button ID="Replace" runat="server" Text="replace" />

            <asp:Button ID="submitReplace" runat="server" Text="SumbitReplace" OnClick="submitReplace_Click" />
            <asp:CheckBox ID="SaveChnage" runat="server"  Text="Save Changes"/>


            <asp:Button ID="LoadBtn" runat="server" Text="LoadDuplicateContacts" OnClick="LoadBtn_Click" />
            <dx:ASPxGridView ID="gridDuplicateCase" runat="server" >
                <SettingsPager Mode="ShowAllRecords">

                </SettingsPager>
            </dx:ASPxGridView>

        </div>
        <script>
            var portalApp = angular.module('PortalApp', []);
            portalApp.controller('PortalCtrl', function ($scope, $http, $element) {
                $scope.Case = <%=ssCase %> || {}
                $scope.Selected = {};

                $scope.GetSelected = function()
                {
                    var selected = [];
                    $.each($scope.Selected, function(index, value) {
                        if(value)
                        {
                            selected.push(index)
                        }
                    });
                    return selected;
                }
            });
        </script>
    </form>
</body>
</html>
