<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetForm.aspx.vb" Inherits="IntranetPortal.ConstructionBudgetForm" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <style>
        #budgetTable {
            font-size: 14px;
        }

            #budgetTable td > input {
                border: none;
            }

            #budgetTable table {
                width: 900px;
                table-layout: fixed;
            }

            #budgetTable input[type=text] {
                width: 100%;
                padding: 2px;
            }

        #budgetTableHeader {
            position: relative;
            top: 0;
        }
    </style>
    <script>

    </script>
    <div id="BudgetCtrl" ng-controller="BudgetCtrl">
        <div class="container">
            <h3 class="ss_form_title text-center">Budget Form</h3>
            <div>
                <button type="button" class="btn btn-primary pull-right" ng-click="save()"><i class="fa fa-floppy-o"></i>&nbsp;Save</button>
                <span class="pull-right">&nbsp;&nbsp;</span>
                <button type="button" class="btn btn-success pull-right" ng-click="exportExcel()"><i class="fa fa-file-excel-o">&nbsp;</i>Export Excel</button>
            </div>
        </div>
        <hr />
        <div id="budgetTable" class="container">
            <table class="table table-condensed">
                <thead id="budgetTableHeader">
                    <tr>
                        <th class="col-sm-3">Description</th>
                        <th class="col-sm-1">Materials</th>
                        <th class="col-sm-1">Labor</th>
                        <th class="col-sm-1">Total Budget Amount</th>
                        <th class="col-sm-1">Amount Spent to Date</th>
                        <th class="col-sm-1">Amount Requested</th>
                        <th class="col-sm-1">Balance</th>
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="d in data.Form">
                        <td ng-style="getStyle(d)" class="col-sm-3">
                            <input type="checkbox" style="display: inline-block" ng-model="d.checked" /><span>&nbsp;{{d.description}}</span></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="d.materials" money-mask /></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="d.labor" money-mask /></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="d.contract" money-mask ng-change="update(d)" /></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="d.toDay" money-mask ng-change="update(d)" /></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="d.paid" money-mask ng-change="update(d)" /></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="d.balance" money-mask readonly /></td>
                    </tr>
                    <tr style="background-color: yellow; font-weight: bolder">
                        <td>Total</td>
                        <td></td>
                        <td></td>
                        <td>
                            <input type="text" style="background-color: yellow" ng-model="data.Total.contract" money-mask readonly /></td>
                        <td>
                            <input type="text" style="background-color: yellow" ng-model="data.Total.toDay" money-mask readonly /></td>
                        <td>
                            <input type="text" style="background-color: yellow" ng-model="data.Total.paid" money-mask readonly /></td>
                        <td>
                            <input type="text" style="background-color: yellow" ng-model="data.Total.balance" money-mask readonly /></td>
                    </tr>
                </tbody>
            </table>

        </div>
    </div>

    <script>

        angular.module('PortalApp').controller('BudgetCtrl', function ($scope, $http, ptCom) {
            $scope.data = {
                BBLE: '<%= BBLE %>',
                Form: [],
                Total: {
                    contract: 0.0,
                    toDay: 0.0,
                    paid: 0.0,
                    balance: 0.0
                }
            };

            $scope.load = function () {
                var getTemplate = function () {
                    $http.get("/Scripts/res/budgetData.js")
                         .then(function (res) {
                             if (res.data) {
                                 $scope.data.Form = res.data;
                             } else {
                                 alert("Fails to get data!");
                             }
                         });
                }

                $http.get("/api/ConstructionCases/GetBudgetForm/?bble=" + $scope.data.BBLE)
                     .then(function (res) {
                         if (res.data) {
                             $scope.data = res.data;
                             $scope.updateTotal();
                         } else {
                             getTemplate();
                         }
                     })

            }
            $scope.save = function () {
                var url = "/api/ConstructionCases/BudgetForm"
                $http({
                    method: 'POST',
                    url: url,
                    data: JSON.stringify($scope.data)
                }).then(function () {
                    alert("Save Successful");
                }, function error() {
                    alert("Fails to Save.")
                })
            }

            $scope.update = function (d) {
                $scope.updateBalance(d);
                $scope.updateTotal();
            }

            $scope.updateBalance = function (d) {
                d.balance = (parseFloat(d.contract) ? parseFloat(d.contract) : 0.0) - (parseFloat(d.toDay) ? parseFloat(d.toDay) : 0.0) - (parseFloat(d.paid) ? parseFloat(d.paid) : 0.0);
            }

            $scope.updateTotal = function () {
                var total = {
                    balance: 0.0,
                    contract: 0.0,
                    toDay: 0.0,
                    paid: 0.0
                }
                _.each($scope.data.Form, function (el, i) {
                    total.contract = total.contract + (parseFloat(el.contract) ? parseFloat(el.contract) : 0.0);
                    total.toDay = total.toDay + (parseFloat(el.toDay) ? parseFloat(el.toDay) : 0.0);
                    total.paid = total.paid + (parseFloat(el.paid) ? parseFloat(el.paid) : 0.0);
                    total.balance = total.contract - total.toDay - total.paid;
                })
                $scope.data.Total = total;
            }
            $scope.getStyle = function (d) {
                if (d&& d.style) return d.style;
            }
            $scope.exportExcel = function () {
                var data = {};
                data.updata = [];
                data.bble = $scope.data.BBLE;
                _.each($scope.data.Form, function (el, i) {
                    if (el.checked) {
                        data.updata.push(el);
                    }
                })

                if (data.updata.length > 0) {
                    $http({
                        method: "POST",
                        url: "/api/ConstructionCases/GenerateExcel",
                        data: data,
                    }).then(function (res) {
                        _.each(data.updata, function (el, i) {
                            el.toDay = (parseFloat(el.toDay) ? parseFloat(el.toDay) : 0.0) + (parseFloat(el.paid) ? parseFloat(el.paid) : 0.0);
                            el.paid = 0.0;
                            $scope.updateBalance(el);
                        });
                        $scope.updateTotal();
                        console.log("Download start");
                        STDownloadFile("/api/ConstructionCases/GetGenerateExcel", "budget.xlsx" + new Date().toLocaleDateString)
                    })
                } else {
                    alert("No data select!");
                }
            }
            $scope.checkedAll = function () {
                if ($scope.checkall) {
                    _.each($scope.data.Form, function (el, i) {
                        el.checked = true;
                    })
                } else {
                    _.each($scope.data.Form, function (el, i) {
                        el.checked = false;
                    })
                }
            }
            $scope.load();
        });
    </script>
</asp:Content>
