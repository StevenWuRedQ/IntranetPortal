<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SpotCheck.aspx.vb" Inherits="IntranetPortal.SpotCheck" MasterPageFile="~/Mobile.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="mobile_content">
    <div class="item item-divider">
        <h2 class="text-center">Spot Check Form</h2>
    </div>
    <div ng-controller="SpotCheckCtrl">
        <div class="card">
            <div class="list">
                <label class="item item-input">
                    <span class="input-label">Date</span>
                    <input type="text" placeholder="00/00/0000" ng-model="form.date" />
                </label>
                <label class="item item-input item-select">
                    <span class="input-label">Property Address</span>
                    <select ng-options="l.Id as l.propertyAddress for l in CaseList|orderBy: 'propertyAddress' " ng-model="form.id" ng-change="onAddressChange()"></select>
                </label>
                <label class="item item-input">
                    <span class="input-label">Access</span>
                    <input type="text" placeholder="" ng-model="form.access" />
                </label>
                <label class="item item-input">
                    <span class="input-label">Number of workers</span>
                    <input type="text" placeholder="" ng-model="form.numOfWork" />
                </label>
            </div>
        </div>

        <div class="card">
            <div class="list">

                <label class="item item-input item-stacked-label">
                    <span class="input-label">Description of interior work being done </span>
                    <textarea rows="5" ng-model="form.descInterior"></textarea>
                </label>


                <label class="item item-input item-stacked-label">
                    <span class="input-label">Description of exterior work being done </span>
                    <textarea rows="5" ng-model="form.descExterior"></textarea>
                </label>

                <label class="item item-input item-stacked-label">
                    <span class="input-label">Description of Material on site</span>
                    <textarea class="form-control" rows="5" ng-model="form.descMaterial"></textarea>
                </label>

                <span class="item item-toggle">Are permits on site
                    <label class="toggle toggle-assertive">
                        <input type="checkbox" ng-model="form.isPermitOnsite" />
                        <div class="track">
                            <div class="handle"></div>
                        </div>
                    </label>
                </span>

                <label class="item item-input item-stacked-label">
                    <span class="input-label">If YES, please confirm which permit(s) and date it expires</span>
                    <textarea rows="5" ng-model="form.permitsAndExpired"></textarea>
                </label>

                <span class="item item-toggle">Are plans on site
                    <label class="toggle toggle-assertive">
                        <input type="checkbox" ng-model="form.isPlansOnSite" />
                        <div class="track">
                            <div class="handle"></div>
                        </div>
                    </label>
                </span>

                <label class="item item-input item-stacked-label">
                    <span class="input-label">Next day planned work/tasks</span>
                    <textarea rows="5" ng-model="form.nextDayPlan"></textarea>
                </label>

                <label class="item item-input item-stacked-label">
                    <span class="input-label">Additional Notes:</span>
                    <textarea rows="5" ng-model="form.note"></textarea>
                </label>
            </div>
        </div>

        <div class="row">
            <button type="button" class="button button-positive col col-40" ng-click="saveForm()">Save</button>
            <div class="col"></div>
            <button type="button" class="button button-balanced col col-40" ng-click="submitForm()">Finish</button>
        </div>

    </div>
    <script>
        angular.module('PortalMapp').controller("SpotCheckCtrl", function ($scope, $http, $filter, $ionicLoading) {
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
                $ionicLoading.show()
                $http.get("/api/ConstructionCases/GetSpotCheckList")
                .then(function (res) {
                    $scope.CaseList = res.data;
                    $ionicLoading.hide()
                })
            }
            $scope.onAddressChange = function () {
                $ionicLoading.show()
                var addressId = $scope.form.id;
                $http.get("/api/ConstructionCases/GetSpotCheck/" + addressId)
                .then(function success(res) {
                    $ionicLoading.hide()
                    $scope.form = res.data;
                    $scope.form.id = addressId;
                    $scope.form.date = new Date().toLocaleDateString();
                }, function error(res) {
                    alert("load data fails");
                })

            }
            $scope.saveForm = function () {
                if ($scope.form.id) {
                    $ionicLoading.show();
                    $http({
                        method: 'POST',
                        url: '/api/ConstructionCases/SaveSpotList',
                        data: JSON.stringify($scope.form)
                    }).then(function () {
                        $ionicLoading.hide();
                        alert("Save Successful");
                    }, function error() {
                        $ionicLoading.hide();
                        alert("Fails to save.")
                    })

                }
            }
            $scope.submitForm = function () {
                if ($scope.form.id) {
                    $ionicLoading.show()
                    $http({
                        method: "POST",
                        url: "/api/ConstructionCases/FinishSpotList",
                        data: JSON.stringify($scope.form)
                    }).then(function (res) {
                        $ionicLoading.hide();
                        alert("Send Successful");
                        $scope.reload();
                    }, function error() {
                        $ionicLoading.hide();
                        alert("Fails to send.")
                    })
                } else {
                    alert("Please select a correct address.")
                }
            }

            $scope.init();

        });
    </script>
</asp:Content>
