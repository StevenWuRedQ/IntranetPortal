<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetTab.ascx.vb" Inherits="IntranetPortal.ConstructionBudgetTab" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpreadsheet.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpreadsheet" TagPrefix="dx" %>
<div id="BudgetCtrl" ng-controller="BudgetCtrl">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2014-11-29/FileSaver.min.js"></script>
    <div class="budgetTitle">
        <h3>Budget Form</h3>
        <div>
            <span style="position: relative; top: 10px;">
                <input type="checkbox" style="display: inline-block" ng-model="checkall" ng-change="updateAll()" />CheckAll</span>
            <button type="button" class="btn btn-success btn-sm pull-right" ng-click="exportExcel()">Export Excel</button>
        </div>
    </div>

    <table class="table table-condensed">
        <tr>
            <th style="width: 180px">Description</th>
            <th style="width: 60px">Estimate</th>
            <th style="width: 60px">Qty</th>
            <th style="width: 60px">Materials</th>
            <th style="width: 60px">Labor</th>
            <th style="width: 60px">Contract Price</th>
            <th style="width: 60px">Paid</th>
            <th style="width: 60px">Balance</th>
        </tr>
        <tr ng-repeat="d in data.form ">
            <td ng-style="getStyle(d)" popover-template="budgetPopover" popover-placement="bottom" popover-trigger="mouseenter">
                <input type="checkbox" ng-model="d.checked" style="display: inline-block" /><span>{{d.description}}</span></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.estimate" money-mask ng-change="updateTotal()" /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.qty" integer-mask /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.materials" money-mask /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.labor" money-mask /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.contract" money-mask ng-change="update(d)" /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.paid" money-mask ng-change="update(d)" /></td>
            <td>
                <input style="width: 60px; border: none" ng-model="d.balance" money-mask ng-change="updateTotal()" /></td>
        </tr>
        <tr style="background-color: yellow; font-weight: bolder">
            <td>Total</td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.estimate" money-mask readonly /></td>
            <td></td>
            <td></td>
            <td></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.contract" money-mask readonly /></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.paid" money-mask readonly /></td>
            <td>
                <input style="width: 60px; border: none; background-color: yellow" ng-model="total.balance" money-mask readonly /></td>
        </tr>
    </table>
</div>
<script>

    angular.module('PortalApp').controller('BudgetCtrl', function ($scope, $http, ptCom) {
        $scope.data = {};
        $scope.init = function () {
            $scope.template = {};
            $scope.template.total = {
                "balance": "",
                "estimate": "",
                "contract": "",
                "paid": "",
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
            d.balance = d.contract - d.paid;
        }
        $scope.updateTotal = function () {
            var total = {
                balance: 0.0,
                estimate: 0.0,
                contract: 0.0,
                paid: 0.0
            }
            _.each($scope.data.form, function (el, i) {
                total.estimate = parseFloat(el.estimate) ? total.estimate + parseFloat(el.estimate) : total.estimate;
                total.contract = parseFloat(el.contract) ? total.contract + parseFloat(el.contract) : total.contract;
                total.paid = parseFloat(el.paid) ? total.paid + parseFloat(el.paid) : total.paid;
                total.balance = parseFloat(el.balance) ? total.balance + parseFloat(el.balance) : total.balance;
            })
            $scope.total = total;
        }
        $scope.getStyle = function (d) {
            if (d.style) return d.style;
        }
        $scope.exportExcel = function () {
            var updata = []
            _.each($scope.data.form, function (el, i) {
                if (el.checked) {
                    updata.push(el);
                }
            })
            if (updata.length > 0) {
                $http({
                    method: "POST",
                    url: "/api/ConstructionCases/GenerateExcel",
                    data: JSON.stringify(updata),
                }).then(function (res) {
                    console.log("Download start")
                })
            } else {
                alert("No data select!");
            }
        }
        $scope.updateAll = function () {
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
