<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LeadTaxSearchRequest.aspx.vb" Inherits="IntranetPortal.LeadTaxSearchRequest" %>
<%-- 
According To different mode in url, Page will show in different behavier
mode 0(or no mode): DocSearch Mode, user can modify search, user cannot view story, user cannot view underwriting status, user cannot export
mode 1: Sales Executive mode, user can view but not modified search, user can view story but not story history, user cannot view underwriting status, cuser cannot view export
mode 2: underwriter mode,  user can view but not modified search, user can view story and story history, user can change underwriting status, cuser can export excel
--%>

<%@ Register Src="~/LeadDocSearch/LeadDocSearchList.ascx" TagPrefix="uc1" TagName="LeadDocSearchList" %>
<%@ Register Src="~/PopupControl/LeadSearchSummery.ascx" TagPrefix="uc1" TagName="LeadSearchSummery" %>
<%@ Register Src="~/LeadDocSearch/DocSearchOldVersion.ascx" TagPrefix="uc1" TagName="DocSearchOldVersion" %>
<%@ Register Src="~/LeadDocSearch/DocSearchNewVersion.ascx" TagPrefix="uc1" TagName="DocSearchNewVersion" %>
<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
    <input type="hidden" id="mode" value="<%= Request.QueryString("mode")%>" />
    <div id="LeadTaxSearchCtrl" ng-controller="LeadTaxSearchCtrl">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
            <Panes>
                <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <uc1:LeadDocSearchList runat="server" ID="LeadDocSearchList" />
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <%-- search panel --%>
                <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="None" PaneStyle-Paddings-Padding="0px" Name="dataPane">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <div id="dataPanelDiv">
                                <div style="align-content: center; height: 100%">
                                    <div class="legal-menu row " style="margin-left: 0px; margin-right: 0px">
                                        <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                                            <li class="active short_sale_head_tab">
                                                <a href="#LegalTab" role="tab" data-toggle="tab" class="tab_button_a">
                                                    <i class="fa fa-search head_tab_icon_padding"></i>
                                                    <div class="font_size_bold" id="LegalTabHead">Searches</div>
                                                </a>
                                            </li>
                                            <% If Nothing Is Request.QueryString("mode") OrElse CInt(Request.QueryString("mode")) < 1 %>
                                            <li style="margin-right: 30px; color: #ffa484; float: right">
                                                <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="Save" ng-click="SearchComplete(true)"></i>
                                            </li>
                                            <% End if %>
                                        </ul>
                                    </div>
                                </div>
                                <uc1:DocSearchNewVersion runat="server" ID="DocSearchNewVersion" />
                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <%-- log panel --%>
                <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9" PaneStyle-Paddings-Padding="0px" Name="LogPanel">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <div id="dataPanelDiv" style="font-size: 12px; color: #9fa1a8;">
                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                                    <li class="short_sale_head_tab activity_light_blue">
                                        <a href="#searchReslut" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-history head_tab_icon_padding"></i>
                                            <div class="font_size_bold" style="width: 100px">Summary</div>
                                        </a>
                                    </li>

                                    <% If CInt(Request.QueryString("mode")) >= 1 %>
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
                                    <li class="short_sale_head_tab activity_light_blue" onclick="showUiView()">
                                        <a role="tab" href="#agent_story" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-book head_tab_icon_padding"></i>
                                            <div class="font_size_bold" style="width: 100px">
                                                Story
                                            </div>
                                        </a>
                                    </li>
                                    <% End if %>
                                    <% If CInt(Request.QueryString("mode")) >= 3 %>
                                    <li class="short_sale_head_tab activity_light_blue pull-right" onclick="exportsheet()">
                                        <a role="tab" class="tab_button_a">
                                            <i class="fa fa-file-excel-o head_tab_icon_padding" style="color: white !important"></i>
                                            <div class="font_size_bold" style="width: 100px">Export</div>
                                        </a>
                                    </li>

                                    <li class="short_sale_head_tab activity_light_blue pull-right" ng-show="!DocSearch.UnderwriteStatus">
                                        <a class="tab_button_a">
                                            <i class="fa fa-list-ul head_tab_icon_padding"></i>
                                            <div class="font_size_bold" style="width: 100px">Status</div>
                                        </a>
                                        <div class="shot_sale_sub">
                                            <ul class="nav  clearfix" role="tablist">

                                                <li class="short_sale_head_tab " ng-click="markCompleted(1)">
                                                    <a role="tab" class="tab_button_a" ata-toggle="tooltip" data-placement="bottom" title="Mark As Accept">
                                                        <i class="fa fa-check head_tab_icon_padding" style="color: white !important"></i>
                                                        <div class="font_size_bold" style="width: 100px">Accept</div>
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
                                    <% End If %>
                                </ul>
                                <div class="tab-content">
                                    <div id="searchReslut" class="tab-pane fade in active" style="padding: 20px; max-height: 850px; overflow-y: scroll">
                                        <div class="alert alert-info" ng-show="DocSearch.UnderwriteStatus > 0 && viewmode>2">
                                            <h5>The Underwriting {{DocSearch.UnderwriteStatus==1?'Completed':'Rejected'}} by {{DocSearch.UnderwriteCompletedBy}} on {{DocSearch.UnderwriteCompletedOn | date:'MM/dd/yyyy'}}!</h5>
                                            <h5>
                                                <b>Comments:</b>
                                                {{DocSearch.UnderwriteCompletedNotes || "None"}}

                                            </h5>
                                        </div>
                                        <new-ds-summary id="new-ds-summary" docsearch="DocSearch" leadsinfo="LeadsInfo" summary="DocSearch.LeadResearch" updateby="DocSearch.UpdateBy" updateon="DocSearch.UpdateDate" viewmode="viewmode"></new-ds-summary>
                                    </div>
                                    <% If CInt(Request.QueryString("mode")) >= 1 Then %>
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
                                        <% End If %>
                                        <% If CInt(Request.QueryString("mode")) >= 2 Then %>
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
                                    <% End If %>
                                </div>
                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>

    <script>
        function LoadSearch(bble) {
            angular.element(document.getElementById('LeadTaxSearchCtrl')).scope().init(bble);
        }

        function exportsheet() {
            var bble = $("#BBLE").val();
            if (!bble) {
                alert("Cannot export for empty file.")
            } else {
                var url = "/api/underwriter/generatexml/" + bble;
                $.ajax({
                    method: "GET",
                    url: url,
                }).then(function (res) {
                    STDownloadFile("/api/underwriter/getgeneratedxml/" + bble, "underwriter.xlsx" + new Date().toLocaleDateString)
                })
            }

        }

        portalApp.config(['$httpProvider', function ($httpProvider) {
            $httpProvider.interceptors.push('PortalHttpInterceptor');
        }]);


    </script>
</asp:Content>
