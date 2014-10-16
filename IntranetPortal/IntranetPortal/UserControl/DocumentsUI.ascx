<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DocumentsUI.ascx.vb" Inherits="IntranetPortal.DocumentsUI" %>

<script src="/scripts/stevenjs.js"></script>
<script type="text/javascript">
    function UploadFiles() {
        var url = '/UploadFilePage.aspx?b=' + leadsInfoBBLE;
        //var centerLeft = parseInt((window.screen.availWidth - 640) / 2);
        //var centerTop = parseInt(((window.screen.availHeight - 400) / 2) - 50);          
        if (popupCtrUploadFiles) {
            popupCtrUploadFiles.SetContentUrl(url);
            popupCtrUploadFiles.Show();

            popupCtrUploadFiles.CloseUp.AddHandler(function (s, e) {
                if (typeof BindDocuments != "undefined")
                    BindDocuments(true);
            });
        }
        else
            window.open(url, 'Upload Files', popup_params(640, 400));
    }

    var IsDocumentLoaded = false;
    function BindDocuments(refreshDocuments) {
        if (!IsDocumentLoaded || refreshDocuments) {
            cbpDocumentUI.PerformCallback(leadsInfoBBLE);
            isLoaded = true;
        }
    }
</script>

<div style="color: #999ca1;">
    <div style="padding: 35px 20px 35px 20px;" class="border_under_line">
        <div style="width: 100%">
            <div class="font_30">
                <i class="fa fa-file"></i>&nbsp;
                <span class="font_light">Documents</span>
                <span class="time_buttons" onclick="UploadFiles()">Upload File</span>
            </div>
            <div style="padding-left: 39px;" class="clearfix">
                <span style="font-size: 14px;"><%= LeadsName %></span>
                <span class="color_blue expand_button" style="padding-right: 25px">Collapse All</span>
                <span class="color_blue expand_button">Expand All&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            </div>
        </div>
    </div>
    <dx:ASPxCallbackPanel runat="server" ID="cbpDocumentUI" ClientInstanceName="cbpDocumentUI" OnCallback="cbpDocumentUI_Callback">
        <PanelCollection>
            <dx:PanelContent>
                <asp:DataList runat="server" ID="datalistCategory" RepeatColumns="2" RepeatDirection="Horizontal" Width="100%">
                    <ItemTemplate>
                        <div class="doc_list_section">
                            <div id="default-example" data-collapse="">
                                <h3 class="doc_list_title  color_balck"><%# Eval("Key")%> &nbsp;&nbsp;<i class="fa fa-minus-square-o color_blue" onclick="clickCollapse(this, '<%# Eval("Key")%>')"></i> </h3>
                                <div id="<%# Eval("Key")%>">

                                    <%--<h4><%# Eval("Key")%></h4>--%>
                                    <asp:Repeater runat="server" ID="rptFiles">

                                        <ItemTemplate>
                                            <%--                <tr onclick="PreviewDocument('<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>', '<%# Eval("ContentType")%>');" style="cursor:pointer" onmouseover="this.bgColor = '#D1DEFB';" onmouseout="this.bgColor = '';">--%>

                                            <div class="clearfix">
                                                <input type="checkbox" name="vehicle" value="Bike" id="<%# String.Format("doc_list_id_{0}", Eval("FileID"))%>" />
                                                <label class="doc_list_checks check_margin" for='<%# String.Format("doc_list_id_{0}", Eval("FileID"))%>'>
                                                    <span class="color_balck">
                                                        <dx:ASPxHyperLink runat="server" NavigateUrl='<%# String.Format("/DownloadFile.aspx?id={0}&spFile={1}", Eval("FileID"), Eval("Description"))%>' Text='<%# Eval("Name")%>' Target="_blank"></dx:ASPxHyperLink>
                                                    </span>
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
            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents EndCallback="function(s,e){IsDocumentLoaded= true;}" Init="function(s,e){IsDocumentLoaded= false;}" />
    </dx:ASPxCallbackPanel>   
</div>
