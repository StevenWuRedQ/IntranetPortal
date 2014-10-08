<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleCaseList.ascx.vb" Inherits="IntranetPortal.ShortSaleCaseList" %>
<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>

<script type="text/javascript">
    var postponedCallbackRequired = false;
    var caseId = null;
    var ShortSaleCaseData = null;

    //function is called on changing focused row
    function OnGridFocusedRowChanged() {
        // The values will be returned to the OnGetRowValues() function 
        if (gridCase.GetFocusedRowIndex() >= 0) {
            if (ContentCallbackPanel.InCallback()) {
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

    function GetShortSaleData(caseId) {
        $.ajax({
            type: "POST",
            url: "ShortSale.aspx/GetCase",
            data: '{caseId: ' + caseId + '}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                alert(response);
            },
            error: function (response) {
                alert(response);
            }
        });
    }

    function OnSuccess(response) {        
        ShortSaleCaseData = JSON.parse(response.d);
        ShortSaleDataBand(0);
      
    }

    function OnGetRowValues(values) {
        if (values == null) {
            //gridCase.GetValuesOnCustomCallback(gridCase.GetFocusedRowIndex(), OnGetRowValues);
        }
        else {
            caseId = values;
            //GetShortSaleData(caseId);
            ContentCallbackPanel.PerformCallback(values);
        }
    }
    
    function RefreshContent()
    {
        if(caseId != null)
        {
            ContentCallbackPanel.PerformCallback(caseId);
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
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" onclick="SortLeadsList(this)"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>
        <%--      <button type="button" onclick="gridLeads.CollapseAll()" value="Collapse">Collapse</button>
        <button type="button" onclick="gridLeads.ExpandAll()" value="Expand">Expand</button>--%>
    </div>
    <div style="overflow: auto; height: 768px; padding: 0px 10px;" id="leads_list_left">
        <asp:HiddenField runat="server" ID="hfCaseStatus" />
        <dx:ASPxGridView runat="server" EnableRowsCache="false" Settings-ShowColumnHeaders="false" SettingsBehavior-AutoExpandAllGroups="true" ID="gridCase" Border-BorderStyle="None" ClientInstanceName="gridCase" Width="100%" Settings-VerticalScrollableHeight="0" AutoGenerateColumns="False" KeyFieldName="CaseId" SettingsPager-Mode="ShowAllRecords" OnDataBinding="gridCase_DataBinding">
            <Columns>             
                <dx:GridViewDataTextColumn FieldName="CaseName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                    <Settings AutoFilterCondition="Contains" />
                </dx:GridViewDataTextColumn>                                
                <dx:GridViewDataColumn FieldName="LastUpdate" Visible="false" VisibleIndex="5"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn Width="40px" VisibleIndex="6">
                    <DataItemTemplate>
                        <div class="hidden_icon">
                            <i class="fa fa-list-alt employee_list_item_icon" style="width: 30px" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>"></i>
                        </div>
                        <%-- <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom" onclick="<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>" />--%>
                    </DataItemTemplate>
                </dx:GridViewDataColumn>
            </Columns>         
            <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true" AllowGroup="true"
                EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
            <SettingsPager Mode="ShowAllRecords"></SettingsPager>
            <Settings ShowColumnHeaders="False" VerticalScrollableHeight="50"></Settings>            
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
                <dx:ASPxSummaryItem FieldName="LeadsName" SummaryType="Count" />
            </GroupSummary>
            <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />
            <Border BorderStyle="None"></Border>
        </dx:ASPxGridView>
    </div>
    <uc1:ShortSaleSubMenu runat="server" id="ShortSaleSubMenu" />
   </div>