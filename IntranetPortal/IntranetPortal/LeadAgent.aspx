<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadAgent.aspx.vb" Inherits="IntranetPortal.LeadAgent" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>
<%@ Register Src="~/UserControl/LeadsList.ascx" TagPrefix="uc1" TagName="LeadsList" %>
<%@ Register Src="~/UserControl/LeadsStatisticSummary.ascx" TagPrefix="uc1" TagName="LeadsStatisticSummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="../styles/stevencss.css" rel='stylesheet' type='text/css' />
    <link href="../css/font-awesome.css" type="text/css" rel="stylesheet" />

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="../scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scripts/jquery.collapse.js"></script>
    <script src="/scripts/jquery.collapse_storage.js"></script>
    <script src="/scripts/jquery.collapse_cookie_storage.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="background: url(/images/MyIdealProptery.png) no-repeat center fixed; background-size: 260px, 260px; background-color: #dddddd; width: 100%; height: 100%;">
            <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientVisible="false" ClientInstanceName="splitter" Orientation="Vertical" FullscreenMode="true">
                <Panes>
                    <dx:SplitterPane Name="leadContent">
                        <Panes>
                            <dx:SplitterPane Name="leadPanel" Collapsed="true" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="260px">
                                <ContentCollection>
                                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                                        <uc1:LeadsList runat="server" ID="LeadsList" />
                                    </dx:SplitterContentControl>
                                </ContentCollection>
                            </dx:SplitterPane>
                            <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="Auto">
                                <PaneStyle BackColor="#F9F9F9">
                                </PaneStyle>
                                <ContentCollection>
                                    <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                                        <uc1:LeadsInfo runat="server" ID="LeadsInfo" ClientVisible="false" />
                                    </dx:SplitterContentControl>
                                </ContentCollection>
                            </dx:SplitterPane>
                        </Panes>
                        <ContentCollection>
                            <dx:SplitterContentControl runat="server" SupportsDisabledAttribute="True"></dx:SplitterContentControl>
                        </ContentCollection>
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
    </form>
</body>
</html>
