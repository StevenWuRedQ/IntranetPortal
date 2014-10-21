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

    <script type="text/javascript">
       
        function OnDropBody(event) {
            alert("Please drop the files into the drag area.");
            return false;
        }

        function UploadFiles()
        {
            if (!!tests.formdata && formData != null) {
                var xhr = new XMLHttpRequest();
                var url = form1.action + "&cate=" + cbCategory.GetText();
                xhr.open('POST', url)
                xhr.onload = function () {
                    progress.value = progress.innerHTML = 100;
                    alert("Upload Completed!");
                    formData = null;
                };

                if (tests.progress) {
                    xhr.upload.onprogress = function (event) {                        
                        if (event.lengthComputable) {
                            var complete = (event.loaded / event.total * 100 | 0);
                            progress.value = progress.innerHTML = complete;                            
                        }
                    }
                }

                xhr.send(formData);
            }
            else {
                alert("You didn't select files.");
            }
        }

        var formData = null;
        function OnDropTextarea(event) {
            if (event.dataTransfer) {
                if (event.dataTransfer.files) {               
                    var files = event.dataTransfer.files;

                    if (formData == null) {
                        formData = tests.formdata ? new FormData() : null;

                        fileTable.style.display = "";
                        btnUpload.SetEnabled(true);
                        btnUpload.Click.ClearHandlers();
                        btnUpload.Click.AddHandler(function (s, e) {
                            e.processOnServer = false;
                            if (cbCategory.GetIsValid())
                                UploadFiles();
                        });
                    }
                 
                    for (var i = 0; i < files.length; i++) {
                        AppendFileToTable(files[i]);

                        if (tests.formdata)
                            formData.append('file', files[i]);
                        //previewfile(files[i]);
                    }                    
                }
                else {
                    alert("Your browser does not support the files property.");
                }
            }
            else {
                alert("Your browser does not support the dataTransfer property.");
            }                      
        }

        function AppendFileToTable(file) {
            var index = fileTable.rows.length;
            var row = fileTable.insertRow();

            var cell0 = row.insertCell(0);
            cell0.innerHTML = "" + index;

            var cell1 = row.insertCell(1);

            if ('name' in file) {
                var fileName = file.name;
            }
            else {
                var fileName = file.fileName;
            }

            cell1.innerHTML = fileName;

            cell1 = row.insertCell(2);
            if ('size' in file) {
                var fileSize = file.size;
            }
            else {
                var fileSize = file.fileSize;
            }
            cell1.innerHTML = fileSize;
        }

    </script>
    <style>
        #trFileHolder {            
            border: 5px dashed #ccc;                      
            margin: 20px auto;
        }

            #trFileHolder.hover {
                background-color:#efefef;
                border: 5px dashed #0c0;
            }

        progress {
            width: 100%;
        }

            progress:after {
                content: '%';
            }

        .fail {
            background: #c00;
            padding: 2px;
            color: #fff;
        }

        .hidden {
            display: none !important;
        }
    </style>
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
                    <dx:ASPxLabel ID="lblAllowebMimeType" runat="server" Text="Allowed types: jpeg, gif, doc, pdf;Maximum file size: 4Mb"
                        Font-Size="8pt">
                    </dx:ASPxLabel>
                    <table style="width:70%;display:none" id="tblFiles" class="dxeBase_MetropolisBlue1">
                        <thead>
                            <tr>
                                <td style="width:25px">#</td>
                                <td>Name</td>
                                <td style="width:80px">Size(KB)</td>
                            </tr>
                        </thead>
                    </table>
                </td>
            </tr>
            <tr style="height: 40px;">
                <td>
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Category:">
                    </dx:ASPxLabel>
                </td>
                <td class="buttonCell" style="margin-bottom: 5px;">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <dx:ASPxComboBox runat="server" ID="cbCategory" ClientInstanceName="cbCategory" DropDownStyle="DropDown" NullText="Input New Category">
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
                            <td style="text-align: right">
                                <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Upload" Visible="false" Width="100px" ClientEnabled="False" Style="margin: 0 auto;">
                                    <ClientSideEvents Click="function(s, e) { uploader.Upload(); }" />
                                </dx:ASPxButton>
                                <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Upload" Width="100px" Style="margin: 0 auto;" ClientInstanceName="btnUpload" ClientEnabled="False" OnClick="ASPxButton1_Click">
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr id="trFileHolder" style="height:100px">
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
            <tr id="trProgress">
                <td colspan="2" class="dxeBase_MetropolisBlue1">                 
                    <p>Upload progress: <progress id="uploadprogress" min="0" max="100" value="0">0</progress></p>
                    <p>Drag a document from your desktop on to the drop zone above to upload.</p>
                </td>
            </tr>
        </table>
        <script>

           var holder = document.getElementById('trFileHolder'),
               tests = {
                   filereader: typeof FileReader != 'undefined',
                   dnd: 'draggable' in document.createElement('span'),
                   formdata: !!window.FormData,
                   progress: "upload" in new XMLHttpRequest
               },
               support = {
                   filereader: document.getElementById('filereader'),
                   formdata: document.getElementById('formdata'),
                   progress: document.getElementById('progress')
               },
               acceptedTypes = {
                   'image/png': true,
                   'image/jpeg': true,
                   'image/gif': true
               },
               fileTable = document.getElementById("tblFiles"),
               progress = document.getElementById('uploadprogress');

           debugger;
            if (tests.dnd) {               
                holder.ondragover = function () { this.className = 'hover'; return false; };
                holder.ondragend = function () { this.className = ''; return false; };
                holder.ondrop = function (e) {
                    this.className = '';
                    e.preventDefault();
                    OnDropTextarea(e);                   
                };
            } else {
                holder.style.display = "none";
                trProgress.style.display = "none";
            }
        </script>
    </form>
</body>
</html>
