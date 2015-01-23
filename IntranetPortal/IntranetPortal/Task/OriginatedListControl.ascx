<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="OriginatedListControl.ascx.vb" Inherits="IntranetPortal.OriginatedListControl" %>
<script type="text/javascript">
    function ViewProcess(link) {
        var contentPane = splitterTaskPage.GetPaneByName("contentPanel")
        contentPane.SetContentUrl(link);
    }

    function ClosePage() {
        var contentPane = splitterTaskPage.GetPaneByName("contentPanel")
        contentPane.SetContentUrl("about:blank");
    }

    function expandAllClick(s) {
        if (gridProcess.IsGroupRowExpanded(0)) {
            gridProcess.CollapseAll();
            $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples');
        }
        else {
            gridProcess.ExpandAll();
            $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples');
        }
    }

    function ExpandOrCollapseGroupRow(rowIndex) {
        if (gridProcess.IsGroupRow(rowIndex)) {
            if (gridProcess.IsGroupRowExpanded(rowIndex)) {
                gridProcess.CollapseRow(rowIndex);
            } else {
                gridProcess.ExpandRow(rowIndex);
            }
            //AddScrollbarOnLeadsList();
            return
        }
    }

    function InitScrollBar() {

        $(".dxgvCSD").each(function (ind) {
            var is_list = $(this).parents("#leads_list_left").length > 0;

            var ladfucntion = {
                onScroll: function () {
                    var position = this.mcs.topPct;
                    if (position > 90) {
                        gridProcess.NextPage();
                    }
                }
            }

            if (is_list) {
                $(this).mCustomScrollbar(
                    {
                        theme: "minimal-dark",
                        callbacks: ladfucntion
                    }
                 );
            } else {
            }
        });
    }   

    function ArchivedProcInst(rowIndex) {
        gridProcess.DeleteRow(rowIndex);
        //$(span).parent().parent().remove();
        gridProcess.Refresh();
    }

    $(document).ready(function () {
        //Handler for .ready() called.       
        InitScrollBar();
    });
</script>
<style type="text/css">
    .dxgvDataRowHover_MetropolisBlue1 .iconAction {
        visibility: visible;
    }

    .dxgvDataRow_MetropolisBlue1 .iconAction {
        visibility: hidden;
    }

    .dxgvDataRow_MetropolisBlue1:hover .iconAction {
        visibility: visible;
    }
</style>

<div style="width: 100%; height: 100%;" class="color_gray">
    <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <div class="clearfix">
                <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                <span style="color: #234b60; font-size: 30px;">
                    <%= HeaderText%>                    
                </span>
                <div class="icon_right_s">
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" id="btnSortIcon" onclick="aspxPopupSortMenu.ShowAtElement(this);"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>
    </div>
    <div style="height: 768px; padding: 0px 10px;" id="leads_list_left">
        <dx:ASPxGridView runat="server" EnableRowsCache="false" Settings-ShowColumnHeaders="false" SettingsBehavior-AutoExpandAllGroups="true" OnDataBinding="gridProcess_DataBinding"
            ID="gridProcess" Border-BorderStyle="None" ClientInstanceName="gridProcess" Width="100%" AutoGenerateColumns="False" KeyFieldName="Id" OnRowDeleting="gridProcess_RowDeleting">
            <Columns>
                <dx:GridViewDataTextColumn FieldName="Id" VisibleIndex="0" Width="20px" Visible="false">
                    <DataItemTemplate>
                        <i class="fa fa-times iconAction" onclick="ArchivedProcInst(<%# Container.ItemIndex%>)" />
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="DisplayName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                    <Settings AutoFilterCondition="Contains" />
                    <DataItemTemplate>
                        <span onclick='ViewProcess("<%# GetViewLink(Eval("ProcessName")) & Eval("Id")%>")'><%# Eval("DisplayName")%></span>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="StartDate" Visible="false" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Caption="Date">
                    <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                    <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataColumn FieldName="Status" Visible="false" VisibleIndex="3">
                </dx:GridViewDataColumn>
                <%--<dx:GridViewDataColumn FieldName="Originator" Visible="false" VisibleIndex="4">                  
                </dx:GridViewDataColumn>--%>
                <dx:GridViewDataColumn FieldName="ProcessSchemeDisplayName" Visible="false" VisibleIndex="5">
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
            </Columns>
            <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true" AllowGroup="true"
                EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
            <%--<SettingsPager Mode="ShowPager" PageSize="17" Position="Bottom" Summary-Visible="false" ShowDisabledButtons="false" NumericButtonCount="4"></SettingsPager>--%>
            <SettingsPager Mode="EndlessPaging" PageSize="16"></SettingsPager>
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
            <ClientSideEvents EndCallback="function(s,e){ InitScrollBar();}" />
        </dx:ASPxGridView>
    </div>
</div>
