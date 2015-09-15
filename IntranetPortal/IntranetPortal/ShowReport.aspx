<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShowReport.aspx.vb" Inherits="IntranetPortal.ShowReport"%>

<%@ Register Assembly="DevExpress.XtraReports.v15.1.Web, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lead Report</title>
</head>
<body style="height: 100%; margin:0px;">
    <form id="form1" runat="server">
        <div style="height: 800px">            
            <dx:ASPxDocumentViewer ID="ASPxDocumentViewer1" runat="server" Height="100%">
                <SettingsSplitter SidePaneVisible="false" />
               <%-- <StylesViewer>
                    <BookmarkSelectionBorder BorderColor="Gray" BorderStyle="Dashed" BorderWidth="3px"></BookmarkSelectionBorder>
                </StylesViewer>
                <StylesSplitter>
                    <Pane>
                        <Paddings Padding="16px"></Paddings>
                    </Pane>
                </StylesSplitter>--%>
            </dx:ASPxDocumentViewer>
        </div>
    </form>
</body>
</html>
