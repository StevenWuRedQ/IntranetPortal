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
        app.controller('CaseCtrl', ['$scope', 'ptCom', function ($scope, ptCom) {
            $scope.Cases = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}];
            $scope.ptCom = ptCom;
            $scope.totalItems = $scope.Cases.length;
            $scope.itemsPerPage = 5;
            $scope.currentPage = 1;
        }]);
    </script>
    <div class="container caseUI" ng-controller="CaseCtrl">
        <div class="row">
            <div class="search-form">
                <input class="search" style="width: 400px" type="text" placeholder="Search..." ng-model="searchCriteria" />
                <span class="button"><i class="fa fa-search"></i></span>
            </div>
            <h2 class="ss_form_title">Case&nbsp<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="ptCom.arrayAdd(Cases,'Cases')" title="Add"></i></h2>
                <div ng-repeat="case in Cases|filter: searchCriteria| limitTo: 5" style="border-radius: 5px; padding: 5px; margin: 10px" >
                    <table class="table table-bordered" style="font-size: 13px">
                        <tr>
                            <td>
                                <label class="ss_form_input_title">Topic</label>&nbsp</td>
                            <td>
                                <input type="text" ng-model="case.topic" /></td>
                        </tr>
                        <tr>
                            <td>
                                <label class="ss_form_input_title">Case name & citation</label>&nbsp</td>
                            <td>
                                <input type="text" ng-model="case.name" /></td>
                        </tr>
                        <tr>
                            <td>
                                <label class="ss_form_input_title">Summary</label>&nbsp</td>
                            <td>
                                <textarea ng-model="case.summary" rows="4" cols="80" style="resize: none" /></td>
                        </tr>
                    </table>
                </div>
            </div>
    </div>

</asp:Content>
