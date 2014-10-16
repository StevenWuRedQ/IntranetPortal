<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UploadFilePage.aspx.vb" Inherits="IntranetPortal.UploadFilePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upload Files</title>
    <script type="text/javascript">
        // <![CDATA[
        function Uploader_OnUploadStart() {
            btnUpload.SetEnabled(false);
        }
        function Uploader_OnFileUploadComplete(args) {
            if (args.isValid) {
                gridFilesClient.PerformCallback(args.callbackData + "|" + hfBBLEClient.Get("BBLE"));
            }
        }
        function Uploader_OnFilesUploadComplete(args) {
            UpdateUploadButton();
        }
        function UpdateUploadButton() {
            btnUpload.SetEnabled(uploader.GetText(0) != "");
        }
        function getPreviewImageElement() {
            return document.getElementById("previewImage");
        }

        function UpdateCategory(logId, sender) {
            var newCategory = sender.GetValue();
            gridFilesClient.PerformCallback("UpdateCategory|" + logId + "|" + newCategory + "|" + hfBBLEClient.Get("BBLE"));
        }
        // ]]> 
    </script>
</head>
<body style="margin-top: 10px; margin-left: 10px;">
    <form id="form1" runat="server">
        <table style="width: 620px; text-align: left; margin: 10px,10px,0,0;">
            <tr>
                <td class="caption" style="width: 100px;">
                    <dx:ASPxLabel ID="lblSelectImage" runat="server" Text="Select File:">
                    </dx:ASPxLabel>
                </td>
                <td>
                    <dx:ASPxUploadControl ID="uplImage" runat="server" ClientInstanceName="uploader" ShowProgressPanel="True" ShowAddRemoveButtons="true" AddUploadButtonsHorizontalPosition="Left"
                        NullText="Click here to browse files..." Size="35" OnFileUploadComplete="uplImage_FileUploadComplete" Width="100%">
                        <ClientSideEvents FileUploadComplete="function(s, e) { Uploader_OnFileUploadComplete(e); }"
                            FilesUploadComplete="function(s, e) { Uploader_OnFilesUploadComplete(e); }"
                            FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"
                            TextChanged="function(s, e) { UpdateUploadButton(); }"></ClientSideEvents>
                        <ValidationSettings MaxFileSize="4194304">
                        </ValidationSettings>
                    </dx:ASPxUploadControl>
                    <dx:ASPxHiddenField runat="server" ID="hfBBLE" ClientInstanceName="hfBBLEClient"></dx:ASPxHiddenField>
                    <asp:HiddenField runat="server" ID="hfBBLEData" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td class="note">
                    <dx:ASPxLabel ID="lblAllowebMimeType" runat="server" Text="Allowed types: jpeg, gif, doc, pdf;"
                        Font-Size="8pt">
                    </dx:ASPxLabel>
                    <dx:ASPxLabel ID="lblMaxFileSize" runat="server" Text="Maximum file size: 4Mb" Font-Size="8pt">
                    </dx:ASPxLabel>
                </td>
            </tr>
            <tr style="height: 40px;">
                <td>
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Category:">
                    </dx:ASPxLabel>
                </td>
                <td class="buttonCell" style="margin-bottom: 5px;" >
                    <table style="width:100%">
                        <tr>
                            <td>
                                 <dx:ASPxComboBox runat="server" ID="cbCategory" DropDownStyle="DropDown" NullText="Input New Category">
                                     <Border BorderWidth="1" />
                                        <Items>
                                            <dx:ListEditItem Text="Financials" Value="Financials" />
                                            <dx:ListEditItem Text="Short Sale" Value="ShortSale" />
                                            <dx:ListEditItem Text="Photos" Value="Photos" />
                                            <dx:ListEditItem Text="Accounting" Value="Accounting" />
                                            <dx:ListEditItem Text="Eviction" Value="Eviction" />
                                            <dx:ListEditItem Text="Construction" Value="Construction" />
                                        </Items>
                                     <ValidationSettings RequiredField-IsRequired="true"></ValidationSettings>
                                    </dx:ASPxComboBox>
                            </td>
                            <td  style="text-align: right">
                                <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Upload" Visible="false"  Width="100px" ClientEnabled="False" Style="margin: 0 auto;">
                                    <ClientSideEvents Click="function(s, e) { uploader.Upload(); }" />
                                </dx:ASPxButton>
                                 <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Upload To Sharepoint" Width="100px" Style="margin: 0 auto;" ClientInstanceName="btnUpload" ClientEnabled="False" OnClick="ASPxButton1_Click">
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <dx:ASPxGridView runat="server" Width="100%" ID="gridFiles" ClientInstanceName="gridFilesClient" OnCustomCallback="gridFiles_CustomCallback" KeyFieldName="FileID" Visible="false">
                        <Columns>
                            <dx:GridViewDataHyperLinkColumn FieldName="Name" Width="200px" Caption="File Name" VisibleIndex="1" ReadOnly="true">
                                <DataItemTemplate>
                                    <a href='<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>' target="_blank"><%# Eval("Name")%></a>
                                </DataItemTemplate>
                                <EditItemTemplate>
                                    <a href='<%# String.Format("/DownloadFile.aspx?id={0}", Eval("FileID"))%>' target="_blank"><%# Eval("Name")%></a>
                                </EditItemTemplate>
                            </dx:GridViewDataHyperLinkColumn>
                            <dx:GridViewDataTextColumn FieldName="Createby" Width="60px" VisibleIndex="2" ReadOnly="true">
                                <EditItemTemplate>
                                    <%# Eval("Createby")%>
                                </EditItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="CreateDate" Width="120px" PropertiesTextEdit-DisplayFormatString="g" VisibleIndex="3" ReadOnly="true">
                                <PropertiesTextEdit DisplayFormatString="g"></PropertiesTextEdit>
                                <EditItemTemplate>
                                    <%# Eval("CreateDate", "{0:g}")%>
                                </EditItemTemplate>
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataColumn FieldName="Category" VisibleIndex="4" Width="120px">
                                <DataItemTemplate>
                                    <dx:ASPxComboBox runat="server" ID="cbCategory">
                                        <Items>
                                            <dx:ListEditItem Text="Financials" Value="Financials" />
                                            <dx:ListEditItem Text="Short Sale" Value="ShortSale" />
                                            <dx:ListEditItem Text="Photos" Value="Photos" />
                                            <dx:ListEditItem Text="Accounting" Value="Accounting" />
                                            <dx:ListEditItem Text="Eviction" Value="Eviction" />
                                            <dx:ListEditItem Text="Construction" Value="Construction" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="5" Visible="false">
                                <DataItemTemplate>
                                </DataItemTemplate>
                            </dx:GridViewDataTextColumn>

                        </Columns>
                        <SettingsDataSecurity AllowInsert="False" />
                        <SettingsEditing Mode="Inline"></SettingsEditing>

                    </dx:ASPxGridView>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
