<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadDocSearchList.ascx.vb" Inherits="IntranetPortal.LeadDocSearchList" %>

<script type="text/javascript">
    var postponedCallbackRequired = false;
    var leadsInfoBBLE = null;

    // function is called on changing focused row
    function OnGridFocusedRowChanged() {
        // The values will be returned to the OnGetRowValues() function 
        if (gridCase.GetFocusedRowIndex() >= 0) {
            if (typeof cbpLogs != 'undefined' && cbpLogs.InCallback()) {
                postponedCallbackRequired = true;
            }
            else {
                if (gridCase.GetFocusedRowIndex() >= 0) {
                    //alert(gridLeads.GetFocusedRowIndex());
                    var rowKey = gridCase.GetRowKey(gridCase.GetFocusedRowIndex());
                    if (rowKey != null) {
                        OnGetRowValues(rowKey);
                    }
                    else {
                        if (splitter) {
                            splitter.GetPaneByName('dataPane')
                        }
                    }
                }
            }
        }
    }

    function OnGetRowValues(values) {
        if (values == null) {
            // gridCase.GetValuesOnCustomCallback(gridCase.GetFocusedRowIndex(), OnGetRowValues);
        }
        else {
            leadsInfoBBLE = values;
            console.log(values);
            //GetShortSaleData(caseId);
            //ContentCallbackPanel.PerformCallback(values);
            if (typeof cbpLogs != 'undefined')
                cbpLogs.PerformCallback(leadsInfoBBLE);

            LoadSearch(leadsInfoBBLE);
        }
    }
    
    function expandAllClick(s) {
        if (gridCase.IsGroupRowExpanded(0)) {
            gridCase.CollapseAll();
            $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples');
        }
        else {
            gridCase.ExpandAll();
            $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples');
        }
    }

    // to do by steven
    function SortLeadsList(s, field) {
        var classDesc = "fa fa-sort-amount-desc icon_btn tooltip-examples";
        var classAsc = "fa fa-sort-amount-asc icon_btn tooltip-examples";
        var sort = s.getAttribute("class");

        if (sort.indexOf("-desc") > 0) {
            s.setAttribute("class", classAsc);
            gridCase.SortBy(field, "ASC");
        }
        else {
            if (sort.indexOf("-asc") > 0) {
                s.setAttribute("class", classDesc);
                gridCase.SortBy(field, "DSC");
            }
        }
    }

    function OnSortMenuClick(s, e) {
        var icon = document.getElementById("btnSortIcon");
        if (e.item.index == 0) {
            //gridCase.GroupBy("Owner", 0);
            SortLeadsList(document.getElementById("btnSortIcon"), "ExpectedSigningDate")
        }
        
        if (e.item.index == 1) {
            SortLeadsList(document.getElementById("btnSortIcon"), "UpdateDate");
        }

        if (e.item.index == 2) {
            if ($("#divSearch").is(':visible')) {
                $("#divSearch").hide();
                gridCase.ClearFilter();
            }
            else {
                $("#divSearch").show();
            }
        }
    }

    function SearchGrid() {
        var filterCondition = "";
        var key = $('#QuickSearch').val();

        if (key.trim() == "") {
            gridCase.ClearFilter();
            return;
        }

        filterCondition = "Name LIKE '%" + key + "%'";
        gridCase.ApplyFilter(filterCondition);
    }

    function RefreshContent() {
        if (caseId != null) {
            ContentCallbackPanel.PerformCallback(caseId);
        }
    }

    function ExpandOrCollapseGroupRow(rowIndex) {
        if (gridCase.IsGroupRow(rowIndex)) {
            if (gridCase.IsGroupRowExpanded(rowIndex)) {
                gridCase.CollapseRow(rowIndex);
            } else {
                gridCase.ExpandRow(rowIndex);
            }
            return
        }
    }

    function OnGridRowClicked(s, e) {
        if (typeof CaseDataChanged == 'function') {
            if (CaseDataChanged()) {
                e.cancel = confirm("You have pending changes, please save or press Cancel to continue?");
            }
        }
    }

</script>

<div style="width: 100%; height: 100%;" class="color_gray">
    <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <div class="clearfix">
                <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                <span style="color: #234b60; font-size: 30px;">
                    <dx:ASPxLabel Text="Searches" ID="lblLeadCategory" Cursor="pointer" ClientInstanceName="LeadCategory" runat="server" Font-Size="30px"></dx:ASPxLabel>
                </span>
                <div class="icon_right_s">
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" id="btnSortIcon" onclick="aspxPopupSortMenu.ShowAtElement(this);"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>
        <%-- <button type="button" onclick="gridLeads.CollapseAll()" value="Collapse">Collapse</button>
        <button type="button" onclick="gridLeads.ExpandAll()" value="Expand">Expand</button>--%>
    </div>
    <div style="overflow: auto; height: 798px; padding: 0px 10px;" id="leads_list_left">
        <asp:HiddenField runat="server" ID="hfCaseStatus" />
        <asp:HiddenField runat="server" ID="hfCaseBBLEs" />
        <div class="form-inline" id="divSearch" style="display: none">
            <input style="width: 200px; height: 30px;" class="form-control" id="QuickSearch" type="text" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid();return false; }">
            <i class="fa fa-search tooltip-examples icon_btn grid_buttons" style="margin-left: 10px" onclick="SearchGrid()"></i>
        </div>
        <dx:ASPxGridView runat="server" SettingsBehavior-AutoExpandAllGroups="true" ID="gridDocSearch" Border-BorderStyle="None" ClientInstanceName="gridCase" Width="100%" KeyFieldName="BBLE" OnDataBinding="gridDocSearch_DataBinding">
            <Columns>
                <dx:GridViewDataColumn FieldName="Name">
                    <DataItemTemplate>
                        <div><%# Eval("Name") %> </div>
                    </DataItemTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="ExpectedSigningDate" Visible="false"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="UpdateDate" Visible="false"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Status">
                    <GroupRowTemplate>
                        <div>
                            <table style="height: 30px">
                                <tr>
                                    <td style="width: 80px;"><span class="font_black"><i class="fa fa-caret-<%#If(Container.Expanded, "down", "right") %> font_16" onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer"></i>&nbsp; <i class="fa fa-bank font_16"></i>&nbsp; <%# CType(CInt(Container.GroupText), IntranetPortal.Data.LeadInfoDocumentSearch.SearchStatus).ToString%>
                                    </span></td>
                                    <td style="padding-left: 10px">
                                        <span class="employee_lest_head_number_label"><%#  Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "") %></span>

                                    </td>
                                </tr>
                            </table>
                        </div>
                    </GroupRowTemplate>
                </dx:GridViewDataColumn>
            </Columns>
            <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true" AllowGroup="true"
                EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
            <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
            <Settings ShowColumnHeaders="False" VerticalScrollableHeight="767"></Settings>
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
                <dx:ASPxSummaryItem FieldName="CaseName" SummaryType="Count" />
            </GroupSummary>
            <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" RowClick="OnGridRowClicked" />
            <Border BorderStyle="None"></Border>
        </dx:ASPxGridView>
    </div>
</div>
<dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="aspxPopupSortMenu"
    ShowPopOutImages="false" AutoPostBack="false"
    ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px"
    PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
    <ItemStyle Paddings-PaddingLeft="20px" />
    <Items>
        <dx:MenuItem Text="Signing Date" Name="ExpectedSigningDate">
        </dx:MenuItem>     
        <dx:MenuItem Text="Last Update" Name="LastUpdate">
        </dx:MenuItem>
        <dx:MenuItem Text="Search" Name="Search">
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnSortMenuClick" />
</dx:ASPxPopupMenu>
