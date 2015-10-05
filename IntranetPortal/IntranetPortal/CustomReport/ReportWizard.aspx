<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReportWizard.aspx.vb" Inherits="IntranetPortal.ReportWizard" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <link rel="stylesheet" href="/css/right-pane.css" />
    <script src="/Scripts/js/right_pane.js?v=1.01" type="text/javascript"></script>
    <div id="ReportWizardCtrl" ng-controller="ReportWizardCtrl">
        <div class="container" style="padding: 20px; font-size: small">
            <div class="nga-fast nga-fade" ng-show="step==1">
                <div ng-repeat="c in Fields track by c.category" class="col-sm-6 col-md-6">
                    <table class="table table-condensed">
                        <tr>
                            <th class="text-primary">{{c.category}} &nbsp
                            <pt-collapse model="collpsed[c.category]"></pt-collapse>
                            </th>
                        </tr>
                        <tr ng-repeat="f in c.fields track by f.name" collapse="!collpsed[c.category]">
                            <td>
                                <label for="{{camel(f.name)}}" ng-class="" ng-style="isBindColumn(f)?{}:{'color': '#e0e0e0'}">{{f.name}}</label></td>
                            <td>
                                <input type="checkbox" id="{{camel(f.name)}}" style="display: block" ng-model="f.checked" ng-disabled="!isBindColumn(f)" /></td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="nga-fast nga-fade" ng-show="step==2">
                <div ng-show="someCheck(c)" ng-repeat="c in Fields" class="col-sm-12 col-md-12">
                    <h4 class="text-primary">{{c.category}}</h4>
                    <div>
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
                                                <input type="text" ng-model="x.input1" ng-change="updateStringFilter(x)" />
                                            </span>
                                            <span ng-if="f.type=='date'">
                                                <select ng-model="x.criteria" ng-change="updateDateFilter(x)">
                                                    <option value="1">is before</option>
                                                    <option value="2">is after</option>
                                                    <option value="3">equals</option>
                                                </select>
                                                <input type="text" ng-model="x.input1" ng-change="updateDateFilter(x)" type="text" ss-date />
                                            </span>
                                            <span ng-if="f.type=='number'">
                                                <select ng-model="x.criteria" ng-change="updateNumberFilter(x)">
                                                    <option value="1"><</option>
                                                    <option value="2"><=</option>
                                                    <option value="3">></option>
                                                    <option value="4">>=</option>
                                                    <option value="5">between</option>
                                                </select>
                                                <input type="text" ng-model="x.input1" ng-change="updateNumberFilter(x)" />
                                                <span ng-show="x.criteria=='5'">AND
                                            <input type="text" ng-model="x.input2" ng-change="updateNumberFilter(x)" /></span>
                                            </span>
                                            <span ng-if="f.type=='list'" style="width: 300px; display: inline-block">
                                                <span>
                                                    <ui-select multiple ng-model="x.input1" ng-change="updateListFilter(x)">
                                                    <ui-select-match placeholder="Choose items">{{$item}}</ui-select-match>
                                                    <ui-select-choices repeat="o in f.options | filter: $search.search">
                                                    {{o}}
                                                </ui-select-choices>
                                            </ui-select>
                                                </span>
                                            </span>
                                            <span ng-if="f.type=='boolean'">
                                                <select ng-model="x.input1" ng-change="updateBooleanFilter(x)">
                                                    <option value="1">Yes</option>
                                                    <option value="0">No</option>
                                                </select>
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

            <div class="nga-fast nga-face" ng-show="step==3">
                <h3>{{getReportTitle()}}</h3>
                <div id="queryReport" dx-data-grid="{
                                    width: 800,
                                    height: 600,
                                    allowColumnReordering: true,
                                    allowColumnResizing: true,
                                    columnAutoWidth: true,
                                    columnChooser: {
                                        enabled: true
                                    },
                                    stateStoring : {
                                        enabled: true
                                    },
                                    export: {
                                        enabled: true,
                                        fileName: 'Report'
                                    },
                                    bindingOptions: {
                                        dataSource: 'reportData',
                                        stateStoring: 'stateStoring'

                                    },
                                    editing: {
                                        editEnabled: false
                                    }                                         
                                }">
                </div>
            </div>
            <hr />
            <div class="col-md-12 col-sm-12 clearfix" style="padding-top: 20px">
                <button ng-show="step>1" type="button" class="btn-primary pull-left" ng-click="prev()">Prev</button>
                <button ng-show="step<2" type="button" class="btn-primary pull-right" ng-click="next()">Next</button>
                <button ng-show="step==2" type="button" class="btn-primary pull-right" ng-click="generate()">Generate</button>
                <%-- update --%>
                <button ng-show="CurrentQuery && step==3" type="button" class="btn-primary pull-right" ng-click="update()">Save Query</button>
                <%-- save new --%>
                <button ng-show="!CurrentQuery && step==3" type="button" class="btn-primary pull-right" ng-click="SaveQueryPop=true">Save Query</button>
            </div>
        </div>

        <div id="right-pane-container" class="clearfix" style="right: 0">
            <div id="right-pane-button" class="right-pane_custom_reports"></div>
            <div id="right-pane">
                <div style="height: 100%; background: #EFF2F5;">
                    <div style="width: 310px; background: #f5f5f5" class="agent_layout_float">
                        <div style="margin: 50px 20px; font-size: 24px; float: none;">
                            <h3>Save Reports</h3>
                            <hr />
                            <div>
                                <ul style="margin-right: 20px; font-size: 18px; list-style: none">
                                    <li class="icon_btn" ng-repeat="q in SavedReports track by q.ReportId">
                                        <i class="fa fa-file-o" ng-click="load(q)"></i>&nbsp;<span ng-click="load(q)">{{q.Name}}</span>&nbsp
                                        <pt-del ng-click="deleteSavedReport(q)" class="pull-right"></pt-del>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div dx-popup="{
        height: 200,
        width: 600,
        showTitle: false,
        dragEnabled: true,
        shading: true,
        bindingOptions:{ visible: 'SaveQueryPop' },
        }">
            <div data-options="dxTemplate:{ name: 'content' }">
                <h5>New Query Name</h5>
                <input class="form-control" ng-model="NewQueryName" />
                <hr>
                <div class="pull-right">
                    <button class="btn btn-danger" ng-click="onSaveQueryPopCancel()">Cancel</button>
                    <button class="btn btn-success" ng-click="onSaveQueryPopSave()">Save</button>
                </div>
            </div>
        </div>

    </div>
    <script>
        portalApp = angular.module('PortalApp');
        portalApp.controller("ReportWizardCtrl", function ($scope, $http, $timeout) {
            $scope.step = 1;
            $scope.collpsed = [];
            $scope.CurrentQuery = null;
            $scope.reload = function (callback) {
                $scope.step = 1;
                $scope.CurrentQuery = null;
                $http.get("<%= Template %>.js")
                    .then(function (res) {
                        $scope.Fields = res.data[0].Fields;
                        if (callback) callback()
                    })
                $scope.loadSavedReport();
            };
            $scope.loadSavedReport = function () {
                $http.get("/api/Report/Load")
                    .then(function (res) {
                        $scope.SavedReports = res.data;
                    })
            }
            $scope.deleteSavedReport = function (q) {
                var _confirm = confirm("Are you sure to delete?");
                if (_confirm) {
                    if (q.ReportId) {
                        $http({
                            method: "DELETE",
                            url: "/api/Report/Delete/" + q.ReportId,
                        }).then(function (res) {
                            $scope.reload();
                            alert("Delete Success.");
                        })
                    } else {
                        alert("Delete Fails!");
                    }
                }

            }

            // load saved query
            $scope.load = function (q) {
                $scope.reload(
                    function () {
                        if (q.ReportId) {
                            $http.get("/api/Report/Load/" + q.ReportId)
                            .then(function (res) {
                                var data = res.data
                                $scope.CurrentQuery = data;

                                $scope.Fields = JSON.parse(data.Query);
                                $scope.generate();
                                var gridState = JSON.parse(data.Layout);
                                $("#queryReport").dxDataGrid("instance").state(gridState);
                            })
                        }
                    }
                );
            }

            $scope.camel = _.camelCase;

            $scope.someCheck = function (category) {
                return _.some(category.fields, { checked: true })
            }
            $scope.addFilter = function (f) {
                if (!f.filters) f.filters = []
                f.filters.push({})
            }
            $scope.removeFilter = function (f, i) {
                f.filters.splice(i, 1);
            }

            $scope.updateStringFilter = function (x) {
                if (!x.criteria || !x.input1) {
                    x.WhereTerm = ""
                    x.CompareOperator = ""
                    x.value1 = ""
                    return;
                } else {
                    switch (x.criteria) {
                        case "1":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Like";
                            x.value1 = x.input1.trim() + "%";
                            break;
                        case "2":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Like";
                            x.value1 = "%" + x.input1.trim();
                            break;
                        case "3":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Like";
                            x.value1 = "%" + x.input1.trim() + "%";
                            break;
                        default:
                            x.WhereTerm = ""
                            x.CompareOperator = ""
                            x.value1 = ""
                    }
                }
            }
            $scope.updateDateFilter = function (x) {
                if (!x.criteria || !x.input1) {
                    x.WhereTerm = ""
                    x.CompareOperator = ""
                    x.value1 = ""
                    return;
                } else {
                    switch (x.criteria) {
                        case "1":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Less";
                            x.value1 = x.input1;
                            break;
                        case "2":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Greater";
                            x.value1 = x.input1;
                            break;
                        case "3":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Equal";
                            x.value1 = x.input1;
                            break;
                        default:
                            x.WhereTerm = ""
                            x.CompareOperator = ""
                            x.value1 = ""
                    }
                }

            }
            $scope.updateNumberFilter = function (x) {

                if (!x.criteria || !x.input1 || (x.criteria == "5" && !x.input2)) {
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
                    x.value2 = "";
                    return;
                } else {
                    switch (x.criteria) {
                        case "1":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Less";
                            x.value1 = x.input1.trim();
                            x.value2 = "";
                            break;
                        case "2":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "LessOrEqual";
                            x.value1 = x.input1.trim();
                            x.value2 = "";
                            break;
                        case "3":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Greater";
                            x.value1 = x.input1.trim();
                            x.value2 = "";
                            break;
                        case "4":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "GreaterOrEqual";
                            x.value1 = x.input1.trim();
                            x.value2 = "";
                            break;
                        case "5":
                            x.WhereTerm = "CreateBetween";
                            x.CompareOperator = "";
                            x.value1 = x.input1.trim();
                            x.value2 = x.input2.trim();
                            break;
                        default:
                            x.WhereTerm = "";
                            x.CompareOperator = "";
                            x.value1 = "";
                            x.value2 = "";
                    }
                }
            }
            $scope.updateListFilter = function (x) {
                if (!x.input1 || x.input1.length < 1) {
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
                } else {
                    x.WhereTerm = "CreateIn";
                    x.CompareOperator = "";
                    x.value1 = x.input1;
                }
            }
            $scope.updateBooleanFilter = function (x) {
                if (!x.input1) {
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
                } else {
                    switch (x.input1) {
                        case "1":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Equal";
                            x.value1 = true;
                            break;
                        case "0":
                            x.WhereTerm = "CreateCompare";
                            x.CompareOperator = "Equal";
                            x.value1 = false;
                            break;
                        default:
                            x.WhereTerm = "";
                            x.CompareOperator = "";
                            x.value1 = "";
                    }
                }
            }


            $scope.onSaveQueryPopCancel = function () {
                $scope.NewQueryName = '';
                $scope.SaveQueryPop = false;
            }
            $scope.onSaveQueryPopSave = function () {
                if (!$scope.NewQueryName) {
                    alert("New query name is empty!");
                    $scope.NewQueryName = '';
                    $scope.SaveQueryPop = false;
                } else {

                    var data = {};

                    data.Name = $scope.NewQueryName;

                    data.Query = JSON.stringify($scope.Fields);
                    data.sqlText = $scope.sqlText;
                    data.Layout = JSON.stringify($("#queryReport").dxDataGrid("instance").state());

                    data = JSON.stringify(data);

                    $http({
                        method: "POST",
                        url: "/api/Report/Save",
                        data: data,
                    }).then(function (res) {
                        $scope.NewQueryName = '';
                        $scope.SaveQueryPop = false;
                        $scope.reload()
                        alert("Save successful!")
                    })

                }
            }
            $scope.getReportTitle = function () {
                if ($scope.CurrentQuery) {
                    return "Report " + $scope.CurrentQuery.Name;
                } else {
                    return ""
                }
            }

            $scope.update = function () {

                data = $scope.CurrentQuery;

                data.Query = JSON.stringify($scope.Fields);
                data.sqlText = $scope.sqlText;
                data.Layout = JSON.stringify($("#queryReport").dxDataGrid("instance").state());

                data = JSON.stringify(data);

                $http({
                    method: "POST",
                    url: "/api/Report/Save",
                    data: data,
                }).then(function (res) {
                    $scope.NewQueryName = '';
                    $scope.SaveQueryPop = false;
                    $scope.reload()
                    alert("Save successful!")
                })
            }

            $scope.isBindColumn = function (f) {

                if (!f.table || !f.column) {
                    return false;
                } else {
                    return true;
                }
            }

            $scope.next = function () {
                $scope.step = $scope.step + 1;
            }
            $scope.prev = function () {
                $scope.step = $scope.step - 1;
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
                if (result.length > 0) {
                    $scope.step = 3;
                    $http({
                        method: "POST",
                        url: "/api/Report/QueryData",
                        data: JSON.stringify(result),
                    }).then(function (res) {
                        $scope.reportData = res.data[0];
                        $scope.sqlText = res.data[1];

                    })
                } else {
                    alert("Query is empty!");
                }
                
            }

            
            $scope.reload();
        });

    </script>

</asp:Content>
