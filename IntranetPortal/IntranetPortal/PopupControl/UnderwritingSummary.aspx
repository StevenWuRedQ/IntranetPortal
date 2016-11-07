<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingSummary.aspx.vb" Inherits="IntranetPortal.UnderwritingSummary" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .underwriting-summary table {
            width: 98%;
            table-layout: fixed;
        }

            .underwriting-summary table th {
                font-size: 12px;
                border: 1px solid #ddd;
                padding-left: 2px;
            }

            .underwriting-summary table td {
                font-size: 12px;
                border: 1px solid #ddd;
                padding-left: 2px;
            }

        .underwriting-summary td.td-label {
            padding-right: 10px;
            width: 160px;
            height: 100%;
            font-weight: bold;
        }

        .underwriting-summary td input {
            border: none;
            padding: 0;
            text-align: right;
            width: 100%;
        }

        .underwriting-summary th input {
            border: 1px solid #ddd;
            padding: 0;
            text-align: right;
            width: 100%;
        }

        .underwriting-summary textarea {
            width: 100%;
            min-height: 300px;
            resize: vertical;
        }

        .pt-panel {
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
        angular.module("PortalApp").config(function ($stateProvider) {
            var searchSummary = {
                name: 'searchSummary',
                url: '/searchSummary',
                controller: 'LeadTaxSearchCtrl',
                templateUrl: '/js/Views/LeadDocSearch/new_ds_summary.html',
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
            var audit = {
                name: 'underwriter.audit',
                url: '/audit',
                templateUrl: '/js/Views/Underwriter/audit.tpl.html'
            }
            var archived = {
                name: 'underwriter.archived',
                url: '/archived',
                templateUrl: '/js/Views/Underwriter/archived.tpl.html'
            }

            $stateProvider
                .state(searchSummary)
                .state(underwriter)
                .state(dataInput)
                .state(flipsheets)
                .state(rentalmodels)
                .state(tables)
                .state(audit)
                .state(archived)
                .state(underwriterRequest);
        })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div ng-controller="UnderwritingSummaryController" id="dataPanelDiv">
        <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
        <div style="font-size: 12px; color: #9fa1a8;">
            <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                    <a role="tab" ui-sref="searchSummary" class="tab_button_a">
                        <i class="fa fa-history head_tab_icon_padding"></i>
                        <div class="font_size_bold" style="width: 100px">Summary</div>
                    </a>
                </li>

                <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                    <a role="tab" ui-sref="underwritingRequest" class="tab_button_a">
                        <i class="fa fa-book head_tab_icon_padding"></i>
                        <div class="font_size_bold" style="width: 100px">
                            Story
                        </div>
                    </a>
                </li>

                <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                    <a role="tab" ui-sref="underwriter.datainput" class="tab_button_a">
                        <i class="fa fa-calculator head_tab_icon_padding"></i>
                        <div class="font_size_bold" style="width: 100px">
                            Underwriting
                        </div>
                    </a>
                </li>

                <li class="short_sale_head_tab activity_light_blue pull-right" ng-show="search.UnderwriteStatus < 1">
                    <a class="tab_button_a">
                        <i class="fa fa-list-ul head_tab_icon_padding"></i>
                        <div class="font_size_bold" style="width: 100px">Status</div>
                    </a>
                    <div class="shot_sale_sub">
                        <ul class="nav clearfix" role="tablist">
                            <li class="short_sale_head_tab " ng-click="markCompleted(1)">
                                <a role="tab" class="tab_button_a" data-toggle="tooltip" data-placement="bottom" title="Mark As Accept">
                                    <i class="fa fa-check head_tab_icon_padding" style="color: white !important"></i>
                                    <div class="font_size_bold" style="width: 100px">Accept</div>
                                </a>
                            </li>
                            <li class="short_sale_head_tab" ng-click="markCompleted(2)">
                                <a role="tab" class="tab_button_a" data-toggle="tooltip" data-placement="bottom" title="Mark As Reject">
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
            <div id='summary-expired-warning' ng-show="$state.current.name=='searchSummary' && search.Expired">
                <div style="background-color: yellow; width: 100%; text-align: center; color: red; padding: 0px 20px">The Search is out of date.</div>
            </div>
            <div style='padding: 2px 20px; overflow-y: scroll'>
                <ui-view></ui-view>
            </div>
            <div id='uwrhistory' class="container" style="max-width: 800px; margin-bottom: 40px" ng-show="$state.current.name=='underwritingRequest'">
                <button type="button" class="btn btn-info" ng-click="showStoryHistory()">History</button>
                <uc1:AuditLogs runat="server" ID="AuditLogs" />
            </div>
        </div>
    </div>
</asp:Content>
