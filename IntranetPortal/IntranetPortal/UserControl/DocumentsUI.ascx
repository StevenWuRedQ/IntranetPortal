<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DocumentsUI.ascx.vb" Inherits="IntranetPortal.DocumentsUI" %>
<script type="text/javascript">
    function PreviewDocument(url, type)
    {
        aspxPopupDocumentControl.ShowAtElementByID("divLeftContent");

        if (type.indexOf("pdf") > 0)
        {
            url = "/pdfViewer/web/viewer.html?file=" + encodeURIComponent(url);
        }
        aspxPopupDocumentControl.SetContentUrl(url);
    }

    function SetChange()
    {

    }
</script>
<h3>Documents - <%= LeadsName %></h3>
<asp:DataList runat="server" ID="datalistCategory" RepeatColumns="2" RepeatDirection="Horizontal" Width="100%">
    <ItemTemplate>
        <h4><%# Eval("Key")%></h4>
        <asp:Repeater runat="server" ID="rptFiles">
            <HeaderTemplate>
                <table style="width: 90%">
            </HeaderTemplate>
            <ItemTemplate>
<%--                <tr onclick="PreviewDocument('<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>', '<%# Eval("ContentType")%>');" style="cursor:pointer" onmouseover="this.bgColor = '#D1DEFB';" onmouseout="this.bgColor = '';">--%>
                <tr>    
                <td style="width: 20px;">
                        <dx:ASPxCheckBox runat="server"></dx:ASPxCheckBox>
                    </td>
                    <%-- onclick="window.open('/pdfViewer/web/viewer.html?file=' + encodeURIComponent('<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))  %>'), '_blank');"--%>
                    <td style="width: 150px">
                        <dx:ASPxHyperLink runat="server" NavigateUrl='<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>' Text='<%# Eval("Name")%>' Target="_blank"></dx:ASPxHyperLink>
                    </td>
                    <td>
                        <dx:ASPxLabel runat="server" Text='<%# String.Format("{0:g}", Eval("CreateDate")) %>'></dx:ASPxLabel>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </ItemTemplate>
</asp:DataList>
  <dx:ASPxPopupControl ClientInstanceName="aspxPopupDocumentControl" Width="680px" Height="630px"
        ID="ASPxPopupControl1" HeaderText="Preview Document" AutoUpdatePosition="true" runat="server" EnableViewState="false" EnableHierarchyRecreation="True" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="TopSides">        
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>