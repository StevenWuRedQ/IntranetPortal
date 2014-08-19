﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsManagement.aspx.vb" Inherits="IntranetPortal.LeadsManagement" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        var postponedCallbackRequired = false;
        var leadsInfoBBLE = null;

        //function is called on changing focused row
        function OnGridFocusedRowChanged() {
            // The values will be returned to the OnGetRowValues() function 
            if (gridLeads.GetFocusedRowIndex() >= 0) {

                if (ContentCallbackPanel.InCallback()) {
                    postponedCallbackRequired = true;
                }
                else {
                    if (gridLeads.GetFocusedRowIndex() >= 0) {
                        //alert(gridLeads.GetFocusedRowIndex());
                        var rowKey = gridLeads.GetRowKey(gridLeads.GetFocusedRowIndex());
                        if (rowKey != null)
                            OnGetRowValues(rowKey);
                    }
                }
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

        function OnEndCallback(s, e) {
        }
        function onInitScorllBar() {
            $('#assign_leads_list').mCustomScrollbar(
              {
                  theme: "minimal-dark"
              }
            );
            
            $('#ctl00_MainContentPH_ASPxSplitter1_listboxEmployee_D').mCustomScrollbar(
              {
                  theme: "minimal-dark"
              }
            );
        }
        $(document).ready(function () {
            // Handler for .ready() called.
            alert("on ready go");
            onInitScorllBar();
        });
    </script>
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
            <dx:SplitterPane Size="300px" MinSize="180px" ShowCollapseBackwardButton="True">
                <PaneStyle>
                    <Border BorderStyle="None" />
                </PaneStyle>
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <div style="width: 100%; height: 100%; /*border: 1px solid gray; */ /*border-bottom: 1px solid gray; */">
                            <div style="margin: 30px 20px 30px 10px; text-align: left; padding-left: 5px" class="clearfix">
                                <div style="font-size: 24px;" class="clearfix">

                                    <span style="color: #234b60; font-size: 30px;">
                                        <dx:ASPxCheckBox runat="server" ID="chkAll">
                                            <ClientSideEvents CheckedChanged="function(s,e)
                                         {
                                              if (s.GetChecked())
                                                  gridLeads.SelectRows();
                                              else
                                                  gridLeads.UnselectRows();

                                         }" />
                                        </dx:ASPxCheckBox>
                                        <dx:ASPxLabel Text="Assign Leads" ID="lblLeadCategory" Font-Size="30px" ClientInstanceName="LeadCategory" runat="server"></dx:ASPxLabel>
                                    </span>

                                </div>
                            </div>
                            <%--<div style="/*background-color: #efefef; border-bottom: 1px solid gray; */ text-align: left;">

                                <dx:ASPxCheckBox runat="server" ID="chkAll">
                                    <ClientSideEvents CheckedChanged="function(s,e)
                                         {
                                              if (s.GetChecked())
                                                  gridLeads.SelectRows();
                                              else
                                                  gridLeads.UnselectRows();

                                         }" />
                                </dx:ASPxCheckBox>
                                <dx:ASPxLabel Text="Assign Leads" ID="lblLeadCategory" ClientInstanceName="LeadCategory" runat="server"></dx:ASPxLabel>
                            </div>--%>
                            <div style="overflow: auto; height: 823px;" id="assign_leads_list">
                                <dx:ASPxGridView runat="server" Settings-ShowColumnHeaders="false" OnDataBinding="gridLeads_DataBinding" ID="gridLeads" Border-BorderStyle="None" ClientInstanceName="gridLeads" Width="100%" Settings-VerticalScrollableHeight="0" AutoGenerateColumns="False" KeyFieldName="BBLE" SettingsBehavior-AutoExpandAllGroups="True" SettingsPager-Mode="ShowAllRecords" OnHtmlRowPrepared="gridLeads_HtmlRowPrepared">
                                    <Columns>
                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Name="colSelect" Visible="true" Width="25px">
                                        </dx:GridViewCommandColumn>
                                        <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False">
                                            <Settings AllowHeaderFilter="False"></Settings>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Neighborhood" Visible="false"></dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Type" Width="30px" CellStyle-HorizontalAlign="Center" CellStyle-VerticalAlign="Middle">
                                            <DataItemTemplate>
                                                <dx:ASPxImage runat="server" ID="imgType" ImageUrl="~/images/Opportunities-icon.jpg" Width="24" Height="24" Visible="false"></dx:ASPxImage>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <SettingsBehavior AllowClientEventsOnLoad="false" AllowFocusedRow="true"
                                        EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                    <Settings ShowColumnHeaders="False" VerticalScrollableHeight="50"></Settings>
                                    <Styles>
                                        <Row Cursor="pointer" />
                                        <AlternatingRow BackColor="#F5F5F5"></AlternatingRow>
                                        <RowHotTrack BackColor="#FF400D"></RowHotTrack>
                                    </Styles>
                                    <Border BorderStyle="None"></Border>
                                    <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />
                                </dx:ASPxGridView>
                            </div>

                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane Name="ContentUrlPane" Size="260px">
                <PaneStyle Border-BorderStyle="None"></PaneStyle>
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <div style="width: 100%; height: 100%; /*border: 1px solid gray; border-bottom: 1px solid gray; */">
                            <div style="margin: 30px 20px 30px 10px; text-align: left; padding-left: 5px" class="clearfix">
                                <div style="font-size: 24px;" class="clearfix">
                                    <i class="fa fa-group with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                                    <span style="color: #234b60; font-size: 30px;">
                                        <dx:ASPxLabel Text="Select Employee" ID="ASPxLabel1" Font-Size="16px" ClientInstanceName="LeadCategory" runat="server"></dx:ASPxLabel>
                                    </span>

                                </div>
                            </div>
                            <%--<div style="/*background-color: #efefef; border-bottom: 1px solid gray; */ text-align: left; padding-left: 5px">
                                <dx:ASPxLabel Text="Select Employee" ID="ASPxLabel1" Font-Bold="true" ClientInstanceName="LeadCategory" runat="server"></dx:ASPxLabel>
                            </div>--%>
                            <dx:ASPxListBox runat="server" ID="listboxEmployee" Height="450" TextField="Name" ValueField="EmployeeID"
                                SelectedIndex="0" Width="100%" Border-BorderStyle="None">
                                <Border BorderStyle="None"></Border>
                                <Items>
                                    <dx:ListEditItem Text="Allen Glover" Value="1" />
                                    <dx:ListEditItem Text="Alon Zeituny" Value="2" />
                                    <dx:ListEditItem Text="Andrea Taylor" Value="3" />
                                    <dx:ListEditItem Text="Allen Glover" Value="1" />
                                    <dx:ListEditItem Text="Alon Zeituny" Value="2" />
                                    <dx:ListEditItem Text="Andrea Taylor" Value="3" />
                                    <dx:ListEditItem Text="Allen Glover" Value="1" />
                                    <dx:ListEditItem Text="Alon Zeituny" Value="2" />
                                    <dx:ListEditItem Text="Andrea Taylor" Value="3" />
                                    <dx:ListEditItem Text="Allen Glover" Value="1" />
                                    <dx:ListEditItem Text="Alon Zeituny" Value="2" />
                                    <dx:ListEditItem Text="Andrea Taylor" Value="3" />
                                    <dx:ListEditItem Text="Allen Glover" Value="1" />
                                    <dx:ListEditItem Text="Alon Zeituny" Value="2" />
                                    <dx:ListEditItem Text="Andrea Taylor" Value="3" />
                                </Items>
                                <ItemStyle
                                    CssClass="border_under_line" />
                            </dx:ASPxListBox>
                            <div style="margin-left: 10px; margin-top: 10px">
                                <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign"></dx:ASPxButton>
                            </div>
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane Name="RightPane" Size="730px" ScrollBars="None">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <uc1:LeadsInfo runat="server" ID="LeadsInfo" ShowLogPanel="false" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane AllowResize="False" Separator-Visible="False">
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>
</asp:Content>
