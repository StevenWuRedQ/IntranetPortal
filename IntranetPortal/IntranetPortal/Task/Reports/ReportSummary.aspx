<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Task/Reports/WorkflowReprot.Master" CodeBehind="ReportSummary.aspx.vb" Inherits="IntranetPortal.ReportSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderMain" runat="server">
    <script type="text/javascript">
        function LoadUserlist(span) {
            var userName = span.innerText;
            var contentPane = splitterReportSummary.GetPaneByName("paneSubReport")
            contentPane.SetContentUrl("WorklistReport.aspx?u=" + userName);
        }

        function LoadProcessList(span) {
            var userName = span.innerText;
            var contentPane = splitterReportSummary.GetPaneByName("paneSubReport")
            contentPane.SetContentUrl("ProcInstReport.aspx?p=" + userName);
        }
    </script>
    <dx:ASPxSplitter ID="ASPxSplitter1" ClientInstanceName="splitterReportSummary" runat="server" FullscreenMode="true" Width="100%" Height="100%" Theme="Moderno">
        <Panes>
            <dx:SplitterPane Size="520px" AllowResize="False" PaneStyle-Border-BorderStyle="None">
                <Separator Visible="False"></Separator>
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <h3>Worklist Summary</h3>
                        <dx:ASPxButton runat="server" Text="Refresh" AutoPostBack="false">
                            <ClientSideEvents Click="function(s,e){gridWorklistStatistic.Refresh();}" />
                        </dx:ASPxButton>
                        <dx:ASPxGridView ID="gridWorklistStatistic" ClientInstanceName="gridWorklistStatistic" runat="server" KeyFieldName="DestinationUser" Theme="Moderno" OnDataBinding="gridWorklistStatistic_DataBinding">
                            <Columns>
                                <dx:GridViewDataColumn FieldName="Name" VisibleIndex="0">
                                    <DataItemTemplate>
                                        <a href="#" onclick="LoadUserlist(this)"><%# Eval("Name")%></a>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn FieldName="Active" VisibleIndex="1" />
                                <dx:GridViewDataColumn FieldName="Open" VisibleIndex="2" />
                                <dx:GridViewDataColumn FieldName="Completed" VisibleIndex="3" />
                                <dx:GridViewDataColumn FieldName="Expired"></dx:GridViewDataColumn>
                                <dx:GridViewDataTextColumn FieldName="Total">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                        <h3>Process Summary</h3>
                        <dx:ASPxButton runat="server" Text="Refresh" AutoPostBack="false">
                            <ClientSideEvents Click="function(s,e){gridProcInst.Refresh();}" />
                        </dx:ASPxButton>
                        <dx:ASPxGridView ID="ASPxGridView1" ClientInstanceName="gridProcInst" runat="server" KeyFieldName="ProcessName" Theme="Moderno" OnDataBinding="ASPxGridView1_DataBinding">
                            <Columns>
                                <dx:GridViewDataColumn FieldName="ProcessName" VisibleIndex="0">
                                    <DataItemTemplate>
                                        <a href="#" style="cursor: pointer" onclick="LoadProcessList(this)"><%# Eval("ProcessName")%></a>
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataColumn FieldName="Active" VisibleIndex="1" />
                                <dx:GridViewDataColumn FieldName="Completed" VisibleIndex="2" />
                                <dx:GridViewDataColumn FieldName="Terminated" VisibleIndex="3" />
                                <dx:GridViewDataColumn FieldName="InError"></dx:GridViewDataColumn>
                                <dx:GridViewDataTextColumn FieldName="Total">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane ContentUrl="about:blank" AllowResize="False" Name="paneSubReport" ContentUrlIFrameName="FrmReport">
                <Separator Visible="False"></Separator>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>
    <table style="width: 100%; margin: 10px; display: none">
        <tr>
            <td style="width: 50%; vertical-align: top"></td>
            <td style="width: 50%; vertical-align: top">
                <h3>User Summary</h3>
                User Name:
                <dx:ASPxLabel runat="server" Text="" ID="lblUserName" ClientInstanceName="lblUserName" Theme="Moderno"></dx:ASPxLabel>
                <dx:ASPxGridView ID="gridUser" ClientInstanceName="gridUser" runat="server" EnableViewState="true" EnableRowsCache="true" KeyFieldName="ProcessName" Theme="Moderno" OnCustomCallback="gridUser_CustomCallback" OnDataBinding="gridUser_DataBinding">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="Id" VisibleIndex="0" />
                        <dx:GridViewDataColumn FieldName="ProcessName" VisibleIndex="1" />
                        <dx:GridViewDataColumn FieldName="ActivityName" VisibleIndex="2" />
                        <dx:GridViewDataColumn FieldName="DestinationUser" VisibleIndex="3" Visible="false" />
                        <dx:GridViewDataTextColumn FieldName="CreateDate" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="G">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="G" />
                        <dx:GridViewDataColumn FieldName="Status"></dx:GridViewDataColumn>
                        <dx:GridViewDataTextColumn FieldName="Duration">
                            <PropertiesTextEdit DisplayFormatString="dd\.hh\:mm\:ss"></PropertiesTextEdit>
                        </dx:GridViewDataTextColumn>
                    </Columns>
                    <Templates>
                        <FooterRow>
                            <asp:HiddenField runat="server" ID="hfUser" />
                            Test
                        </FooterRow>
                    </Templates>
                    <GroupSummary>
                        <dx:ASPxSummaryItem FieldName="Id" SummaryType="Count" DisplayFormat="Count: {0}" />
                        <dx:ASPxSummaryItem FieldName="Duration" SummaryType="Average" DisplayFormat="Avg Duration: {0:dd\.hh\:mm\:ss}" />
                    </GroupSummary>
                    <Settings ShowGroupPanel="true" ShowFooter="true" />
                </dx:ASPxGridView>
            </td>
        </tr>
    </table>
</asp:Content>
