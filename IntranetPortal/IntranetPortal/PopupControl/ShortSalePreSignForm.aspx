<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ShortSalePreSignForm.aspx.vb" Inherits="IntranetPortal.ShortSalePreSignForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .wizard-title {
            text-align: center;
        }

        .wizard-content {
            min-height: 400px;
        }

        .online {
            width: 100% !important;
        }

        /*Theming options - change and everything updates*/
        /*don't use more decimals, as it makes browser round errors more likely, make heights unmatching
-also watch using decimals at all at low wizardSize font sizes!*/
        .wizardbar {
            font-size: 18px;
            line-height: 1;
            display: inline-block;
            margin: 20px 0;
        }
        /*base item styles*/
        .wizardbar-item {
            display: inline-block;
            padding: 0.5em 0.8em;
            padding-left: 1.8em;
            text-decoration: none;
            transition: all .15s;
            /*default styles*/
            background-color: #76a9dd;
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            text-shadow: 1px 1px rgba(0, 0, 0, 0.2);
            position: relative;
            margin-right: 2px;
        }
            /*arrow styles*/
            .wizardbar-item:before,
            .wizardbar-item:after {
                content: "";
                height: 0;
                width: 0;
                border-width: 1em 0 1em 1em;
                border-style: solid;
                transition: all .15s;
                position: absolute;
                left: 100%;
                top: 0;
            }
            /*arrow overlapping left side of item*/
            .wizardbar-item:before {
                border-color: transparent transparent transparent white;
                left: 0;
            }
            /*arrow pointing out from right side of items*/
            .wizardbar-item:after {
                border-color: transparent transparent transparent #76a9dd;
                z-index: 1;
            }
        /*current item styles*/
        .current.wizardbar-item {
            background-color: #205081;
            color: white;
            cursor: default;
        }

            .current.wizardbar-item:after {
                border-color: transparent transparent transparent #205081;
            }
        /*hover styles*/
        .wizardbar-item:not(.current):hover {
            background-color: #3983ce;
        }

            .wizardbar-item:not(.current):hover:after {
                border-color: transparent transparent transparent #3983ce;
            }
        /*remove arrows from beginning and end*/
        .wizardbar-item:first-of-type:before,
        .wizardbar-item:last-of-type:after {
            border-color: transparent !important;
        }
        /*no inset arrow for first item*/
        .wizardbar-item:first-of-type {
            border-radius: 0.25em 0 0 0.25em;
            padding-left: 1.3em;
        }
        /*no protruding arrow for last item*/
        .wizardbar-item:last-of-type {
            border-radius: 0 0.25em 0.25em 0;
            padding-right: 1.3em;
        }

        .view-animate {
            min-height: 500px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div style="padding: 20px" ng-controller="shortSalePreSignCtrl">
        <div class="container">
            <div class="wizardbar">
                <a class="wizardbar-item {{step==$index+1?'current':'' }}" href="#" ng-repeat="s in steps|filter:{show:true}">{{s.title}} 
                </a>
            </div>
            <div style="max-width: 720px">
                <div ng-show="currentStep().title=='New Offer'" class="view-animate">
                    <h2 class="wizard-title">New Offer</h2>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="input-group">
                                <label>Select Offer type</label>
                                <select class="form-control">
                                    <option></option>
                                    <option selected>Short Sale</option>
                                    <option>Straight Sale</option>
                                    <option>Other</option>
                                </select>
                            </div>
                        </div>

                    </div>
                </div>
                <div ng-show="currentStep().title=='Search Info'" class="view-animate">
                    <h2 class="wizard-title">Check Search Information</h2>

                    <div>
                        <div style="padding:10px">
                            <table class="table table-striped">
                                <tr>
                                    <td>Property tax search - {{DocSearch.LeadResearch.propertyTaxes?'':'No'}} {{DocSearch.LeadResearch.propertyTaxes | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>Water charges - {{DocSearch.LeadResearch.waterCharges?'':'No'}} {{DocSearch.LeadResearch.waterCharges | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>ECB Violation - {{DocSearch.LeadResearch.ecbViolation?'':'No'}} {{DocSearch.LeadResearch.ecbViolation | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>DOB Violation - {{DocSearch.LeadResearch.dobWebsites?'':'No'}} {{DocSearch.LeadResearch.dobWebsites | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>Judgment - {{DocSearch.LeadResearch.judgments?'':'No'}} {{DocSearch.LeadResearch.judgments | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>IRS Tax Liens - {{DocSearch.LeadResearch.irsTaxLien?'':'No'}} {{DocSearch.LeadResearch.irsTaxLien | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>NYS Tax Liens - {{DocSearch.LeadResearch.hasNysTaxLien?'Yes':'No'}} 
                                    </td>
                                </tr>


                                <tr>
                                    <td>Mortgage - {{DocSearch.LeadResearch.mortgageAmount?'':'No'}} {{DocSearch.LeadResearch.mortgageAmount | currency}}
                                    </td>
                                </tr>
                                <tr>
                                    <td>{{ DocSearch.LeadResearch.fannie?"Has FANNIE":'Not Fannie' }} {{ DocSearch.LeadResearch.fha?" Has FHA":' Not FHA' }} 
                                    </td>
                                </tr>
                                <tr>
                                    <td>Servicer - {{DocSearch.LeadResearch.servicer}}
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>


                </div>
                <div ng-show="currentStep().title=='Pre Sign'" class="view-animate">
                    <h2 class="wizard-title">Short Sale Information</h2>

                    <div>
                        <h4 class="ss_form_title ">Borrowers</h4>
                        <div id="borrwerGrid" dx-data-grid="borrwerGrid"></div>
                    </div>
                    <div class="ss_form">
                        <h4 class="ss_form_title">Mortgage info</h4>
                        <div id=""></div>
                    </div>

                </div>
                <div ng-show="currentStep().title=='Step 1'" class="view-animate">
                    <h2 class="wizard-title">Setp 1</h2>

                </div>
                <div ng-show="currentStep().title=='Step 2'" class="view-animate">
                    <h2 class="wizard-title">Setp 2</h2>

                </div>
                <div ng-show="currentStep().title=='Finish'" class="view-animate">
                    <h2 class="wizard-title">Finish</h2>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" ng-show="step>1" ng-click="PrevStep()">< Prev</button>
                    <button type="button" class="btn btn-default" ng-click="RequestPreSign()" ng-show="step==MaxStep">Finish</button>
                    <button type="button" class="btn btn-default" ng-show="step<MaxStep" ng-click="NextStep()">Next ></button>
                </div>
            </div>
        </div>


    </div>
    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('shortSalePreSignCtrl', function ($scope, ptCom) {
            $scope.SSpreSign = {};
            $scope.steps = [
              { title: "New Offer", show: true },
              { title: "Search Info", show: true },
              { title: "Pre Sign", show: true },
              { title: "Step 1", show: true },
              { title: "Step 2", show: true },
              { title: "Finish", show: true },
            ]
            $scope.step = 1
            $scope.MaxStep = $scope.steps.length;
            $scope.currentStep = function () {
                return $scope.steps[$scope.step - 1];
            }
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
