<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="QueryBuilder.aspx.vb" Inherits="IntranetPortal.QueryBuilder" %>

<%@ Register Assembly="ActiveDatabaseSoftware.ActiveQueryBuilder2.Web.Control, Version=2.8.7.0, Culture=neutral, PublicKeyToken=3cbcbcc9bf57ecde" Namespace="ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Control" TagPrefix="AQB" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxSplitter runat="server" ID="splitter" Width="100%" Height="100%" FullscreenMode="true" Orientation="Vertical">
            <Panes>
                <dx:SplitterPane Size="570px">
                    <ContentCollection>
                        <dx:SplitterContentControl runat="server">                       
                            <AQB:QueryBuilderControl ID="QueryBuilderControl1" runat="server" OnInit="QueryBuilderControl1_Init" />
                            <div id="all">
                                <div id="content-container">
                                    <div id="qb-ui">
                                        <AQB:ObjectTree ID="ObjectTree1" runat="server" ShowFields="true" />
                                        <div id="center">
                                            <AQB:Canvas ID="Canvas1" runat="server" />
                                            <AQB:Grid ID="Grid1" runat="server" />
                                            <AQB:StatusBar ID="StatusBar1" runat="server" /> 
                                            <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Query" OnClick="ASPxButton1_Click">
                            </dx:ASPxButton>
                                             <dx:ASPxButton ID="btnExport" runat="server" Text="Export to Excel" OnClick="btnExport_Click">
                            </dx:ASPxButton>
                                        </div>
                                        <div class="clear"></div>
                                    </div>
                                </div>
                                <AQB:SqlEditor ID="SQLEditor1" runat="server" Visible="false"></AQB:SqlEditor>
                            </div>
                           
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane>
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <dx:ASPxGridView ID="gridResult2" runat="server" AutoGenerateColumns="true" OnDataBinding="gridResult2_DataBinding">
                                <Columns>
                                    <dx:GridViewDataColumn></dx:GridViewDataColumn>
                                </Columns>
                            </dx:ASPxGridView>
                             <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridResult2"></dx:ASPxGridViewExporter>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </form>
</body>
</html>
