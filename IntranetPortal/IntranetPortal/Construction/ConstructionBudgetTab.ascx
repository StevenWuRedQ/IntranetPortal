<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetTab.ascx.vb" Inherits="IntranetPortal.ConstructionBudgetTab" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpreadsheet.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpreadsheet" TagPrefix="dx" %>
<div id="BudgetCtrl" ng-controller="BudgetCtrl">
    <div class="budgetTitle">
        <h3>Budget Form</h3>
        <div>
            <%--  <span style="position: relative; top: 10px;">
                <input type="checkbox" style="display: inline-block" ng-model="checkall" ng-change="checkedAll()" />CheckAll</span>--%>
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
        <tr ng-repeat="d in data.form ">
            <td ng-style="getStyle(d)" popover-template="budgetPopover" popover-placement="bottom" popover-trigger="mouseenter">
                <input type="checkbox" ng-model="d.checked" style="display: inline-block" /><span>{{d.description}}</span></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.materials" number-mask maskformat='money' /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.labor" number-mask maskformat='money' /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.contract" number-mask maskformat='money' ng-change="update(d)" /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.toDay" number-mask maskformat='money' ng-change="update(d)" /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.paid" number-mask maskformat='money' ng-change="update(d)" /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.balance" number-mask maskformat='money' readonly /></td>
        </tr>
        <tr style="background-color: yellow; font-weight: bolder">
            <td>Total</td>
            <td></td>
            <td></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.contract" number-mask maskformat='money' readonly /></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.toDay" number-mask maskformat='money' readonly /></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.paid" number-mask maskformat='money' readonly /></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.balance" number-mask maskformat='money' readonly /></td>
        </tr>
    </table>
</div>
<script>

    angular.module('PortalApp').controller('BudgetCtrl', function ($scope, $http, ptCom) {
        $scope.data = {};
        $scope.init = function () {
            $scope.template = {};
            $scope.template.total = {
                "balance": 0.0,
                "contract": 0.0,
                "toDay": 0.0,
                "paid": 0.0,
            }
            $http.get("/Scripts/res/budgetData.js")
                .then(function (res) {
                    $scope.template.form = res.data;
                    $scope.data = $scope.template;
                });


        }();
        $scope.reload = function () {
            var newData = _.clone($scope.template, true);
            $scope.data = newData;
            $scope.linkCreated = false;
        }
        $scope.load = function (data) {
            $scope.data = data;
        }
        $scope.get = function () {
            return $scope.data;
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
            _.each($scope.data.form, function (el, i) {
                total.contract = total.contract + (parseFloat(el.contract) ? parseFloat(el.contract) : 0.0);
                total.toDay = total.toDay + (parseFloat(el.toDay) ? parseFloat(el.toDay) : 0.0);
                total.paid = total.paid + (parseFloat(el.paid) ? parseFloat(el.paid) : 0.0);
                total.balance = total.contract - total.toDay - total.paid;
            })
            $scope.total = total;
        }
        $scope.getStyle = function (d) {
            if (d.style) return d.style;
        }
        $scope.exportExcel = function () {
            var data = {};
            data.updata = [];
            data.bble = $scope.$parent.CSCase.BBLE;
            _.each($scope.data.form, function (el, i) {
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
                    STDownloadFile("/api/ConstructionCases/GetGenerateExcel", "budget.xlsx"+new Date().toLocaleDateString)
                   
                })
            } else {
                alert("No data select!");
            }    
        }
        $scope.checkedAll = function () {
            if ($scope.checkall) {
                _.each($scope.data.form, function (el, i) {
                    el.checked = true;
                })
            } else {
                _.each($scope.data.form, function (el, i) {
                    el.checked = false;
                })
            }

        }
    });

    var budgetCtrl = {};
    $(function () {
        budgetCtrl = (function () {
            var scope = angular.element(document.getElementById("BudgetCtrl")).scope();
            return {
                get: scope.get,
                load: scope.load,
                reload: scope.reload
            }
        })();
    })


</script>
