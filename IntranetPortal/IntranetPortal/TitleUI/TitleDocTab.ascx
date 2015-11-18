<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleDocTab.ascx.vb" Inherits="IntranetPortal.TitleDocTab" %>
<div ng-controller="TitleDocCtrl">
    <div id="get_form_div">
        <select ng-model="data.seller" ng-options="seller.name for seller in sellers"></select>
        <input ng-model="data.llc" />
        <input ng-model="data.signdate" ss-date/>
        <hr />
        <button type="button" ng-click="generatePackage()">Generate Doc</button>
        <div id="generatedDocs">
            <uib-progressbar animate="true" value="100" type="success"></uib-progressbar>
            <a></a>
        </div>
    </div>
    <div id="signed_doc_div">

    </div>

    <script>
        angular.module("PortalApp")
        .controller("TitleDocCtrl", function ($scope, $http) {
            $scope.sellers = [
                {
                    name: 'Ron Borovinsky'
                }, {
                    name: 'Jay Gottlieb'
                }, {
                    name: 'Princess Simeon'
                }, {
                    name: 'Eliezer Herts'
                }, {
                    name: 'Magda Brillite'
                }, {
                    name: 'Tomer Aronov'
                }, {
                    name: 'Moisey Iskhakov'
                }, {
                    name: 'Albert Gavriyelov'
                }, {
                    name: 'Yvette Guizie'
                }, {
                    name: 'Michael Gendin'
                }
                
            ]

            //$scope.data = $scope.$parent.Form.FormData.docs;
            $scope.generatePackage = function(){
                $http({
                    url: "/api/Title/GeneratePakcage",
                    method: "POST",
                    data: $scope.data
                }).then(function (res) {

                })
            }          
            

        })
    </script>
</div>