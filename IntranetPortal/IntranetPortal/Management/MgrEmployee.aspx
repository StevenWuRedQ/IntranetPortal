<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MgrEmployee.aspx.vb" Inherits="IntranetPortal.MgrEmployee" %>

<%@ Register Src="~/UserControl/CompanyTree.ascx" TagPrefix="uc1" TagName="CompanyTree" %>
<%@ Register Src="~/UserControl/AssignRulesControl.ascx" TagPrefix="uc1" TagName="AssignRulesControl" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        var aspxImage = null;
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" FullscreenMode="true" Height="100%" Width="100%">
            <Panes>
                <dx:SplitterPane ScrollBars="Auto" Size="990px">
                    <PaneStyle Border-BorderStyle="None">
                        <Border BorderStyle="None"></Border>
                    </PaneStyle>
                    <Separator SeparatorStyle-Border-BorderStyle="None" SeparatorStyle-BackColor="White">
                        <SeparatorStyle BackColor="White">
                            <Border BorderStyle="None"></Border>
                        </SeparatorStyle>
                    </Separator>
                    <ContentCollection>
                        <dx:SplitterContentControl runat="server">

                            <dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" Width="100%" HeaderText="Employee Tree" Height="100%" >
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <div>
                                            <asp:TextBox ID="SearchName" runat="server"></asp:TextBox>
                                            <asp:Button ID="SearchnameBtn" runat="server" Text="Search" OnClick="SearchnameBtn_Click"/>
                                        </div>
                                        <div>                                            
                                            <dx:ASPxCheckBox runat="server" ID="chkActive" Text="Only Active User:" TextAlign="Left" Checked="true" AutoPostBack="true"></dx:ASPxCheckBox>
                                        </div>
                                        <dx:ASPxTreeList ID="treeList" runat="server" SettingsEditing-Mode="EditForm" Width="100%" Height="100%" ParentFieldName="ReportTo" KeyFieldName="EmployeeID">
                                            <Columns>
                                                <dx:TreeListTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="0">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                            <RequiredField IsRequired="True"></RequiredField>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Position" ShowInCustomizationForm="True" VisibleIndex="1">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Department" ShowInCustomizationForm="True" VisibleIndex="2">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Password" VisibleIndex="3" Visible="false" EditFormSettings-Visible="True">
                                                    <PropertiesTextEdit Password="True" ClientInstanceName="psweditor">
                                                    </PropertiesTextEdit>
                                                    <EditFormSettings Visible="True"></EditFormSettings>
                                                    <EditCellTemplate>
                                                        <dx:ASPxTextBox ID="pswtextbox" runat="server" Text='<%#Bind("Password")%>' Theme="Moderno"
                                                            Visible='<%#treeList.IsNewNodeEditing%>' Password="True">
                                                            <ValidationSettings ErrorDisplayMode="ImageWithTooltip"></ValidationSettings>
                                                            <ClientSideEvents Validation="function(s,e){e.isValid = s.GetText()>5;}" />
                                                        </dx:ASPxTextBox>
                                                        <asp:LinkButton ID="LinkButton1" runat="server" OnClientClick="popup.ShowAtElement(); return false;" Visible='<%#Not treeList.IsNewNodeEditing%>'>Edit password</asp:LinkButton>
                                                    </EditCellTemplate>
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Extension" ShowInCustomizationForm="True" VisibleIndex="3">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Cellphone" ShowInCustomizationForm="True" VisibleIndex="4">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListDateTimeColumn FieldName="EmployeeSince" ShowInCustomizationForm="true" VisibleIndex="5"></dx:TreeListDateTimeColumn>
                                                <dx:TreeListTextColumn FieldName="Email" ShowInCustomizationForm="True" VisibleIndex="6" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings ErrorDisplayMode="ImageWithTooltip">
                                                            <RequiredField IsRequired="True"></RequiredField>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListComboBoxColumn FieldName="ReportTo" PropertiesComboBox-ValueField="EmployeeID" PropertiesComboBox-TextField="Name" VisibleIndex="7">
                                                    <PropertiesComboBox TextField="Name" ValueField="EmployeeID" ValueType="System.Int32">
                                                    </PropertiesComboBox>
                                                </dx:TreeListComboBoxColumn>
                                                <dx:TreeListTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="9">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListImageColumn FieldName="Picture" VisibleIndex="10" Visible="false" EditFormSettings-Visible="True">
                                                <EditFormSettings Visible="True"></EditFormSettings>
                                                    <EditCellTemplate>
                                                        <dx:ASPxImage ID="imgEmpPhoto" runat="server" ImageUrl='<%# "/DownloadFile.aspx?id=" & Eval("Picture")%>' Width="50px" Height="50px" Cursor="pointer">
                                                            <EmptyImage Url="/images/User-Empty-icon.png" ></EmptyImage>
                                                            <ClientSideEvents Click="function(s,e){aspxImage = s; selectImgs.ShowAtElement(s.GetMainElement()); getPreviewImageElement().src='/images/user-empty-icon.png';}" />
                                                        </dx:ASPxImage>
                                                        <dx:ASPxTextBox ID="txtImageUrl" ClientInstanceName="txtImageUrl" runat="server" Text='<%#Bind("Picture")%>' ClientVisible="false"></dx:ASPxTextBox>
                                                    </EditCellTemplate>
                                                </dx:TreeListImageColumn>
                                                <dx:TreeListCheckColumn FieldName="Active" ShowInCustomizationForm="True" VisibleIndex="11">
                                                </dx:TreeListCheckColumn>
                                                <dx:TreeListCommandColumn ShowInCustomizationForm="True" VisibleIndex="12" ShowNewButtonInHeader="true">
                                                    <EditButton Visible="True">
                                                    </EditButton>
                                                    <NewButton Visible="True">
                                                    </NewButton>
                                                </dx:TreeListCommandColumn>
                                            </Columns>
                                            <SettingsBehavior ExpandCollapseAction="NodeDblClick" />
                                            <SettingsEditing Mode="EditForm"></SettingsEditing>
                                        </dx:ASPxTreeList>

                                        <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" HeaderText="Edit password" Width="307px" ClientInstanceName="popup">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol1" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td>Enter new password:</td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="npsw" runat="server" Password="True" ClientInstanceName="npsw">
                                                                    <ClientSideEvents Validation="function(s, e) {e.isValid = (s.GetText().length>5)}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorText="The password lengt should be more that 6 symbols">
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Confirm new password:</td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="cnpsw" runat="server" Password="True" ClientInstanceName="cnpsw">
                                                                    <ClientSideEvents Validation="function(s, e) {e.isValid = (s.GetText() == npsw.GetText());}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorText="The password is incorrect">
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <dx:ASPxButton ID="confirmButton" runat="server" Text="Ok" AutoPostBack="False">
                                                    </dx:ASPxButton>
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>

                                        <dx:ASPxPopupControl ID="ASPxPopupControl2" runat="server" HeaderText="Select Photo" ClientInstanceName="selectImgs" Modal="true" Width="500px">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol2" runat="server">
                                                    <style type="text/css">
                                                        #mainContainer td.buttonCell {
                                                            padding-top: 15px;
                                                        }

                                                        #mainContainer td.caption {
                                                            padding-right: 5px;
                                                            padding-top: 4px;
                                                            vertical-align: top;
                                                        }

                                                        #mainContainer td.content {
                                                            padding-bottom: 20px;
                                                        }

                                                        #mainContainer td.imagePreviewCell {
                                                            border: solid 2px gray;
                                                            width: 110px;
                                                            height: 115px;
                                                            /*if IE*/
                                                            height: expression("110px");
                                                            text-align: center;
                                                        }

                                                        #mainContainer td.note {
                                                            text-align: left;
                                                            padding-top: 1px;
                                                        }
                                                    </style>
                                                    <script type="text/javascript">
                                                        // <![CDATA[
                                                        function Uploader_OnUploadStart() {
                                                            btnUpload.SetEnabled(false);
                                                        }
                                                        function Uploader_OnFileUploadComplete(args) {
                                                            var imgSrc = aspxPreviewImgSrc;
                                                            if (args.isValid) {
                                                                //var date = new Date();
                                                                imgSrc = "/DownloadFile.aspx?id=" + args.callbackData;
                                                                fileId = args.callbackData;
                                                                aspxPreviewImgSrc = imgSrc;                                                               
                                                                getPreviewImageElement().src = imgSrc;
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
                                                        // ]]> 
                                                    </script>
                                                    <table id="mainContainer" style="width: 100%">
                                                        <tr>
                                                            <td class="content">
                                                                <table>
                                                                    <tr>
                                                                        <td style="padding-right: 20px; vertical-align: top;">
                                                                            <table>
                                                                                <tr>
                                                                                    <td class="caption">
                                                                                        <dx:ASPxLabel ID="lblSelectImage" runat="server" Text="Select Image:">
                                                                                        </dx:ASPxLabel>
                                                                                    </td>
                                                                                    <td>
                                                                                        <dx:ASPxUploadControl ID="uplImage" runat="server" ClientInstanceName="uploader" ShowProgressPanel="True"
                                                                                            NullText="Click here to browse files..." Size="35" OnFileUploadComplete="uplImage_FileUploadComplete">
                                                                                            <ClientSideEvents FileUploadComplete="function(s, e) { Uploader_OnFileUploadComplete(e); }"
                                                                                                FilesUploadComplete="function(s, e) { Uploader_OnFilesUploadComplete(e); }"
                                                                                                FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"
                                                                                                TextChanged="function(s, e) { UpdateUploadButton(); }"></ClientSideEvents>
                                                                                            <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg,.jpe,.gif">
                                                                                            </ValidationSettings>
                                                                                        </dx:ASPxUploadControl>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td></td>
                                                                                    <td class="note">
                                                                                        <dx:ASPxLabel ID="lblAllowebMimeType" runat="server" Text="Allowed image types: jpeg, gif"
                                                                                            Font-Size="8pt">
                                                                                        </dx:ASPxLabel>
                                                                                        <br />
                                                                                        <dx:ASPxLabel ID="lblMaxFileSize" runat="server" Text="Maximum file size: 4Mb" Font-Size="8pt">
                                                                                        </dx:ASPxLabel>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="2" class="buttonCell">
                                                                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Upload" ClientInstanceName="btnUpload" CausesValidation="false"
                                                                                            Width="100px" ClientEnabled="False" Style="margin: 0 auto;">
                                                                                            <ClientSideEvents Click="function(s, e) { uploader.Upload(); }" />
                                                                                        </dx:ASPxButton>
                                                                                        &nbsp;
                                                                                        <dx:ASPxButton ID="btnConfirm" runat="server" AutoPostBack="False" Text="OK" CausesValidation="false"
                                                                                            Width="100px" Style="margin: 0 auto;">
                                                                                            <ClientSideEvents Click="function(s, e) { aspxImage.SetImageUrl(aspxPreviewImgSrc);txtImageUrl.SetText(fileId); selectImgs.Hide(); }" />
                                                                                        </dx:ASPxButton>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                        <td class="imagePreviewCell">
                                                                            <img id="previewImage" alt="" src="/images/user-empty-icon.png" width="110" height="105" /></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <script type="text/javascript">
                                                        // <![CDATA[
                                                        var aspxPreviewImgSrc = getPreviewImageElement().src;
                                                        var fileId = null;
                                                        // ]]> 
                                                    </script>

                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>                             
            </Panes>
        </dx:ASPxSplitter>
    </form>
</body>
</html>
