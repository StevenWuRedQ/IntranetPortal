<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProcessReport.aspx.vb" Inherits="IntranetPortal.ProcessReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">       
            <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" FullscreenMode="true" Width="100%" Height="100%" Theme="Moderno">                
                <Panes>                    
                    <dx:SplitterPane Size="220px" AllowResize="False">
                       <Separator Visible="False"></Separator>
                        <ContentCollection>
                            <dx:SplitterContentControl runat="server">
                                <dx:ASPxNavBar ID="ASPxNavBar1" runat="server" Theme="Moderno">
                                    <Groups>
                                        <dx:NavBarGroup Text="Reports">
                                            <Items>
                                                <dx:NavBarItem Text="Summary" NavigateUrl="Reports/ReportSummary.aspx" Target="FrmReport">
                                                    <Image IconID="chart_chart_16x16" />
                                                </dx:NavBarItem>
                                                <dx:NavBarItem Text="Process Instances" NavigateUrl="Reports/ProcInstReport.aspx" Target="FrmReport">
                                                    <Image IconID="page_documentmap_16x16gray" />
                                                </dx:NavBarItem>
                                                <dx:NavBarItem Text="Worklists" NavigateUrl="Reports/WorklistReport.aspx" Target="FrmReport">
                                                    <Image IconID="tasks_task_16x16" />
                                                </dx:NavBarItem>
                                            </Items>
                                        </dx:NavBarGroup>
                                    </Groups>
                                </dx:ASPxNavBar>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                    <dx:SplitterPane ContentUrl="about:blank" AllowResize="False" ContentUrlIFrameName="FrmReport">   
                         <Separator Visible="False"></Separator>             
                    </dx:SplitterPane>
                </Panes>
            </dx:ASPxSplitter>       
    </form>
</body>
</html>
