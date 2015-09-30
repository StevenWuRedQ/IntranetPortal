<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReportWizard.aspx.vb" Inherits="IntranetPortal.ReportWizard" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="ReportWizardCtrl" ng-controller="ReportWizardCtrl" class="container" style="padding: 20px; font-size: small">
        <div class="nga-fast nga-fade" ng-show="step==1">
            <div ng-repeat="c in Fields" class="col-sm-6 col-md-6">
                <table class="table table-condensed">
                    <tr>
                        <th class="text-primary">{{c.category}} &nbsp <pt-collapse model="c.collpsed"></pt-collapse></th>
                    </tr>
                    <tr ng-repeat="f in c.fields" collapse="!c.collpsed">
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
                <div >
                    <table class="table table-condensed">
                        <tr ng-repeat="f in c.fields|filter:{checked: true}">
                            <td class="col-sm-3 col-md-3">
                                <label for="{{camel(f.name)}}">{{f.name}}</label></td>
                            <td>
                                <span class="btn btn-sm btn-primary" ng-show="!f.filters||f.filters.length==0" ng-click="addFilter(f)">add filter</span>
                                <span ng-show="f.filters">
                                    <span ng-repeat="x in f.filters">
                                        <span ng-if="f.type=='string'">
                                            <select ng-model="x.criteria" ng-change="updateStringFilter(x)">
                                                <option value="1">is start with</option>
                                                <option value="2">is end with</option>
                                                <option value="3">contains</option>
                                            </select>
                                            <input type="text" ng-model="x.value" ng-change="updateStringFilter(x)" />
                                        </span>
                                        <span ng-if="f.type=='date'">
                                            <select ng-model="x.criteria" ng-change="updateDateFilter(x)">
                                                <option value="1">is before</option>
                                                <option value="2">is after</option>
                                                <option value="3">equals</option>
                                            </select>
                                            <input type="text" ng-model="x.value" ng-change="updateDateFilter(x)" type="text" ss-date />
                                        </span>
                                        <span ng-if="f.type=='number'">
                                            <select ng-model="x.criteria" ng-change="updateNumberFilter(x)">
                                                <option value="1"><</option>
                                                <option value="2"><=</option>
                                                <option value="3">></option>
                                                <option value="4">>=</option>
                                                <option value="5">between</option>
                                            </select>
                                            <input type="text" ng-model="x.value" ng-change="updateNumberFilter(x)" />
                                            <span ng-show="x.criteria=='5'">AND
                                            <input type="text" ng-model="x.value2" ng-change="updateNumberFilter(x)" /></span>
                                        </span>
                                        <span ng-if="f.type=='list'" style="width: 300px; display: block">
                                            <span>
                                                <ui-select multiple ng-model="x.value">
                                                <ui-select-match placeholder="Choose items">{{$item}}</ui-select-match>
                                                <ui-select-choices repeat="o in f.options | filter: $search.search">
                                                    {{o}}
                                                </ui-select-choices>
                                            </ui-select>
                                            </span>
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
        </div>
        <hr />
        <div class="col-md-12 col-sm-12 clearfix" style="padding-top: 20px">
            <button ng-show="step>1" type="button" class="btn-primary pull-left" ng-click="prev()">Prev</button>
            <button ng-show="step<2" type="button" class="btn-primary pull-right" ng-click="next()">Next</button>
            <button ng-show="step==2" type="button" class="btn-primary pull-right" ng-click="generate()">Generate</button>
            <a id="jsonlink"></a>
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
                f.filters.push({ criteria: '', value: '', query: '' })
            }
            $scope.removeFilter = function (f, i) {
                f.filters.splice(i, 1);
            }
            $scope.updateStringFilter = function (x) {
                if (!x.criteria || !x.value) {
                    x.query = ""
                    return;
                }
                switch (x.criteria) {
                    case "1":
                        x.query = " Like " + " '" + x.value.trim() + "%' ";
                        break;
                    case "2":
                        x.query = " Like " + " '%" + x.value.trim() + "' ";
                        break;
                    case "3":
                        x.query = " Like " + " '%" + x.value.trim() + "%' ";
                        break;
                    default:
                        x.query = "";
                }
            }
            $scope.updateDateFilter = function (x) {
                if (!x.criteria || !x.value) {
                    x.query = ""
                    return;
                }
                switch (x.criteria) {
                    case "1":
                        x.query = " < " + " '" + x.value.trim() + "' ";
                        break;
                    case "2":
                        x.query = " > " + " '" + x.value.trim() + "' ";
                        break;
                    case "3":
                        x.query = " = " + " '" + x.value.trim() + "' ";
                        break;
                    default:
                        x.query = ""
                }

            }
            $scope.updateNumberFilter = function (x) {

                if (!x.criteria || !x.value || (x.criteria == "5" && !x.value2)) {
                    x.query = ""
                    return;
                }
                switch (x.criteria) {
                    case "1":
                        x.query = " < " + x.value.trim();
                        break;
                    case "2":
                        x.query = " <= " + x.value.trim();
                        break;
                    case "3":
                        x.query = " > " + x.value.trim();
                        break;
                    case "4":
                        x.query = " >= " + x.value.trim();
                        break;
                    case "5":
                        x.query = " BETWEEN " + x.value.trim() + " AND " + x.value2.trim();
                        break;
                    default:
                        x.query = ""
                }

            }
            $scope.generate = function () {
                var result = [];
                _.each($scope.Fields, function (el, i) {
                    _.each(el.fields, function (el, i) {
                        if (el.checked) {
                            result.push(el);
                        }
                    })
                })
                var data = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(result));

                var a = document.getElementById("jsonlink")
                a.href = 'data:' + data;
                a.download = 'data.json';
                a.innerHTML = 'download JSON';
            }
            $scope.load();


        });

    </script>

</asp:Content>
