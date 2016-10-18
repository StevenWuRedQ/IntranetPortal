<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingSummary.aspx.vb" Inherits="IntranetPortal.UnderwritingSummary" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        div#underwriting-summary table {
            width: 98%;
            table-layout: fixed;
        }

            div#underwriting-summary table th {
                font-size: 12px;
                border: 1px solid #ddd;
                padding-left: 2px;
            }

            div#underwriting-summary table td {
                font-size: 12px;
                border: 1px solid #ddd;
                padding-left: 2px;
            }

        div#underwriting-summary td.td-label {
            padding-right: 10px;
            width: 160px;
            height: 100%;
            font-weight: bold;
        }

        div#underwriting-summary td input {
            border: none;
            padding: 0;
            text-align: right;
            width: 100%;
        }

        div#underwriting-summary th input {
            border: 1px solid #ddd;
            padding: 0;
            text-align: right;
            width: 100%;
        }

        div textarea {
            width: 100%;
            min-height: 300px;
            resize: vertical;
        }

        div .pt-panel {
            margin: 10px 2px;
        }

        .excel-green {
            background: #D4FFD4;
        }

        .excel-yellow {
            background: yellow;
        }

        .excel-blue {
            background: #00b0f0;
        }

        .excel-orange {
            background: orange;
        }

        .excel-default {
            background: black;
            color: white;
        }
    </style>
    <script>
        function getUWRID() {
            //debugger;
            var scope = angular.element('#uwrview').scope();
            return scope.data.Id;

        }
        function showHistory() {
            var id = getUWRID()
            if (id) {
                auditLog.toggle('UnderwritingRequest', id);
            }
        }
    </script>
    <script>
        angular.module("PortalApp").config(function ($stateProvider) {
            var searchSummary = {
                name: 'searchSummary',
                url: '/searchSummary',
                controller: 'LeadTaxSearchCtrl',
                templateUrl: '/js/Views/Underwriter/searchsummary.tpl.html',
            }

            var underwriterRequest = {
                name: 'underwritingRequest',
                url: '/underwritingRequest',
                controller: 'UnderwritingRequestController',
                templateUrl: '/js/Views/Underwriter/underwriting_request.tpl.html',
                data: {
                    Review: true
                }
            }

            var underwriter = {
                name: 'underwriter',
                url: '/underwriter',
                templateUrl: '/js/Views/Underwriter/underwriting.tpl.html',
                controller: 'UnderwriterController'
            }

            var dataInput = {
                name: 'underwriter.datainput',
                url: '/datainput',
                templateUrl: '/js/Views/Underwriter/datainput.tpl.html',
            }
            var flipsheets = {
                name: 'underwriter.flipsheets',
                url: '/flipsheets',
                templateUrl: '/js/Views/Underwriter/flipsheets.tpl.html'
            }
            var rentalmodels = {
                name: 'underwriter.rentalmodels',
                url: '/rentalmodels',
                templateUrl: '/js/Views/Underwriter/rentalmodels.tpl.html'
            }
            var tables = {
                name: 'underwriter.tables',
                url: '/tables',
                templateUrl: '/js/Views/Underwriter/tables.tpl.html'
            }

            $stateProvider
                .state(searchSummary)
                .state(underwriter)
                .state(dataInput)
                .state(flipsheets)
                .state(rentalmodels)
                .state(tables)
                .state(underwriterRequest);
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
    <div id="dataPanelDiv" style="font-size: 12px; color: #9fa1a8;">
        <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
            <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                <a role="tab" href="#searchSummary?BBLE=<%=  Request.QueryString("BBLE") %>" class="tab_button_a">
                    <i class="fa fa-history head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">Summary</div>
                </a>
            </li>
            <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                <a role="tab" href="#underwritingRequest?BBLE=<%=  Request.QueryString("BBLE") %>" class="tab_button_a">
                    <i class="fa fa-book head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">
                        Story
                    </div>
                </a>
            </li>
            <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                <a role="tab" href="#underwriter/datainput?BBLE=<%=  Request.QueryString("BBLE") %>" class="tab_button_a">
                    <i class="fa fa-calculator head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">
                        Calculate
                    </div>
                </a>
            </li>


            <li class="short_sale_head_tab activity_light_blue pull-right">
                <a class="tab_button_a">
                    <i class="fa fa-list-ul head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">Status</div>
                </a>
                <div class="shot_sale_sub">
                    <ul class="nav  clearfix" role="tablist">
                        <li class="short_sale_head_tab " ng-click="markCompleted(1)">
                            <a role="tab" class="tab_button_a" ata-toggle="tooltip" data-placement="bottom" title="Mark As Accept">
                                <i class="fa fa-check head_tab_icon_padding" style="color: white !important"></i>
                                <div class="font_size_bold" style="width: 100px">Accpet</div>
                            </a>
                        </li>
                        <li class="short_sale_head_tab" ng-click="markCompleted(2)">
                            <a role="tab" class="tab_button_a" ata-toggle="tooltip" data-placement="bottom" title="Mark As Reject">
                                <i class="fa fa-times head_tab_icon_padding" style="color: white !important"></i>
                                <div class="font_size_bold" style="width: 100px">Reject</div>
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
    <div id="underwriting-summary">


        <ui-view></ui-view>


        <div id='uwrhistory' class="container" style="max-width: 800px; margin-bottom: 40px" ng-show="$state.current.name=='underwritingRequest'">
            <button type="button" class="btn btn-info" onclick="showHistory()">History</button>
            <uc1:AuditLogs runat="server" ID="AuditLogs" />
        </div>
    </di>
</asp:Content>
