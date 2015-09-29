<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReportWizard.aspx.vb" Inherits="IntranetPortal.ReportWizard" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="ReportWizardCtrl" ng-controller="ReportWizardCtrl" class="container" style="padding: 20px; font-size: small">
        <div class="nga-fast nga-fade" ng-show="step==1">
            <div ng-repeat="c in Fields" class="col-sm-4 col-md-4">
                <table class="table table-condensed">
                    <tr>
                        <th class="text-primary">{{c.category}}</th>
                    </tr>
                    <tr ng-repeat="f in c.fields">
                        <td>
                            <label for="{{camel(f.name)}}">{{f.name}}</label></td>
                        <td>
                            <input type="checkbox" id="{{camel(f.name)}}" style="display: block" ng-model="f.checked" /></td>

                    </tr>
                </table>
            </div>
        </div>

        <div class="nga-fast nga-fade" ng-show="step==2">
            <div ng-show="someCheck(c)" ng-repeat="c in Fields" class="col-sm-12 col-md-12">
                <h4 class="text-primary">{{c.category}}</h4>
                <table class="table table-condensed">
                    <tr ng-repeat="f in c.fields|filter:{checked: true}">
                        <td>
                            <label for="{{camel(f.name)}}">{{f.name}}</label></td>
                        <td>
                            <span class="btn btn-sm btn-primary" ng-show="!f.filters||f.filters.length==0" ng-click="addFilter(f)">add filter</span>
                            <span ng-show="f.filters">
                                <span ng-repeat="x in f.filters">
                                    <span ng-if="f.type=='string'">
                                        <select ng-model="x.criteria" ng-change="updateStringFilter(f)">
                                            <option value="1">is start with</option>
                                            <option value="2">is end with</option>
                                            <option value="3">contains</option>
                                        </select>
                                        <input ng-model="x.value" type="text" ng-change="updateStringFilter(x)"/>
                                    </span>
                                    <span ng-if="f.type=='date'">
                                        <select>
                                            <option>is before</option>
                                            <option>is after</option>
                                            <option>equals</option>
                                        </select>
                                        <input type="text" ss-date />
                                    </span>
                                    <span ng-if="f.type=='number'">
                                        <select>
                                            <option>></option>
                                            <option>>=</option>
                                            <option><</option>
                                            <option><=</option>
                                        </select>
                                        <input type="text"/>
                                        <span>AND <input type="text" /></span>
                                    </span>
                                    <pt-del ng-click="removeFilter(f, $index)"></pt-del>
                                </span>
                            </span>
                        </td>
                        <td></td>
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
            $scope.someCheck = function (category) {

                return _.some(category.fields, { checked: true })
            }
            $scope.addFilter = function (f) {
                if (!f.filters) f.filters = []
                f.filters.push({ criteria:'', value:'', query:'' })
            }
            $scope.removeFilter = function (f, i) {
                f.filters.splice(i, 1);
            }
            $scope.updateStringFilter = function (x) {
                switch (x.criteria) {
                    case "1":
                        x.query = " Like " + "'" + x.value + "%'";
                        break;
                    case "2":
                        x.query = " Like " + "'%" + x.value + "'";
                        break;
                    case "3":
                        x.query = " Like " + "'%" + x.value + "%'";
                        break;
                    default:
                        x.query = " Like " + "'%" + x.value + "%'";
                }
            }
            $scope.load();


        });

    </script>

</asp:Content>
