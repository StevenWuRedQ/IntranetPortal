<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReportWizard.aspx.vb" Inherits="IntranetPortal.ReportWizard" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div  id="ReportWizardCtrl" ng-controller="ReportWizardCtrl" class="container">
        <div class="nga-fast nga-fade" ng-show="step==1">
            <div ng-repeat="c in Fields" class="col-sm-4 col-md-4">
                <table class="table table-compact">
                    <tr>
                        <th class="text-primary">{{c.category}}</th>
                    </tr>
                    <tr class="ss_border" ng-repeat="f in c.fields">
                        <td>
                            <label for="{{camel(f.name)}}">{{f.name}}</label></td>
                        <td>
                            <input type="checkbox" id="{{camel(f.name)}}" style="display: block" ng-model="f.checked" /></td>

                    </tr>
                </table>
            </div>
        </div>
        <hr />
        <div class="col-md-12 col-sm-12 clearfix" style="padding-top: 20px">
            <button ng-show="step>1" type="button" class="btn-primary pull-left" ng-click="prev()">Prev</button>
            <button ng-show="step<2" type="button" class="btn-primary pull-right" ng-click="next()">Next</button>
            <button ng-show="step==2" type="button" class="btn-primary pull-right">Generate</button>
        </div>
    </div>
    <script>

        portalApp = angular.module('PortalApp');
        portalApp.controller("ReportWizardCtrl", function ($scope, $http) {
            $scope.step = 1;
            $scope.load = function () {
                $http.get("shortsale.json")
                    .then(function (data) {
                        $scope.Fields = data.data;
                    })
            };
            $scope.camel = _.camelCase;
            $scope.CheckField = [];
            $scope.pushCheck = function (model) {
                $scope.CheckField.push(f);
            }

            $scope.next = function () {
                $scope.step = $scope.step + 1;
            }
            $scope.prev = function () {
                $scope.step = $scope.step - 1;
            }

            $scope.load();


        });

    </script>

</asp:Content>
