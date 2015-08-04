<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CaseLawRef.aspx.vb" Inherits="IntranetPortal.CaseLawRef" MasterPageFile="~/Content.Master" %>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style>
        .caseUI .search-form {
            width: 500px;
            margin: 10px auto;
            font-size: 14px;
        }

        .caseUI .search {
            padding: 8px 15px;
            background: rgba(50, 50, 50, 0.2);
            border: 0px solid #dbdbdb;
        }

        .caseUI .button {
            position: relative;
            padding: 6px 15px;
            left: -8px;
            border: 2px solid #207cca;
            background-color: #207cca;
            color: #fafafa;
        }

            .caseUI .button:hover {
                background-color: #fafafa;
                color: #207cca;
            }

        .caseUI .ss_form_input_title {
            margin: 2px !important;
        }

        .caseUI td {
            padding: 2px !important;
            vertical-align: middle !important;
        }
    </style>
    <script src="/Scripts/ng-infinite-scroll.min.js"></script>
    <script>
        var app = angular.module('PortalApp');
        app.controller('CaseCtrl', ['$scope', '$http', 'ptCom', function ($scope, $http, ptCom) {
            $scope.Cases = [{}, ];
            $scope.ptCom = ptCom;
            $scope.formVisiable = false;

            (function () {
                $http.get('/LegalUI/LegalServices.svc/GetAllReference')
                    .then(function (response) {
                        if (response.status == 200) {
                            $scope.Cases = response.data;
                        }
                    });
            }());
            $scope.resetNewCase = function () {
                $scope.newCase = {};
                $scope.newCase.Topic = '';
                $scope.newCase.CaseName = '';
                $scope.newCase.Summary = '';
                $scope.newCase.Notes = [{}, ];
            }
            $scope.resetNewCase();

            $scope.closeForm = function () {
                $scope.resetNewCase();
                $scope.formVisiable = !$scope.formVisiable;
            }

            $scope.saveNew = function () {
                var pushFlag = $scope.newCase.RefId ? false : true;
                $http.post('/LegalUI/LegalServices.svc/SaveLaeReference', { 'lawRef': JSON.stringify($scope.newCase) })
                .then(function (response) {
                    $scope.newCase.RefId = parseInt(response.data);
                    if(pushFlag) $scope.Cases.push($scope.newCase);
                    $scope.closeForm();
                })
            }

            $scope.deleteCase = function (index) {
                var confirm = ptCom.arrayRemove($scope.Cases, index, true, function (obj) {
                    debugger;
                    $http.get('/LegalUI/LegalServices.svc/DeleteLawReference?refId=' + obj.RefId);
                });
            }

            $scope.updateCase = function (index) {
                $scope.resetNewCase();
                $scope.newCase = $scope.Cases[index];
                $scope.formVisiable = true;

            }

        }]);
    </script>
    <div class="container caseUI" ng-controller="CaseCtrl">
        <div class="row">
            <div class="search-form">
                <input class="search" style="width: 400px" type="text" placeholder="Search..." ng-model="searchCriteria" />
                <span class="button"><i class="fa fa-search"></i></span>
            </div>
            <h2 class="ss_form_title">Case&nbsp<pt-add ng-click="formVisiable=true"></pt-add></h2>
            <div ng-repeat="case in Cases|filter: searchCriteria| limitTo: 5" style="border-radius: 5px; padding: 5px; margin: 10px" ng-dblclick="updateCase($index)">
                <table class="table table-bordered" style="font-size: 13px">
                    <tr>
                        <td>
                            <label class="ss_form_input_title">Topic</label>&nbsp</td>
                        <td>
                            <input type="text" class="ss_form_input" ng-model="case.Topic" readonly /></td>
                        <td>
                            <label class="ss_form_input_title">Case name & citation</label>&nbsp</td>
                        <td>
                            <input type="text" class="ss_form_input" ng-model="case.CaseName" readonly />
                            <pt-del ng-class="'pull-right'" ng-click="deleteCase($index)"></pt-del>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="ss_form_input_title">Summary</label>&nbsp</td>
                        <td colspan="3">
                            <input type="text" class="ss_form_input" ng-model="case.Summary" readonly /></td>
                    </tr>
                    <tr>
                        <td>
                            <label class="ss_form_input_title">Notes</label>&nbsp</td>
                        <td colspan="3">
                            <div ng-repeat="note in case.Notes">
                                <textarea class="edit_text_area text_area_ss_form" ng-model="note.content" readonly></textarea>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div dx-popup="{
                    showTitle: false,
                    width: 650,
                    contentTemplate: 'formContent',
                    bindingOptions: {
                        visible: 'formVisiable'
                    }
                }">

            <div data-options="dxTemplate: { name: 'formContent'}">

                <div class="row">
                    <h2 class="ss_form_title">Add New Law Reference</h2>
                    <br />
                    <div>
                        <label>Topic</label>
                        <input class="form-control" type="text" ng-model="newCase.Topic" />
                    </div>
                    <div>
                        <label>Case Name & citation</label>
                        <input class="form-control" type="text" ng-model="newCase.CaseName" />
                    </div>
                    <div>
                        <label>Summary</label>
                        <input class="form-control" type="text" ng-model="newCase.Summary" />
                    </div>
                    <div>
                        <label>Note&nbsp<pt-add ng-click="ptCom.arrayAdd(newCase.Notes)"></pt-add></label>
                        <div ng-repeat="note in newCase.Notes">
                            <textarea class="edit_text_area text_area_ss_form" ng-model="note.content" style="width: 95%"></textarea>
                            <span>
                                <pt-del ng-class="'pull-right'" ng-click="ptCom.arrayRemove(newCase.Notes, $index)"></pt-del>
                            </span>
                        </div>
                    </div>
                    <hr />
                    <div class="pull-right">
                        <button class="btn btn-danger" ng-click="closeForm()">Cancel</button>
                        <button class="btn btn-primary" ng-click="saveNew()">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

