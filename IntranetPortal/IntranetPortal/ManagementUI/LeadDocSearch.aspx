<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LeadDocSearch.aspx.vb" Inherits="IntranetPortal.LeadDocSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function OnGridFocusedRowChanged() {

            var bble = grid.GetRowKey(grid.GetFocusedRowIndex());
            if (bble)
            {
                document.getElementById('TaxSearchFrame').src = '/popupControl/LeadTaxSearchRequest.aspx?BBLE=' + bble
            } 
          
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container-fluid" style="height: 100%">
        <div class="row-fluid">

            <div class="col-md-2" style="padding-right: 10px; border-right: 10px solid #e7e9ee; min-height: 900px">
                <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
                    <div style="font-size: 24px;" class="clearfix">
                        <div class="clearfix">
                            <i class="fa fa-search-plus with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                                <span style="color: #234b60; font-size: 30px;">
                                    <span style="font-size: 30px; cursor: pointer;">Searches</span>
                                </span>

                        </div>
                    </div>



                </div>
                <dx:ASPxGridView ID="gridDocSearch" ClientInstanceName="grid" runat="server" KeyFieldName="BBLE" OnDataBinding="gridDocSearch_DataBinding">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="Name">
                            <DataItemTemplate>
                                <div><%# Eval("Name") %> </div>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Status">
                            <GroupRowTemplate>
                                <div>
                                    <table style="height: 30px">
                                        <tr>
                                            <td style="width: 80px;"><span class="font_black"><i class="fa fa-caret-<%#If(Container.Expanded,"down","right") %> font_16" onclick="ExpandOrCollapseGroupRow(this, gridEmpsClient, <%# Container.VisibleIndex%>)" style="cursor: pointer"></i>&nbsp; <i class="fa fa-bank font_16"></i>&nbsp; <%# CType(CInt(Container.GroupText), IntranetPortal.Data.LeadInfoDocumentSearch.SearchStauts).ToString%>
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
                    <GroupSummary>
                        <dx:ASPxSummaryItem SummaryType="Count" />
                    </GroupSummary>
                    <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" AllowFocusedRow="true" AllowClientEventsOnLoad="true" />
                    <Settings ShowColumnHeaders="False" GridLines="None"></Settings>
                    <Border BorderStyle="None"></Border>
                    <Styles>
                        <Header HorizontalAlign="Center"></Header>
                        <Row Cursor="pointer" />
                        <AlternatingRow BackColor="#F5F5F5"></AlternatingRow>
                        <RowHotTrack BackColor="#FF400D"></RowHotTrack>
                    </Styles>
                    <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />
                </dx:ASPxGridView>
            </div>
            <div class="col-md-10" style="padding: 0">
                <iframe width="100%" id="TaxSearchFrame" style="min-height: 900px" frameborder="0" src="/popupControl/LeadTaxSearchRequest.aspx?BBLE=3015000055"></iframe>
            </div>
        </div>
    </div>
</asp:Content>
