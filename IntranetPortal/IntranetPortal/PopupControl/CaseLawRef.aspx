<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CaseLawRef.aspx.vb" Inherits="IntranetPortal.CaseLawRef" MasterPageFile="~/Content.Master" %>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style>
        .search-form {
            width: 800px;
            margin: 50px auto;
            font-size: 14px;
        }

        .search {
            padding: 8px 15px;
            background: rgba(50, 50, 50, 0.2);
            border: 0px solid #dbdbdb;
        }

        .button {
            position: relative;
            padding: 6px 15px;
            left: -8px;
            border: 2px solid #207cca;
            background-color: #207cca;
            color: #fafafa;
        }

            .button:hover {
                background-color: #fafafa;
                color: #207cca;
            }

        .ss_form_input_title {
            margin: 2px;
        }
    </style>
    <script>
        var app = angular.module('PortalApp');
        app.controller('CaseCtrl', ['$scope', function ($scope) {
            $scope.cases = [{}, ];
        }]);
    </script>
    <div class="container" ng-controller="CaseCtrl">
        <div class="search-form col-md-offset-2 col-md-8">
            <input class="search" type="text" placeholder="Search..." ng-model="searchCriteria"/>
            <span class="button"><i class="fa fa-search"></i></span>
        </div>
        <h2 class="ss_form_title">Case</h2>
        <div class="row" ng-repeat="case in cases|filter: searchCriteria" style="border-radius: 5px; padding: 5px; margin: 10px">
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

</asp:Content>
