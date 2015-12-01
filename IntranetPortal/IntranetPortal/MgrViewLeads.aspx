<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MgrViewLeads.aspx.vb" EnableEventValidation="false" Inherits="IntranetPortal.MgrViewLeads" MasterPageFile="~/Content.Master" Trace="false" %>

<%@ Register Src="~/UserControl/LeadsList.ascx" TagPrefix="uc1" TagName="LeadsList" %>
<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>
<%@ Register Src="~/UserControl/DoorKnockMap.ascx" TagPrefix="uc1" TagName="DoorKnockMap" %>
<%@ Register Src="~/UserControl/LeadsStatisticSummary.ascx" TagPrefix="uc1" TagName="LeadsStatisticSummary" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style>
        #__asptrace {
            position: absolute;
            height: 500px;
            width: 1000px;
            top: 10px;
            right: 10px;
            overflow: scroll;
            background-color: white;
        }
    </style>
    <div style="background: url(/images/Background2.png) no-repeat center fixed; background-size: auto, auto; background-color: #dddddd; width: 100%; height: 100%;" id="LeadCotrl">

        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientVisible="false" ClientInstanceName="splitter" Orientation="Vertical" FullscreenMode="true">
            <Panes>
                <dx:SplitterPane Name="leadContent">
                    <Panes>
                        <dx:SplitterPane Name="leadPanel" Collapsed="true" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="800px" Size="270px" PaneStyle-Border-BorderStyle="None" PaneStyle-Paddings-Padding="2px">
                            <ContentCollection>
                                <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                                    <uc1:LeadsList runat="server" ID="LeadsList" LeadsListView="ManagerView" />
                                </dx:SplitterContentControl>
                            </ContentCollection>
                        </dx:SplitterPane>
                        <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="Auto" PaneStyle-Paddings-Padding="0px">
                            <ContentCollection>
                                <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                                    <uc1:LeadsInfo runat="server" ID="LeadsInfo" ClientVisible="false" />
                                </dx:SplitterContentControl>
                            </ContentCollection>
                        </dx:SplitterPane>
                    </Panes>
                </dx:SplitterPane>
                <dx:SplitterPane Name="SummaryPanel" Size="18px" MinSize="1px" Separator-Visible="False" PaneStyle-Paddings-Padding="0px" PaneStyle-BackColor="gray" CollapsedStyle-Border-BorderStyle="None" AutoHeight="false" Visible="false">
                    <Separator Visible="False"></Separator>
                    <PaneStyle>
                        <Border BorderStyle="None" />
                        <Paddings Padding="0" />
                    </PaneStyle>
                    <CollapsedStyle>
                        <Border BorderStyle="None"></Border>
                    </CollapsedStyle>
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <%--<uc1:LeadsStatisticSummary runat="server" ID="LeadsStatisticSummary" />--%>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>

    <script>
        
    </script>
</asp:Content>