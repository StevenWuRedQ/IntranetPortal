<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DocumentsUI.ascx.vb" Inherits="IntranetPortal.DocumentsUI" %>


<script type="text/javascript">
    function PreviewDocument(url, type) {
        aspxPopupDocumentControl.ShowAtElementByID("divLeftContent");

        if (type.indexOf("pdf") > 0) {
            url = "/pdfViewer/web/viewer.html?file=" + encodeURIComponent(url);
        }
        aspxPopupDocumentControl.SetContentUrl(url);
    }

    function SetChange() {

    }
</script>
<div style="color: #999ca1;">
    <div style="padding: 35px 20px 35px 20px;" class="border_under_line">
        
        <div style="width: 100%">
            <div class="font_30">
                <i class="fa fa-file"></i>&nbsp;
                                            <span class="font_light">Documents</span>
            </div>
            <div style="padding-left: 39px;" class="clearfix">
                <span style="font-size: 14px;"><%= LeadsName %></span>
                <span class="color_blue expand_button" style="padding-right: 25px">Collapse All</span>
                <span class="color_blue expand_button">Expand All&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            </div>
        </div>
    </div>
    <%--<h3>Documents - <%= LeadsName %></h3>--%>
    <asp:DataList runat="server" ID="datalistCategory" RepeatColumns="2" RepeatDirection="Horizontal" Width="100%">
        <ItemTemplate>
            <%-- <div class="doc_list_section">
                <div class="panel-group" id="accordion<%# Eval("Key")%>">
                    <div class="panel panel-default" style="border:0">
                        <div class="panel-heading" style="background:transparent">
                            <h4 class="panel-title doc_list_title  color_balck" style="cursor:pointer" data-toggle="collapse" data-parent="#accordion<%# Eval("Key")%>" href="#collapse<%# Eval("Key")%>">
                                <%# Eval("Key")%>
                                  &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue collapse_btn"></i>
                              
                            </h4>
                        </div>
                        <div id="collapse<%# Eval("Key")%>"" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <asp:Repeater runat="server" ID="rptFiles">
                                    <ItemTemplate>

                                        <div class="clearfix">
                                            <input type="checkbox" name="vehicle" value="Bike" id="<%# String.Format("doc_list_id_{0}", Eval("FileID"))%>" />
                                            <label class="doc_list_checks check_margin" for='<%# String.Format("doc_list_id_{0}", Eval("FileID"))%>'>
                                                <span class="color_balck">
                                                    <dx:ASPxHyperLink runat="server" NavigateUrl='<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>' Text='<%# Eval("Name")%>' Target="_blank"></dx:ASPxHyperLink>
                                                </span>(Financials)
                                                            <span class="checks_data_text">
                                                                <dx:ASPxLabel runat="server" Text='<%# String.Format("{0:g}", Eval("CreateDate")) %>'></dx:ASPxLabel>
                                                            </span>

                                            </label>
                                        </div>

                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>

                </div>
           </div>--%>
            <div class="doc_list_section">
                <div id="default-example" data-collapse="">
                    <h3 class="doc_list_title  color_balck"><%# Eval("Key")%> &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue"></i></h3>
                    <div>

                        <%--<h4><%# Eval("Key")%></h4>--%>
                        <asp:Repeater runat="server" ID="rptFiles">

                            <ItemTemplate>
                                <%--                <tr onclick="PreviewDocument('<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>', '<%# Eval("ContentType")%>');" style="cursor:pointer" onmouseover="this.bgColor = '#D1DEFB';" onmouseout="this.bgColor = '';">--%>

                                <div class="clearfix">
                                    <input type="checkbox" name="vehicle" value="Bike" id="<%# String.Format("doc_list_id_{0}", Eval("FileID"))%>" />
                                    <label class="doc_list_checks check_margin" for='<%# String.Format("doc_list_id_{0}", Eval("FileID"))%>'>
                                        <span class="color_balck">
                                            <dx:ASPxHyperLink runat="server" NavigateUrl='<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>' Text='<%# Eval("Name")%>' Target="_blank"></dx:ASPxHyperLink>
                                        </span>(Financials)
                                                        <span class="checks_data_text">
                                                            <dx:ASPxLabel runat="server" Text='<%# String.Format("{0:g}", Eval("CreateDate")) %>'></dx:ASPxLabel>
                                                        </span>

                                    </label>
                                </div>
                                <%-- onclick="window.open('/pdfViewer/web/viewer.html?file=' + encodeURIComponent('<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))  %>'), '_blank');"--%>
                                <%-- <tr>
                                    <td style="width: 20px;">
                                        <dx:ASPxCheckBox runat="server"></dx:ASPxCheckBox>
                                    </td>
                                 
                                    <td style="width: 150px">
                                        <dx:ASPxHyperLink runat="server" NavigateUrl='<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>' Text='<%# Eval("Name")%>' Target="_blank"></dx:ASPxHyperLink>
                                    </td>
                                    <td>
                                        <dx:ASPxLabel runat="server" Text='<%# String.Format("{0:g}", Eval("CreateDate")) %>'></dx:ASPxLabel>
                                    </td>
                                </tr>--%>
                            </ItemTemplate>
                        </asp:Repeater>

                    </div>

                </div>

            </div>
        </ItemTemplate>
    </asp:DataList>
    <dx:ASPxPopupControl ClientInstanceName="aspxPopupDocumentControl" Width="680px" Height="630px"
        ID="ASPxPopupControl1" HeaderText="Preview Document" AutoUpdatePosition="true" runat="server" EnableViewState="false" EnableHierarchyRecreation="True" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="TopSides">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</div>
