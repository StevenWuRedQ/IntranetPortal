<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetForm.aspx.vb" Inherits="IntranetPortal.ConstructionBudgetForm" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="BudgetCtrl" ng-controller="BudgetCtrl">
        <div class="budgetTitle">
            <h3>Budget Form</h3>
            <div>
                <button type="button" class="btn btn-success btn-sm pull-right" ng-click="exportExcel()">Export Excel</button>
            </div>
        </div>
        <table class="table table-condensed">
            <tr>
                <th style="width: 180px">Description</th>
                <th style="width: 60px">Materials</th>
                <th style="width: 60px">Labor</th>
                <th style="width: 60px">Total Budget Amount</th>
                <th style="width: 60px">Amount Spent to Date</th>
                <th style="width: 60px">Amount Requested</th>
                <th style="width: 60px">Balance</th>
            </tr>
            <tr ng-repeat="d in data.Form ">
                <td ng-style="getStyle(d)">
                    <input type="checkbox" ng-model="d.checked" style="display: inline-block" /><span>{{d.description}}</span></td>
                <td>
                    <input style="width: 60px; border: none" ng-model="d.materials" money-mask /></td>
                <td>
                    <input style="width: 60px; border: none" ng-model="d.labor" money-mask /></td>
                <td>
                    <input style="width: 60px; border: none" ng-model="d.contract" money-mask ng-change="update(d)" /></td>
                <td>
                    <input style="width: 60px; border: none" ng-model="d.toDay" money-mask ng-change="update(d)" /></td>
                <td>
                    <input style="width: 60px; border: none" ng-model="d.paid" money-mask ng-change="update(d)" /></td>
                <td>
                    <input style="width: 60px; border: none" ng-model="d.balance" money-mask readonly /></td>
            </tr>
            <tr style="background-color: yellow; font-weight: bolder">
                <td>Total</td>
                <td></td>
                <td></td>
                <td>
                    <input style="width: 60px; border: none; background-color: yellow" ng-model="data.Total.contract" money-mask readonly /></td>
                <td>
                    <input style="width: 60px; border: none; background-color: yellow" ng-model="data.Total.toDay" money-mask readonly /></td>
                <td>
                    <input style="width: 60px; border: none; background-color: yellow" ng-model="data.Total.paid" money-mask readonly /></td>
                <td>
                    <input style="width: 60px; border: none; background-color: yellow" ng-model="data.Total.balance" money-mask readonly /></td>
            </tr>
        </table>
    </div>
    <script>

        angular.module('PortalApp').controller('BudgetCtrl', function ($scope, $http, ptCom) {
            $scope.data = {
                BBLE: '<%= BBLE %>',
                Form: {},
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

                $http.get("/api/ConstructionCases/GetBudgetForm/?bble" + $scope.data.BBLE)
                     .then(function (res) {
                         if (res.data) {
                             $scope.data.Form = res.data
                         } else {
                             getTemplate();
                         }
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
                if (d.style) return d.style;
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
        });
    </script>

</asp:Content>
