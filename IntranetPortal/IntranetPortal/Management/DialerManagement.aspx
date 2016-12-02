<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="DialerManagement.aspx.vb" Inherits="IntranetPortal.DialerManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <div class="container-fluid" ng-controller="DialerManagementController">
        <div class="row">
            <div class="col-md-6">
                <div class="dx-fieldset">
                    <div class="dx-fieldset-header">Add Contact List</div>
                    <div class="dx-field">
                         <div id="lookup"></div>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn btn-default" data-ng-click="CreateContactList()">CreateContactList</button>
                    <button type="button" class="btn btn-default" data-ng-click="SyncNewLeadsFolder()">SyncNewLeadsFolder</button>
                </div>
            </div>
            <hr />

        </div>
    </div>

    <script>
        angular.module("PortalApp").controller("DialerManagementController", ['$scope', 'EmployeeModel', 'ptCom','$http',  function ($scope, EmployeeModel, ptCom, $http) {

            $scope.lookup = undefined;
            EmployeeModel.getEmpNames().then(
                function success(d) {
                    var employeesList = d.data;
                    $("#lookup").dxLookup({
                        items: employeesList,
                        value: employeesList[0],
                        showPopupTitle: false
                    });
                    $scope.lookup = $("#lookup").dxLookup("instance");
                });
            
            $scope.CreateContactList = function () {
                if ($scope.lookup) {
                    var emp = $scope.lookup.option('value');
                    if (emp) {
                        $http({
                            method: "POST",
                            url: '/api/dialer/CreateContactList/' + emp
                        }).then(function (d) {
                            ptCom.alert("Contact For " + emp + " is: " + d.data);
                        }, function () {
                            ptCom.alert("Fail to create list");
                        }
                        )
                    } else {
                        ptCom.alert("Employee not select corretly");
                    }
                } else {
                    ptCom.alert("Lookup not init yet.")
                }
            }
            $scope.SyncNewLeadsFolder = function () {
                if ($scope.lookup) {
                    var emp = $scope.lookup.option("value");
                    if (emp) {
                        $http({
                            method: 'POST',
                            url: 'api/dialer/PostSyncNewLeadsFolder' + emp
                        }).then(function sucs(resp) {
                            ptCom.alert("Sync " + resp.data + " leads to new folder");
                        }, function err() {
                            ptCom.alert("fail to sync new folder")
                        })
                    }

                } else {
                    ptCom.alert("Lookup not init yet. ")
                }
            }

        }])
    </script>
</asp:Content>
