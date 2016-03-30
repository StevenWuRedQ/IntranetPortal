<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ShortSalePreSignForm.aspx.vb" Inherits="IntranetPortal.ShortSalePreSignForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div style="padding: 20px" ng-controller="shortSalePreSignCtrl">
        <div ng-show="step==1">
            <h2>Short Sale Information</h2>

            <div>
                <h4 class="ss_form_title ">Borrowers</h4>
                <div id="borrwerGrid" dx-data-grid="borrwerGrid"></div>
            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Mortgage info</h4>
                <div id=""></div>
            </div>
        </div>
        <div ng-show="step==2">
            <h2>Setp 2</h2>

           
        </div>
          <div ng-show="step==3">
            <h2>Setp 3</h2>

        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" ng-show="step>1" ng-click="PrevStep()">< Prev</button>
            <button type="button" class="btn btn-default" ng-click="RequestPreSign()" ng-show="step==MaxStep">Request Sign</button>
            <button type="button" class="btn btn-default" ng-show="step<MaxStep" ng-click="NextStep()">Next ></button>
        </div>
    </div>
    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('shortSalePreSignCtrl', function ($scope, ptCom) {
            $scope.SSpreSign = {};
            $scope.step = 1
            $scope.MaxStep = 3
            $scope.NextStep = function () {
                $scope.step++;
            }
            $scope.PrevStep = function () {
                $scope.step--;
            }
            $scope.borrwerGrid = {
                dataSource: [{ Name: "Borrower 1", "Address": "123 Main ST, New York NY 10001", "SSN": "123456789", "Phone": "212 123456", "Email": "email@gmail.com", "MailAddress": "123 Main ST, New York NY 10001" }],
                columns: ['Name', 'Address', 'SSN', 'Email', 'Phone', {
                    dataField: "Type",
                    lookup: {
                        dataSource: ["Borrower", "Co-Borrower"],
                    }
                }, 'MailAddress'],
                editing: {
                    editEnabled: true,
                    insertEnabled: true,
                    removeEnabled: true
                }
            }
        })

    </script>
</asp:Content>
