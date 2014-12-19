<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="OriginatedListControl.ascx.vb" Inherits="IntranetPortal.OriginatedListControl" %>
<script type="text/javascript">
    function ShowWorklistItem(itemData, processName)
    {
        var frm = document.getElementById("FrmTaskContent");
        var contentPane = splitterTaskPage.GetPaneByName("contentPanel")
        contentPane.SetContentUrl(itemData);
        //alert(sn + " " + processName);
    }

</script>

<div style="width: 100%; height: 100%;" class="color_gray">
    <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <div class="clearfix">
                <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                <span style="color: #234b60; font-size: 30px;">
                    <dx:ASPxLabel Text="Tasks" ID="lblLeadCategory" Cursor="pointer" ClientInstanceName="LeadCategory" runat="server" Font-Size="30px"></dx:ASPxLabel>
                </span>
                <div class="icon_right_s">                    
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" id="btnSortIcon" onclick="aspxPopupSortMenu.ShowAtElement(this);"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>
    </div>
    <div style="height: 768px; padding: 0px 10px;" id="leads_list_left">
        <dx:ASPxGridView runat="server" EnableRowsCache="false" Settings-ShowColumnHeaders="false" SettingsBehavior-AutoExpandAllGroups="true"
            ID="gridProcess" Border-BorderStyle="None" ClientInstanceName="gridProcess" Width="100%" AutoGenerateColumns="False" KeyFieldName="Id">
            <Columns>                
                <dx:GridViewDataTextColumn FieldName="DisplayName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                    <Settings AutoFilterCondition="Contains" />
                    <DataItemTemplate>
                        <span onclick='ShowWorklistItem("<%# Eval("ItemData")%>", "<%# Eval("ProcessName")%>")'><%# Eval("DisplayName")%></span>
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
                <dx:GridViewDataColumn FieldName="ProcessName" Visible="false" VisibleIndex="5">
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
        </dx:ASPxGridView>
    </div>
</div>