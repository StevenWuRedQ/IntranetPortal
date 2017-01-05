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
                list-status-id="1"
                list-data-url="/api/LeadInfoDocumentSearches/UnderWritingStatus/0"
                list-href="/UnderWriter/DocSearchListNew.aspx#/1"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"
                item-type="0"></pt-summary-item-list>
            <div class="clearfix"></div>
            <pt-summary-item-list
                list-name="Pending Underwriting"
                list-short-name="PU"
                list-status-id="3"
                list-data-url="/api/LeadInfoDocumentSearches/UnderWritingStatus/2"
                list-href="/UnderWriter/DocSearchListNew.aspx#/3"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"
                item-type="1"></pt-summary-item-list>
            <pt-summary-item-list
                list-name="Accepted Underwriting"
                list-short-name="AU"
                list-status-id="4"
                list-data-url="/api/LeadInfoDocumentSearches/UnderWritingStatus/3"
                list-href="/UnderWriter/DocSearchListNew.aspx#/4"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"
                item-type="1"></pt-summary-item-list>
            <pt-summary-item-list
                list-name="Rejected Underwriting"
                list-short-name="RU"
                list-status-id="5"
                list-data-url="/api/LeadInfoDocumentSearches/UnderWritingStatus/4"
                list-href="/UnderWriter/DocSearchListNew.aspx#/5"
                item-field="CaseName"
                item-click="summaryListItemHelper.onSummaryListItemClick"
                item-type="1"></pt-summary-item-list>
        </div>
    </div>

    <script>
        $(function () {
            var scope = angular.element(document.body).injector().get('$rootScope');
            scope.summaryListItemHelper = {
                onSummaryListItemClick: function (e) {
                    var data = e.data.data;
                    var type = e.data.type;
                    var locationId = e.data.locationId;
                    if (data) {
                        var bble = data.data.BBLE.trim();
                        location.href = "/underwriter/PropertiesList.aspx#/" + locationId + "/" + bble;
                    }
                }
            }
        });
    </script>

</asp:Content>

