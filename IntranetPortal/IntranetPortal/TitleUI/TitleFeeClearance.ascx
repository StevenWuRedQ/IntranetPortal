<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleFeeClearance.ascx.vb" Inherits="IntranetPortal.TitleFeeClearance" %>
<div ng-controller="FeeClearanceCtrl" id="FeeClearanceCtrl">
    <style>
        .contentTable {
            font-size: 14px;
        }

            .contentTable td > input {
                border: none;
            }

            .contentTable table {
                width: 100%;
                table-layout: fixed;
            }

            .contentTable input[type=text] {
                width: 100%;
                padding: 2px;
            }

        .contentTableHeader {
            position: relative;
            top: 0;
        }
    </style>
    <%-- 
    <div>
        <div>
            <button type="button" class="btn btn-success pull-right" ng-click="exportExcel()"><i class="fa fa-file-excel-o">&nbsp;</i>Export Excel</button>
        </div>
    </div>
    --%>
    <br />
    <div class="contentTable">
        <table class="table table-condensed">
            <thead class="contentTableHeader">
                <tr>
                    <th class="col-sm-1">Fees</th>
                    <th class="col-sm-1"></th>
                    <th class="col-sm-1"></th>
                    <th class="col-sm-2"></th>
                    <th class="col-sm-1"></th>
                </tr>
            </thead>
            <tbody>
                <tr ng-repeat="d in FormData.FeeClearance.data">
                    <td class="col-sm-1">{{$index}}
                    </td>
                    <td class="col-sm-1">{{d.name}}
                    </td>
                    <td class="col-sm-1">
                        <input type="text" ng-model="d.cost" ng-change="updateTotal(d)" money-mask/>
                    </td>
                    <td class="col-sm-2">
                        <input type="text" ng-model="d.note" placeholder="add notes"/>
                    </td>
                    <td class="col-sm-1">{{d.lastupdate|date : 'MM/dd/yyyy'}}
                    </td>
                </tr>
                <tr style="background-color: yellow; font-weight: bolder">
                    <td></td>
                    <td>Total</td>
                    <td>
                        <input style="background-color: yellow; font-weight: bolder" type="text" ng-model="FormData.FeeClearance.total" money-mask disabled />
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<script>
    angular.module("PortalApp").controller('FeeClearanceCtrl', function ($scope) {
        var FeeClearanceModel = function () {
            this.data = [
                {
                    name: 'Purchase Price',
                    cost: 0.0,
                    lastupdate: null, note: ''

                },
                {
                    name: '2nd Lien',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'Taxes due',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'Water',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'Multi Dwelling',
                    cost: 0.0,
                    lastupdate: null, note: ''

                },
                {
                    name: 'PVB',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'ECBS',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'Judgments',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'Taxes on HUD',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'Water on HUD',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'HPD on HUD',
                    cost: 0.0,
                    lastupdate: null, note: ''
                },
                {
                    name: 'ECB on hud',
                    cost: 0.0,
                    lastupdate: null, note: ''
                }],
            this.total = 0.0

        }

        $scope.FormData = $scope.$parent.Form.FormData;
        $scope.FormData.FeeClearance = new FeeClearanceModel();
        $scope.reload = function () {
            $scope.FormData = $scope.$parent.Form.FormData;
            if ($scope.$parent.Form.FormData.FeeClearance) {
                $scope.FormData.FeeClearance = $scope.FormData.FeeClearance;
            } else {
                $scope.FormData.FeeClearance = new FeeClearanceModel();
            }
        }
        $scope.updateTotal = function (d) {
            d.lastupdate = new Date();

            var total = 0.0;
            _.each($scope.FormData.FeeClearance.data, function (el, idx) {
                total += parseFloat(el.cost);
            })
            $scope.FormData.FeeClearance.total = total;
        }
        $scope.$on('clearance-reload', function (e, args) {
            $scope.reload();
        })
    })

</script>
