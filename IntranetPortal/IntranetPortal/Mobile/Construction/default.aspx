<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="default.aspx.vb" Inherits="IntranetPortal.SpotCheck" MasterPageFile="~/Mobile.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="mobile_content">
    <div ng-controller="SpotCheckCtrl">
        <div class="section">
            <div class="form-group">
                <label>Date</label>
                <input class="form-control" placeholder="00/00/0000" ng-model="form.date">
            </div>
            <div class="form-group">
                <label>Property Address</label>
                <select class="form-control" ng-options="l.Id as l.propertyAddress for l in CaseList|orderBy: 'propertyAddress' " ng-model="form.id" ng-change="onAddressChange()"></select>
            </div>
            <div class="form-group">
                <label>Access</label>
                <input class="form-control" type="text" placeholder="" ng-model="form.access">
            </div>
            <div class="form-group">
                <label>Number of workers</label>
                <input class="form-control" type="text" placeholder="" ng-model="form.numOfWork">
            </div>
        </div>
        <hr />
        <div class="section">
            <div class="form-group">
                <label>Description of interior work being done </label>
                <textarea class="form-control" rows="5" ng-model="form.descInterior"></textarea>
            </div>

            <div class="form-group">
                <label>Description of exterior work being done </label>
                <textarea class="form-control" rows="5" ng-model="form.descExterior"></textarea>
            </div>

            <div class="form-group">
                <label>Description of Material on site</label>
                <textarea class="form-control" rows="5" ng-model="form.descMaterial"></textarea>
            </div>

            <div class="form-group">
                <label>Are permits on site</label>
                <input type="checkbox" ng-model="form.isPermitOnsite" />
                <br />
                <label>If YES, please confirm which permit(s) and date it expires</label>
                <textarea class="form-control" rows="5" ng-model="form.permitsAndExpired"></textarea>
            </div>

            <div class="form-group">
                <label>Are plans on site</label>
                <input type="checkbox" ng-model="form.isPlansOnSite" />
            </div>

            <div class="form-group">
                <label>Next day planned work/tasks</label>
                <textarea class="form-control" rows="5" ng-model="form.nextDayPlan"></textarea>
            </div>

            <div class="form-group">
                <label>Additional Notes:</label>
                <textarea class="form-control" rows="5" ng-model="form.note"></textarea>
            </div>
            <button type="button" class="btn btn-primary pull-left" ng-click="saveForm()">Save</button>
            <button type="button" class="btn btn-success pull-right" ng-click="submitForm()">Finish</button>
        </div>
    </div>
    <script>
        angular.module('PortalMapp').controller("SpotCheckCtrl", function ($scope, $http, $filter) {
            $scope.form = {
                date: new Date().toLocaleDateString()
            };
            $scope.reload = function () {
                $scope.form = {
                    date: new Date().toLocaleDateString()
                };
                $scope.getCaseList();
            }
            $scope.init = function () {
                $scope.getCaseList()
            }
            $scope.getCaseList = function () {
                $http.get("/api/ConstructionCases/GetSpotCheckList")
                .then(function (res) {
                    $scope.CaseList = res.data;
                })
            }
            $scope.onAddressChange = function () {
                var addressId = $scope.form.id;
                $http.get("/api/ConstructionCases/GetSpotCheck/" + addressId)
                .then(function success(res) {
                    $scope.form = res.data;
                    $scope.form.id = addressId;
                    if ($scope.form.date) {
                        $scope.form.date = $filter('date')($scope.form.date, 'MM/dd/yyyy');
                    } else {
                        $scope.form.date = new Date().toLocaleDateString();
                    }
                    
                }, function error(res) {
                    alert("load data fails");
                })

            }
            $scope.saveForm = function () {
                if ($scope.form.id) {
                    $http({
                        method: 'POST',
                        url: '/api/ConstructionCases/SaveSpotList',
                        data: JSON.stringify($scope.form)
                    }).then(function () {
                        alert("Save Successful");                        
                    })

                }
            }
            $scope.submitForm = function () {
                if ($scope.form.id) {
                    $http({
                        method: "POST",
                        url: "/api/ConstructionCases/FinishSpotList",
                        data: JSON.stringify($scope.form)
                    }).then(function (res) {
                        alert("Send Successful");
                        $scope.reload();
                    })
                } else {
                    alert("Please select a correct address.")
                }
            }

            $scope.init();

        });
    </script>
</asp:Content>
