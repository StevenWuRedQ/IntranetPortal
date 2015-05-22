<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalCaseList.ascx.vb" Inherits="IntranetPortal.LegalCaseList" %>
<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>

<script type="text/javascript">
    var postponedCallbackRequired = false;
    var leadsInfoBBLE = null;

    //function is called on changing focused row
    function OnGridFocusedRowChanged() {
        // The values will be returned to the OnGetRowValues() function 
        if (gridCase.GetFocusedRowIndex() >= 0) {
            if (cbpLogs.InCallback()) {
                postponedCallbackRequired = true;
            }
            else {
                if (gridCase.GetFocusedRowIndex() >= 0) {
                    //alert(gridLeads.GetFocusedRowIndex());
                    var rowKey = gridCase.GetRowKey(gridCase.GetFocusedRowIndex());
                    if (rowKey != null)
                        OnGetRowValues(rowKey);
                }
            }
        }
    }

    function OnGetRowValues(values) {
        if (values == null) {
            //gridCase.GetValuesOnCustomCallback(gridCase.GetFocusedRowIndex(), OnGetRowValues);
        }
        else {
            leadsInfoBBLE = values;
            //GetShortSaleData(caseId);
            //ContentCallbackPanel.PerformCallback(values);
            if (cbpLogs)
                cbpLogs.PerformCallback(leadsInfoBBLE);
            angular.element(document.getElementById('PortalCtrl')).scope().LoadLeadsCase(leadsInfoBBLE);
        }
    }

    function GetShortSaleData(caseId) {
        //debugger;
        $.ajax({
            type: "POST",
            url: "ShortSale.aspx/GetCase",
            data: '{caseId: ' + caseId + '}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                alert("Get ShortSaleData failed" + response);
            },
            error: function (response) {
                alert("Get ShortSaleData error" + response);
            }
        });
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
            SortLeadsList(icon, "UpdateDate");
        }

        if (e.item.index == 1) {
            SortLeadsList(icon, "CaseName");
        }

        if (e.item.index == 2) {
            gridCase.GroupBy("Neighborhood", 0);
        }

        if (e.item.index == 3) {
            gridCase.GroupBy("Owner", 0);
        }

        if (e.item.index == 4) {

        }
    }

    function OnSuccess(response) {
      
        ShortSaleCaseData = response.d;  //JSON.parse(response.d);
        leadsInfoBBLE = ShortSaleCaseData.BBLE;
        ShortSaleDataBand(0);
        
    }

   

    function RefreshContent() {
        if (caseId != null) {
            ContentCallbackPanel.PerformCallback(caseId);
        }
    }

    function AddScrollbarOnLeadsList() {
        return;
        $("#leads_list_left .dxgvCSD").each(function (ind) {
            var is_list = $(this).parents("#leads_list_left").length > 0;

            var ladfucntion = {
                onScroll: function () {
                    var position = this.mcs.topPct;
                    if (position > 95) {
                        gridCase.NextPage();
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
            }
        });
    }

    function ExpandOrCollapseGroupRow(rowIndex) {
        if (gridCase.IsGroupRow(rowIndex)) {
            if (gridCase.IsGroupRowExpanded(rowIndex)) {
                gridCase.CollapseRow(rowIndex);
            } else {
                gridCase.ExpandRow(rowIndex);
            }
            AddScrollbarOnLeadsList();
            return
        }
    }

</script>

<div style="width: 100%; height: 100%;" class="color_gray">
    <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <div class="clearfix">
                <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                <span style="color: #234b60; font-size: 30px;">
                    <dx:ASPxLabel Text="Cases" ID="lblLeadCategory" Cursor="pointer" ClientInstanceName="LeadCategory" runat="server" Font-Size="30px"></dx:ASPxLabel>
                </span>
                <div class="icon_right_s">
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" id="btnSortIcon" onclick="aspxPopupSortMenu.ShowAtElement(this);"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>
        <%--      <button type="button" onclick="gridLeads.CollapseAll()" value="Collapse">Collapse</button>
        <button type="button" onclick="gridLeads.ExpandAll()" value="Expand">Expand</button>--%>
    </div>
    <div style="overflow: auto; height: 768px; padding: 0px 10px;" id="leads_list_left">
        <asp:HiddenField runat="server" ID="hfCaseStatus" />
         <asp:HiddenField runat="server" ID="hfCaseBBLEs" />
        <dx:ASPxGridView runat="server" SettingsBehavior-AutoExpandAllGroups="true" ID="gridCase" Border-BorderStyle="None" ClientInstanceName="gridCase" Width="100%" KeyFieldName="BBLE" OnDataBinding="gridCase_DataBinding">
            <Columns>
                <dx:GridViewDataTextColumn FieldName="CaseName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                    <Settings AutoFilterCondition="Contains" />
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataColumn FieldName="UpdateDate" Visible="false"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="ResearchBy" Visible="false" VisibleIndex="4">
                    <GroupRowTemplate>
                        <div>
                            <table style="height: 30px">
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
                 <dx:GridViewDataColumn FieldName="Attorney" Visible="false" VisibleIndex="4">
                    <GroupRowTemplate>
                        <div>
                            <table style="height: 30px">
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
                <dx:GridViewDataColumn Width="40px" VisibleIndex="6" Visible="false">
                    <DataItemTemplate>
                        <div class="hidden_icon">
                            <i class="fa fa-list-alt employee_list_item_icon" style="width: 30px" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>"></i>
                        </div>
                    </DataItemTemplate>
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
            <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" EndCallback="function(s,e){AddScrollbarOnLeadsList();}" />
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
        <dx:MenuItem Text="Date" Name="Date">
        </dx:MenuItem>
        <dx:MenuItem Text="Name" Name="Name">
        </dx:MenuItem>
        <dx:MenuItem Text="Borough" Name="Borough">
        </dx:MenuItem>
        <dx:MenuItem Text="Employee" Name="Employee">
        </dx:MenuItem>
        <dx:MenuItem Text="Zip" Name="Zip">
        </dx:MenuItem>
        <dx:MenuItem Text="Type" Name="LeadsType">
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnSortMenuClick" />
</dx:ASPxPopupMenu>
