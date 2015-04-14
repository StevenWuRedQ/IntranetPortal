<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsManagement.aspx.vb" Inherits="IntranetPortal.LeadsManagement" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>
<%@ Register Src="~/UserControl/AssignRulesControl.ascx" TagPrefix="uc1" TagName="AssignRulesControl" %>
<%@ Register Src="~/PopupControl/AssignLeadsPopup.ascx" TagPrefix="uc1" TagName="AssignLeadsPopup" %>


<asp:Content ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var postponedCallbackRequired = false;
        var leadsInfoBBLE = null;
        var tempBBLE = null;

        //function is called on changing focused row
        function OnGridFocusedRowChanged(s, e) {
            // The values will be returned to the OnGetRowValues() function 
            var rowIndex = s.GetFocusedRowIndex();
            if (rowIndex >= 0) {
                NavigateToLeadsInfo(s.GetRowKey(rowIndex));
                return;

                //if (ContentCallbackPanel.InCallback()) {
                //    postponedCallbackRequired = true;
                //}
                //else {
                //    var rowKey = s.GetRowKey(rowIndex);
                //    debugger;
                //    if (rowKey != null)
                //        OnGetRowValues(rowKey);
                //}
            }
        }

        function OnSelectionChanged(s, e) {
            var counnt = s.GetSelectedRowCount();
            $("#gridSelectCount").html(counnt);
            if (counnt > 0) {
                document.getElementById("btnAssign").disabled = false;
            } else
                document.getElementById("btnAssign").disabled = true;
        }

        function NavigateToLeadsInfo(bble) {
            if (leadsInfoBBLE == bble)
                return
            else {
                leadsInfoBBLE = bble;
                var url = "/ViewLeadsInfo.aspx?b=" + bble;
                var contentPane = splitter.GetPaneByName("RightPane");
                contentPane.SetContentUrl(url);
                return;
            }
        }

        function OnGetRowValues(values) {
            if (values == null) {
                gridLeads.GetValuesOnCustomCallback(gridLeads.GetFocusedRowIndex(), OnGetRowValues);
            }
            else {

                leadsInfoBBLE = values;
                ContentCallbackPanel.PerformCallback(values);
            }
        }

        function OnChangeLeadsType(s, e) {
            if (tempBBLE != null) {
                updateLeadsType.PerformCallback(tempBBLE + "|" + e.item.name);
            }
        }

        function OnEndCallback(s, e) {
           
            return;
            $("#prioity_content").mCustomScrollbar(
             {
                 theme: "minimal-dark"
             }
             );
            $("#ctl00_MainContentPH_ASPxSplitter1_LeadsInfo_ASPxCallbackPanel2_contentSplitter_ownerInfoCallbackPanel").mCustomScrollbar(
                {
                    theme: "minimal-dark"
                }
             );

        }

        function onInitScorllBar() {
            return;
            $(".dxgvCSD").each(function (ind) {
                var is_list = $(this).parents("#assign_leads_list").length > 0;

                var ladfucntion = {
                    onScroll: function () {
                        var position = this.mcs.topPct;
                        if (position > 90) {
                            gridLeads.NextPage();
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
                    $(this).mCustomScrollbar(
                        {
                            theme: "minimal-dark",

                        }
                    );
                }
            });

            $('#ctl00_MainContentPH_ASPxSplitter1_listboxEmployee_D').mCustomScrollbar(
              {
                  theme: "minimal-dark"
              }
            );
            $("#prioity_content").mCustomScrollbar(
             {
                 theme: "minimal-dark"
             }
             );
            $("#ctl00_MainContentPH_ASPxSplitter1_LeadsInfo_ASPxCallbackPanel2_contentSplitter_ownerInfoCallbackPanel").mCustomScrollbar(
                {
                    theme: "minimal-dark"
                }
             );
        }

        function ResizeGrid(pane)
        {
            if (pane.name == "gridPanel")
            {           
                var height = pane.GetClientHeight();
                gridLeads.SetHeight(height);
            }            
        }

        $(document).ready(function () {
            // Handler for .ready() called.
            //onInitScorllBar();
        });
    </script>
    <style type="text/css">
        .rand-button:disabled
        {
            background-color:gray;
        }

    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" FullscreenMode="true">
        <Styles>
            <Pane>
                <Paddings Padding="2px" />
            </Pane>
            <Separator>
                <Border BorderStyle="None" />
            </Separator>
            <VerticalSeparator>
                <Border BorderStyle="None" />
            </VerticalSeparator>
        </Styles>
        <Panes>
            <dx:SplitterPane Size="850px" MinSize="300px" ShowCollapseBackwardButton="True">
                <PaneStyle>
                    <Border BorderStyle="None" />
                </PaneStyle>
                <Separators Visible="False"></Separators>
                <Panes>
                    <dx:SplitterPane Size="70px">
                        <ContentCollection>
                            <dx:SplitterContentControl>
                                <div style="margin: 10px 20px 10px 10px; text-align: left; padding-left: 5px" class="clearfix">
                                    <div style="font-size: 24px;" class="clearfix">
                                        <i class="fa fa-check-square-o with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                                        <span style="color: #234b60; font-size: 30px;">
                                            <dx:ASPxLabel Text="Assign Leads" ID="lblLeadCategory" Font-Size="30px" ClientInstanceName="LeadCategory" runat="server"></dx:ASPxLabel>

                                        </span>
                                        <span style="font-size:18px;margin-left:20px">
                                            <span id="gridSelectCount"> 0 </span> selected
                                        </span>
                                        <div style="float: right">
                                            <%--  <a href="/LeadsGenerator/LeadsGenerator.aspx" target="_self" class="rand-button rand-button-blue">Create Leads</a>--%>
                                            <asp:LinkButton ID="btnExport" runat="server" OnClick="btnExport_Click" Text='<i class="fa  fa-file-excel-o  report_head_button report_head_button_padding tooltip-examples" title="Export to Excel"></i>'>                                                                
                                            </asp:LinkButton>
                                            <input type="button" value="Create Leads" class="rand-button rand-button-blue rand-button-pad" onclick="window.location.href = '/LeadsGenerator/LeadsGenerator.aspx'" />
                                        </div>
                                    </div>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                    <dx:SplitterPane Name="gridPanel">
                        <ContentCollection>
                            <dx:SplitterContentControl>
                                <dx:ASPxGridView runat="server" Settings-ShowColumnHeaders="false" OnDataBinding="gridLeads_DataBinding"
                                    
                                    ID="gridLeads" ClientInstanceName="gridLeads" Width="100%" KeyFieldName="BBLE" OnHtmlRowPrepared="gridLeads_HtmlRowPrepared" OnCustomCallback="gridLeads_CustomCallback"
                                    EnableViewState="true">
                                    <Columns>
                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0" Name="colSelect" Visible="true" Width="25px">
                                        </dx:GridViewCommandColumn>
                                        <dx:GridViewDataColumn FieldName="BBLE" Caption="BBLE" Width="1px" ExportWidth="100">                                            
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataTextColumn FieldName="PropertyAddress" Settings-AllowHeaderFilter="False">
                                            <Settings AllowHeaderFilter="False"></Settings>
                                            <DataItemTemplate>
                                                <%# String.Format("<span style=""font-weight: 900;"">{0}</span>-{1}", String.Format("{0} {1}", Eval("Number"), Eval("Street")).Trim, Eval("Owner"))%>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Neighborhood" Width="80px" Caption="Neighbor"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataSpinEditColumn FieldName="NYCSqft" Width="60px" Caption="SQFT"></dx:GridViewDataSpinEditColumn>
                                        <dx:GridViewDataTextColumn FieldName="LotDem" Width="100px"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="PropertyClass" Caption="Class" Width="60px" Settings-HeaderFilterMode="CheckedList"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="MortgageCombo" Width="80px" Caption="MtgCOMBO" PropertiesTextEdit-DisplayFormatString="C"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="C1stServicer" Caption="Servicer" Width="80px"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="TaxLiensAmount" Caption="TaxCOMBO" Width="60px" PropertiesTextEdit-DisplayFormatString="C"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="TypeText" Width="40px" CellStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle">
                                            <DataItemTemplate>
                                                <dx:ASPxImage EmptyImage-Url="~/images/ide.png" EmptyImage-Width="16" EmptyImage-Height="16" runat="server" ID="imgType" Width="24" Height="24" CssClass="always_show">
                                                </dx:ASPxImage>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn FieldName="Comments" Width="50px" Caption="Recycle">
                                            <DataItemTemplate>
                                                <dx:ASPxCheckBox runat="server" ID="chkRecycled" ToolTip="Recycled" Checked='<%# Eval("IsRecycled")%>' ReadOnly="true" Visible='<%# Eval("IsRecycled")%>'></dx:ASPxCheckBox>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>                                       
                                    </Columns>
                                    <SettingsBehavior AllowClientEventsOnLoad="true" AllowFocusedRow="true"
                                        EnableRowHotTrack="True" />
                                    <Settings ShowFilterRowMenu="true"  ShowHeaderFilterButton="true"  ShowColumnHeaders="true" VerticalScrollableHeight="1000" GridLines="Both"></Settings>
                                    <SettingsPager Mode="EndlessPaging" PageSize="50"></SettingsPager>
                                    <Styles>
                                        <Header HorizontalAlign="Center"></Header>
                                        <Row Cursor="pointer" />
                                        <AlternatingRow BackColor="#F5F5F5"></AlternatingRow>
                                        <RowHotTrack BackColor="#FF400D"></RowHotTrack>
                                    </Styles>
                                    <Border BorderStyle="None"></Border>
                                    <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" SelectionChanged="OnSelectionChanged" />
                                </dx:ASPxGridView>
                                <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridLeads" OnRenderBrick="gridExport_RenderBrick">                                    
                                </dx:ASPxGridViewExporter>
                                <dx:ASPxPopupMenu ID="ASPxPopupMenu3" runat="server" ClientInstanceName="leadsTypeMenu"
                                    AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                    <Items>
                                        <dx:MenuItem Text="Development" Name="DevelopmentOpportunity" Image-Url="/images/lr_dev_opportunity.png">
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="Foreclosure" Name="Foreclosure" Image-Url="/images/lr_forecosure.png">
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="Has Equity" Name="HasEquity" Image-Url="/images/lr_has_equity.png"></dx:MenuItem>
                                        <dx:MenuItem Text="Tax Lien" Name="TaxLien" Image-Url="/images/lr_tax_lien.png">
                                        </dx:MenuItem>
                                    </Items>
                                    <ClientSideEvents ItemClick="OnChangeLeadsType" />
                                </dx:ASPxPopupMenu>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                    <dx:SplitterPane Size="70px">
                        <ContentCollection>
                            <dx:SplitterContentControl>
                                <table style="width: 500px; float: right; margin-top: 10px;">
                                    <tr>
                                        <td>
                                            <dx:ASPxLabel Text="Select Employee:" ID="ASPxLabel1" runat="server" Font-Size="Large"></dx:ASPxLabel>
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox runat="server" CssClass="edit_drop" ClientInstanceName="listboxEmployee" ID="listboxEmployee" TextField="Name" ValueField="EmployeeID" DropDownStyle="DropDownList" IncrementalFilteringMode="StartsWith">
                                                <ValidationSettings ErrorDisplayMode="None">
                                                    <RequiredField IsRequired="true" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </td>
                                        <td>
                                            <input type="button" id="btnAssign" value="Assign" class="rand-button rand-button-blue rand-button-pad" disabled="disabled" onclick="{ if (listboxEmployee.GetIsValid()) gridLeads.PerformCallback('AssignLeads'); }" />
                                            &nbsp;&nbsp;
                                      <input type="button" value="Rules" class="rand-button rand-button-blue rand-button-pad" onclick="AssignLeadsPopupClient.Show();" />

                                            <button type="button" onclick="popupAssignRules.Show();" style="display: none">Rules Old</button>
                                        </td>
                                    </tr>
                                </table>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                </Panes>
                <%-- <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <div style="width: 100%; height: 100%; /*border: 1px solid gray; */ /*border-bottom: 1px solid gray; */">
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>--%>
            </dx:SplitterPane>
            <dx:SplitterPane Name="RightPane" ScrollBars="Auto" ContentUrl="about:blank">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <%--  <uc1:LeadsInfo runat="server" ID="LeadsInfo" ShowLogPanel="false" />--%>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
        <ClientSideEvents PaneResized="function(s,e){ResizeGrid(e.pane);}" />
    </dx:ASPxSplitter>
    <dx:ASPxCallback runat="server" ID="updateLeadsType" ClientInstanceName="updateLeadsType" OnCallback="updateLeadsType_Callback">
        <ClientSideEvents EndCallback="function(){gridLeads.Refresh();}" />
    </dx:ASPxCallback>
    <dx:ASPxPopupControl ID="popupAssignRules" runat="server" ClientInstanceName="popupAssignRules"
        Width="630px" Height="700px" CloseAction="CloseButton" MaxWidth="800px" MinWidth="150px" ShowFooter="true"
        HeaderText="Assign Leads Rules" Modal="true" ContentUrl="~/AssignLeadsRulesPage.aspx"
        EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
        <FooterContentTemplate>
            <div style="height: 30px; vertical-align: central">
                <span class="time_buttons" onclick="popupAssignRules.Hide()">Close</span>
            </div>
        </FooterContentTemplate>
    </dx:ASPxPopupControl>
    <uc1:AssignLeadsPopup runat="server" ID="AssignLeadsPopup" />
    <uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />
</asp:Content>
