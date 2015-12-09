<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MyCompleted.aspx.vb" Inherits="IntranetPortal.MyCompleted" MasterPageFile="~/Content.Master" %>
<%@ Register Src="~/Task/TasklistControl.ascx" TagPrefix="uc1" TagName="TasklistControl" %>
<%@ Register Src="~/Task/OriginatedListControl.ascx" TagPrefix="uc1" TagName="OriginatedListControl" %>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitterTaskPage" Orientation="Horizontal" FullscreenMode="true">
        <Panes>
            <dx:SplitterPane Name="leadPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="270px" PaneStyle-Paddings-Padding="2px">
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                        <uc1:OriginatedListControl runat="server" ID="OriginatedListControl" DisplayMode="Completed" HeaderText="Review" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="Auto" ContentUrl="about:blank" PaneStyle-Paddings-Padding="0px" ContentUrlIFrameName="FrmTaskContent">               
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>
</asp:Content>