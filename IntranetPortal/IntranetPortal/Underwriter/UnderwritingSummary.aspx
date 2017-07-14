<%@ Page Title="" Language="vb" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .underwriting-summary table {
            width: 98%;
            table-layout: fixed;
        }

            .underwriting-summary table th {
                font-size: 14px;
                border: 1px solid #ddd;
                padding-left: 2px;
            }

            .underwriting-summary table td {
                font-size: 14px;
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/signalr.js/2.2.1/jquery.signalR.min.js"></script>
    <script src="/underwritingservice/signalr/hubs"></script>
    <script>
        angular.module("PortalApp").config(function ($stateProvider) {
            var searchSummary = {
                name: 'searchSummary',
                url: '/searchSummary',
                controller: 'DocSearchController',
                templateUrl: '/js/Views/LeadDocSearch/new_ds_summary.html',
            }
            var underwriterRequest = {
                name: 'underwritingRequest',
                url: '/underwritingRequest',
                controller: 'UnderwritingRequestController',
                templateUrl: '/js/Views/Underwriting/underwriting_request.tpl.html',
                data: {
                    Review: true
                }
            }
            var underwriter = {
                name: 'underwriter',
                url: '/underwriter',
                templateUrl: '/js/Views/Underwriting/underwriting.tpl.html',
                controller: 'UnderwritingController'
            }
            var dataInput = {
                name: 'underwriter.datainput',
                url: '/datainput',
                templateUrl: '/js/Views/Underwriting/datainput.tpl.html',
            }
            var flipsheets = {
                name: 'underwriter.flipsheets',
                url: '/flipsheets',
                templateUrl: '/js/Views/Underwriting/flipsheets.tpl.html'
            }
            var rentalmodels = {
                name: 'underwriter.rentalmodels',
                url: '/rentalmodels',
                templateUrl: '/js/Views/Underwriting/rentalmodels.tpl.html'
            }
            var audit = {
                name: 'underwriter.audit',
                url: '/audit',
                templateUrl: '/js/Views/Underwriting/audit.tpl.html'
            }
            var archived = {
                name: 'underwriter.archived',
                url: '/archived',
                templateUrl: '/js/Views/Underwriting/archived.tpl.html'
            }

            $stateProvider
                .state(searchSummary)
                .state(underwriter)
                .state(dataInput)
                .state(flipsheets)
                .state(rentalmodels)
                .state(audit)
                .state(archived)
                .state(underwriterRequest);
        });
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

                <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active"> <!--ng-show="viewmode && viewmode>=2"-->
                    <a role="tab" ui-sref="underwriter.datainput" class="tab_button_a">
                        <i class="fa fa-calculator head_tab_icon_padding"></i>
                        <div class="font_size_bold" style="width: 100px">
                            Underwriting
                        </div>
                    </a>
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
