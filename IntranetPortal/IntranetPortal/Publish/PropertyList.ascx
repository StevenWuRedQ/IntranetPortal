<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PropertyList.ascx.vb" Inherits="IntranetPortal.PropertyListControl" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<script type="text/javascript">

    function ClosePage() {
        var contentPane = splitterTaskPage.GetPaneByName("contentPanel")
        contentPane.SetContentUrl("about:blank");
        gridTasks.Refresh();
    }

    function RefreshTaskList() {
        gridTasks.Refresh();
    }

    function ExpandOrCollapseGroupRow(rowIndex) {
        if (gridTasks.IsGroupRow(rowIndex)) {
            if (gridTasks.IsGroupRowExpanded(rowIndex)) {
                gridTasks.CollapseRow(rowIndex);
            } else {
                gridTasks.ExpandRow(rowIndex);
            }
            //AddScrollbarOnLeadsList();
            return
        }
    }

    function expandAllClick(s) {
        if (gridTasks.IsGroupRowExpanded(0)) {
            gridTasks.CollapseAll();
            $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples');
        }
        else {
            gridTasks.ExpandAll();
            $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples');
        }

        InitScrollBar();
    }

    function InitScrollBar() {
        return;
        $("#leads_list_left").mCustomScrollbar(
                    {
                        theme: "minimal-dark"
                    }
                 );
    }

    $(document).ready(function () {
        //Handler for .ready() called.       
        InitScrollBar();
    });

    function OnGridFocusedRowChanged(s, e) {
        // The values will be returned to the OnGetRowValues() function 
        if (gridTasks.GetFocusedRowIndex() >= 0) {
            var bble = gridTasks.GetRowKey(gridTasks.GetFocusedRowIndex());
            ShowListPropertyPage(bble);
        }
    }

    function ShowListPropertyPage(bble) {
        var contentPane = splitter.GetPaneByName("contentPanel");
        var url = "/Publish/PublishPropertyPage.aspx?bble=" + bble;
        contentPane.SetContentUrl(url);
    }

    function SortLeadsList(s, field) {
        var classDesc = "fa fa-sort-amount-desc icon_btn tooltip-examples";
        var classAsc = "fa fa-sort-amount-asc icon_btn tooltip-examples";
        var sort = s.getAttribute("class");

        if (sort.indexOf("-desc") > 0) {
            s.setAttribute("class", classAsc);
            gridTasks.SortBy(field, "ASC");
        }
        else {
            if (sort.indexOf("-asc") > 0) {
                s.setAttribute("class", classDesc);
                gridTasks.SortBy(field, "DSC");
            }
        }
    }

    function OnSortMenuClick(s, e) {
        var icon = document.getElementById("btnSortIcon");
        if (e.item.index == 0) {
            SortLeadsList(icon, "StartDate");
        }

        if (e.item.index == 1) {
            gridTasks.PerformCallback("Group|Originator");
        }

        if (e.item.index == 2) {
            gridTasks.PerformCallback("Group|ProcSchemeDisplayName");
        }
    }

</script>

<div style="width: 100%; height: 100%;" class="color_gray">
    <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <div class="clearfix">
                <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                <span style="color: #234b60; font-size: 30px;">
                    <dx:ASPxLabel Text="Publish" ID="lblLeadCategory" Cursor="pointer" ClientInstanceName="LeadCategory" runat="server" Font-Size="30px"></dx:ASPxLabel>
                </span>
                <div class="icon_right_s">
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" id="btnSortIcon" onclick="aspxPopupSortMenu.ShowAtElement(this);"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>
    </div>
    <div style="height: 768px; overflow-y: scroll" id="leads_list_left">
        <dx:ASPxGridView runat="server" EnableRowsCache="false" Settings-ShowColumnHeaders="false" SettingsBehavior-AutoExpandAllGroups="true" OnCustomCallback="gridTasks_CustomCallback" OnCustomColumnSort="gridTasks_CustomColumnSort"
            ID="gridTasks" Border-BorderStyle="None" ClientInstanceName="gridTasks" Width="100%" AutoGenerateColumns="False" KeyFieldName="BBLE" OnDataBinding="gridTasks_DataBinding">
            <Columns>
                <dx:GridViewDataTextColumn FieldName="MarkColor" VisibleIndex="0" Width="30px">
                    <DataItemTemplate>
                        <i class="fa fa-circle color_star" style="color: <%# GetMarkColor(Eval("Process"))%>">
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                    <Settings AutoFilterCondition="Contains" />
                    <DataItemTemplate>
                        <div><%# Eval("LeadsName")%></div>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataColumn FieldName="EmployeeName" Visible="false" VisibleIndex="4">
                    <GroupRowTemplate>
                        <div>
                            <table style="height: 45px">
                                <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                                    <td style="width: 80px;">
                                        <span class="font_black">
                                            <i class="fa fa-user font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                        </span>
                                    </td>
                                    <td style="padding-left: 10px">
                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </GroupRowTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="LastUpdate" Visible="false" VisibleIndex="5"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn Width="40px" VisibleIndex="6">
                    <DataItemTemplate>
                        <div class="hidden_icon">
                            <i class="fa fa-list-alt employee_list_item_icon" style="width: 30px" onclick="<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>"></i>
                        </div>
                        <%-- <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom" onclick="<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>" />--%>
                    </DataItemTemplate>
                </dx:GridViewDataColumn>
            </Columns>
            <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true" AllowGroup="true"
                EnableRowHotTrack="True" />
            <%--<SettingsPager Mode="ShowPager" PageSize="17" Position="Bottom" Summary-Visible="false" ShowDisabledButtons="false" NumericButtonCount="4"></SettingsPager>--%>
            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
            <%--   <SettingsPager Mode="ShowAllRecords"></SettingsPager>--%>
            <Settings ShowColumnHeaders="False" VerticalScrollableHeight="767"></Settings>
            <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
            <Styles>
                <Table Border-BorderStyle="None">
                    <Border BorderStyle="None"></Border>
                </Table>
                <Cell Border-BorderStyle="none">
                    <Border BorderStyle="None"></Border>
                </Cell>
                <Row Cursor="pointer" />
                <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
            </Styles>
            <GroupSummary>
                <dx:ASPxSummaryItem FieldName="DisplayName" SummaryType="Count" />
            </GroupSummary>
            <Border BorderStyle="None"></Border>
            <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />
        </dx:ASPxGridView>
    </div>
    <dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="aspxPopupSortMenu"
        ShowPopOutImages="false" AutoPostBack="false"
        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px"
        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
        <ItemStyle Paddings-PaddingLeft="20px" />
        <Items>
            <dx:MenuItem Text="Date" Name="Date">
            </dx:MenuItem>
            <dx:MenuItem Text="Employee" Name="Employee">
            </dx:MenuItem>
            <dx:MenuItem Text="Process" Name="Process">
            </dx:MenuItem>
        </Items>
        <ClientSideEvents ItemClick="OnSortMenuClick" />
    </dx:ASPxPopupMenu>

       <uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />
</div>
