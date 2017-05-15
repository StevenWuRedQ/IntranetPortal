<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/TitleUI/TitleDocTab.ascx" TagPrefix="uc1" TagName="TitleDocTab" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        /*the label near the summary text div*/
        .label-summary-info {
            float: left;
            margin-top: 10px;
            color: white;
            font-size: 20px;
            font-weight: 200;
            padding: 8px 12px;
            border-radius: 5px;
        }
    </style>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">

    <div style="margin-left: 20px; margin-top: 15px;">
        <div style="float: left; font-weight: 300; font-size: 48px; color: #234b60">
            <span id="span-user-name" style="text-transform: capitalize"><%= Page.User.Identity.Name %></span>'s Summary &nbsp;
        </div>
        <div class="label-summary-info" style="background-color: #ff400d;">
            <span id="span-worklist-count" style="font-weight: 900"></span>
            <span style="font-weight: 200">&nbsp;Tasks
            </span>
        </div>
    </div>
    <div class="content" style="float: left; margin-right: 10px; margin-left: 35px;">
        <div class="row">
            <pt-summary-item-list
                list-name="New Search"
                list-short-name="NS"
                list-data-url="/api/LeadInfoDocumentSearches/status/0"
                list-href="/UnderWriter/PropertiesList.aspx#/1"
                list-filter="1"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"></pt-summary-item-list>
            <pt-summary-item-list
                list-name="Compeleted Search"
                list-short-name="CS"
                list-data-url="/api/LeadInfoDocumentSearches/status/1"
                list-href="/UnderWriter/PropertiesList.aspx#/2"
                list-filter="2"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"></pt-summary-item-list>
            <div class="clearfix"></div>
            <% If User.IsInRole("Underwriter") %>
            <pt-summary-item-list
                list-name="New Underwriting"
                list-short-name="NU"
                list-data-url="/api/underwriting/status/1"
                list-href="/UnderWriter/PropertiesList.aspx#/11"
                list-filter="11"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"></pt-summary-item-list>
            <pt-summary-item-list
                list-name="Processing Underwriting"
                list-short-name="PU"
                list-data-url="/api/underwriting/status/2"
                list-href="/UnderWriter/PropertiesList.aspx#/12"
                list-filter="12"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"></pt-summary-item-list>
            <pt-summary-item-list
                list-name="Accepted Underwriting"
                list-short-name="AU"
                list-data-url="/api/underwriting/status/3"
                list-href="/UnderWriter/PropertiesList.aspx#/13"
                list-filter="13"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"></pt-summary-item-list>
            <pt-summary-item-list
                list-name="Rejected Underwriting"
                list-short-name="RU"
                list-data-url="/api/underwriting/status/4"
                list-href="/UnderWriter/PropertiesList.aspx#/14"
                list-filter="14"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"></pt-summary-item-list>
            <% End If %>
        </div>
    </div>

    <script>
        $(function () {
            var scope = angular.element(document.body).injector().get('$rootScope');
            scope.summaryListItemHelper = {
                onSummaryListItemClick: function (e) {
                    var data = e.data.data;
                    var filterNum = e.data.filter;
                    if (data) {
                        var bble = data.data.BBLE.trim();
                        location.href = "/underwriter/PropertiesList.aspx#/" + filterNum + "/" + bble + "/"
                    }
                }
            }
        });
    </script>

</asp:Content>

