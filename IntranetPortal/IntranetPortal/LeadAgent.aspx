<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadAgent.aspx.vb" Inherits="IntranetPortal.LeadAgent" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>
<%@ Register Src="~/UserControl/LeadsList.ascx" TagPrefix="uc1" TagName="LeadsList" %>
<%@ Register Src="~/UserControl/LeadsStatisticSummary.ascx" TagPrefix="uc1" TagName="LeadsStatisticSummary" %>

   <asp:Content ContentPlaceHolderID="MainContentPH" runat="server">  
        <div style="background: url(/images/MyIdealProptery.png) no-repeat center fixed; background-size: 260px, 280px; background-color: #dddddd; width: 100%; height: 100%;">
            <!-- Be careful with Padding  -->
            <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientVisible="false" ClientInstanceName="splitter" Orientation="Vertical" FullscreenMode="true">
                <Panes>
                    <dx:SplitterPane Name="leadContent">
                        <Panes>
                            <dx:SplitterPane Name="leadPanel" Collapsed="true" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="2px">
                                <ContentCollection>
                                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                                        <uc1:LeadsList runat="server" ID="LeadsList" />
                                    </dx:SplitterContentControl>
                                </ContentCollection>
                            </dx:SplitterPane>
                            <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="Auto" PaneStyle-Paddings-Padding="0px">
                                <PaneStyle BackColor="#F9F9F9">
                                </PaneStyle>
                                <ContentCollection>
                                    <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                                        <uc1:LeadsInfo runat="server" ID="LeadsInfo" ClientVisible="false" />
                                    </dx:SplitterContentControl>
                                </ContentCollection>
                            </dx:SplitterPane>
                        </Panes>
                    </dx:SplitterPane>
                    <dx:SplitterPane Name="SummaryPanel" Size="18px" MinSize="1px" Separator-Visible="False" PaneStyle-Paddings-Padding="0px" CollapsedStyle-Border-BorderStyle="None" AutoHeight="false">
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
                                <uc1:LeadsStatisticSummary runat="server" ID="LeadsStatisticSummary" />
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                </Panes>
            </dx:ASPxSplitter>
        </div>
    </asp:Content>