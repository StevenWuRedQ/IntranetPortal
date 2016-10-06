<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleFeeClearance.ascx.vb" Inherits="IntranetPortal.TitleFeeClearance" %>
<div ng-controller="TitleFeeClearanceCtrl" id="FeeClearanceCtrl">
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
                        <input type="text" ng-model="d.cost" ng-change="updateTotal(d)" pt-number-mask maskformat='money'/>
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
                        <input style="background-color: yellow; font-weight: bolder" type="text" ng-model="FormData.FeeClearance.total" pt-number-mask maskformat='money' disabled />
                    </td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
