<%@ Page Title="Title" Language="VB" MasterPageFile="~/Content.Master" %>

<%-- 
According To different mode in url, Page will show in different behavier
mode 0: Doc Search(Default) Mode, user can modify search, user cannot view story, user cannot view underwriting status, user cannot export
mode 1: Sales Executive mode, user can view but not modified search, user can view story but not story history, user cannot view underwriting status, user cannot view export
mode 2: Underwriting mode,  user can view but not modified search, user can view story and story history, user can change underwriting status, user can export excel
--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <script>
        angular.module("PortalApp").config(function ($stateProvider) {
            var searchSummary = {
                name: 'searchSummary',
                url: '/searchSummary',
                controller: 'DocSearchController',
                templateUrl: '/js/Views/LeadDocSearch/new_ds_summary.html',
            }
            var underwritingRequest = {
                name: 'underwritingRequest',
                url: '/underwritingRequest',
                controller: 'UnderwritingRequestController',
                templateUrl: '/js/Views/Underwriting/underwriting_request.tpl.html',
                data: {
                    Review: true
                }
            }
            var docSearch = {
                name: 'docSearch',
                url: '/docSearch',
                templateUrl: '/js/Views/LeadDocSearch/DocSearchForm.html',
                controller: 'DocSearchController'
            }

            $stateProvider
                .state(searchSummary)
                .state(underwritingRequest)
                .state(docSearch);
        });
    </script>
    <div id="dataPanelDiv">
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
                        <div class="font_size_bold" style="width: 100px">Story</div>
                    </a>
                </li>

                <li class="short_sale_head_tab activity_light_blue" ui-sref-active="active">
                    <a role="tab" ui-sref="docSearch" class="tab_button_a">
                        <i class="fa fa-calculator head_tab_icon_padding"></i>
                        <div class="font_size_bold" style="width: 100px">Doc Search</div>
                    </a>
                </li>
            </ul>
            <div class="tab-content">
                <div style='padding: 2px 20px; overflow-y: scroll'>
                    <ui-view></ui-view>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
