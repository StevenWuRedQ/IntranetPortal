<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LeadTaxSearchRequest.aspx.vb" Inherits="IntranetPortal.LeadTaxSearchRequest" %>


<%@ Register Src="~/LeadDocSearch/LeadDocSearchList.ascx" TagPrefix="uc1" TagName="LeadDocSearchList" %>
<%@ Register Src="~/PopupControl/LeadSearchSummery.ascx" TagPrefix="uc1" TagName="LeadSearchSummery" %>
<%@ Register Src="~/LeadDocSearch/DocSearchOldVersion.ascx" TagPrefix="uc1" TagName="DocSearchOldVersion" %>
<%@ Register Src="~/LeadDocSearch/DocSearchNewVersion.ascx" TagPrefix="uc1" TagName="DocSearchNewVersion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
    <input type="hidden" id="ShowInfo" value="<%= Request.QueryString("si")%>" />
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
                            <div>
                                <div style="align-content: center; height: 100%">
                                    <div class="legal-menu row " style="margin-left: 0px; margin-right: 0px">
                                        <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                                            <li class="active short_sale_head_tab">
                                                <a href="#LegalTab" role="tab" data-toggle="tab" class="tab_button_a">
                                                    <i class="fa fa-search head_tab_icon_padding"></i>
                                                    <div class="font_size_bold" id="LegalTabHead">Searches</div>
                                                </a>
                                            </li>
                                            <li style="margin-right: 30px; color: #ffa484; float: right">
                                                <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="Save" ng-click="SearchComplete(true)"></i>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div ng-if="newVersion">
                                    <uc1:DocSearchNewVersion runat="server" ID="DocSearchNewVersion" />
                                </div>
                                <div ng-show="!newVersion">
                                    <uc1:DocSearchOldVersion runat="server" ID="DocSearchOldVersion" />
                                </div>
                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <%-- log panel --%>
                <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9" PaneStyle-Paddings-Padding="0px" Name="LogPanel">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <div style="font-size: 12px; color: #9fa1a8;">
                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                                    <li class="short_sale_head_tab activity_light_blue">
                                        <a href="#activity_log" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-history head_tab_icon_padding"></i>
                                            <div class="font_size_bold">Summary</div>
                                        </a>

                                    </li>
                                    <% If Request.QueryString("si") = 1 %>
                                    <li class="short_sale_head_tab activity_light_blue" onclick="exportsheet()">
                                        <a href="#activity_log" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-file-excel-o head_tab_icon_padding" style="color: white !important"></i>
                                            <div class="font_size_bold">Export</div>
                                        </a>
                                    </li>
                                    <% End If %>
                                </ul>
                                <div style="padding: 20px; max-height: 850px; overflow-y: scroll" id="searchReslut">
                                    <div ng-if="newVersion">
                                        <new-ds-summary docsearch="DocSearch" leadsinfo="LeadsInfo" summary="DocSearch.LeadResearch" updateby="DocSearch.UpdateBy" updateon="DocSearch.UpdateDate" showinfo="ShowInfo"></new-ds-summary>
                                    </div>
                                    <div ng-if="!newVersion">
                                        <ds-summary summary="DocSearch.LeadResearch"></ds-summary>
                                    </div>

                                    <%-- <uc1:LeadSearchSummery runat="server" ID="LeadSearchSummery" />--%>
                                </div>
                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>
    <script>
        //java script code for outer call


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
