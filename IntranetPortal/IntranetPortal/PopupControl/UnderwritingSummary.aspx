<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingSummary.aspx.vb" Inherits="IntranetPortal.UnderwritingSummary" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        div.flexbox {
            display: flex;
            flex-direction: row;
            align-items: stretch;
            position: fixed;
            bottom: 0;
            right: 0;
            height: 100%;
            width: 100%;
        }


        div.items-list {
            flex: 0 0 300px;
            border-right: 2px double #ccc;
        }

        div.item-detail {
            flex: auto;
            height: 100%;
            overflow-y: scroll;
        }

        body {
            font-size: 14px !important;
        }

        div table {
            width: 98%;
            table-layout: fixed;
        }

        th {
            border: 1px solid #ddd;
            padding-left: 2px;
        }

        td {
            border: 1px solid #ddd;
            padding-left: 2px;
        }

            td.td-label {
                padding-right: 10px;
                width: 160px;
                height: 100%;
                font-weight: bold;
            }

            td input {
                border: none;
                padding: 0;
                text-align: right;
                width: 100%;
            }

        th input {
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
        function showUiView() {
            $('a[data-toggle="tab"]').on('shown.bs.tab',
                function (e) {
                    // debugger;
                    if (location.hash == '#/agent_story') {
                        location.hash = '#/?BBLE=<%= Request.QueryString("BBLE")%>';
                    }
                })
            }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div id="dataPanelDiv" style="font-size: 12px; color: #9fa1a8;" ng-controller="">
        <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
            <li class="short_sale_head_tab activity_light_blue">
                <a href="#searchReslut" role="tab" data-toggle="tab" class="tab_button_a">
                    <i class="fa fa-history head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">Summary</div>
                </a>
            </li>
            <li class="short_sale_head_tab activity_light_blue">
                <a role="tab" href="#agent_story" data-toggle="tab" class="tab_button_a">
                    <i class="fa fa-book head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">
                        Story
                    </div>
                </a>
            </li>
            <li class="short_sale_head_tab activity_light_blue">
                <a role="tab" href="#agent_story" data-toggle="tab" class="tab_button_a">
                    <i class="fa fa-book head_tab_icon_padding"></i>
                    <div class="font_size_bold" style="width: 100px">
                        Story
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
        <div >

            <ui-view></ui-view>


            <div id="agent_story" class="tab-pane fade" style="padding: 20px; max-height: 850px; overflow-y: scroll">
                <script>
                    angular.module("PortalApp").config(function ($stateProvider) {
                        var underwriterRequest = {
                            name: 'underwritingRequest',
                            url: '/agent_story',
                            controller: 'UnderwritingRequestController',
                            templateUrl: '/js/Views/Underwriter/underwriting_request.tpl.html',
                            data: {
                                Review: true
                            }
                        }
                        $stateProvider.state(underwriterRequest);
                    });
                </script>
                <ui-view></ui-view>
                <hr />
                <div id='uwrhistory' class="container" style="max-width: 800px; margin-bottom: 40px">
                    <script type="text/javascript">
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
                    <button type="button" class="btn btn-info" onclick="showHistory()">History</button>
                    <uc1:AuditLogs runat="server" ID="AuditLogs" />
                </div>
            </div>


        </div>
    </div>
</asp:Content>
