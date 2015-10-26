<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleFeeClearance.ascx.vb" Inherits="IntranetPortal.TitleFeeClearance" %>
<div>
    <style>
        .contentTable {
            font-size: 14px;
        }

            .contentTable td > input {
                border: none;
            }

            .contentTable table {
                width: 900px;
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

     <div class="container">
            <h3 class="ss_form_title text-center">Budget Form</h3>
            <div>
                <button type="button" class="btn btn-primary pull-right" ng-click="save()"><i class="fa fa-floppy-o"></i>&nbsp;Save</button>
                <span class="pull-right">&nbsp;&nbsp;</span>
                <button type="button" class="btn btn-success pull-right" ng-click="exportExcel()"><i class="fa fa-file-excel-o">&nbsp;</i>Export Excel</button>
            </div>
        </div>
        <hr />
        <div class="container contentTable">
            <table class="table table-condensed">
                <thead class="contentTableHeader">
                    <tr>
                        <th class="col-sm-3">Fees</th>
                        <th class="col-sm-1"></th>
                        <th class="col-sm-1"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="d in data.Form">
                        <td class="col-sm-1"></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="" /></td>
                        <td class="col-sm-1">
                            <input type="text" ng-model="" money-mask ng-change="" /></td>
                    </tr>
                    <tr style="background-color: yellow; font-weight: bolder">
                        <td></td>
                        <td>Total</td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

</div>
