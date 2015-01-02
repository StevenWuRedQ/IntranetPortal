<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UploadFilePage.aspx.vb" Inherits="IntranetPortal.UploadFilePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upload Files</title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel='stylesheet' type='text/css' />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />  
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link href="/css/stevencss.css?v=1.0" rel="stylesheet" type="text/css" />
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        // <![CDATA[                     
        function OnAddFileButtonClick() {
            var hasFile = false;
            $("input:file").each(function () {
                var myFile = this;
                if ('files' in myFile) {
                    if (myFile.files.length == 0) {
                        //alert("please select file");
                    } else {
                        AddFilesToForm(myFile.files);
                        hasFile = true;
                    }
                }
            });

            if (!hasFile)
                alert("Please choose files.");
        }

        function OnDropBody(event) {
            alert("Please drop the files into the drag area.");
            return false;
        }

        function UploadFiles() {
            //refresh formdata
            if (formFiles != null) {
                formData = tests.formdata ? new FormData() : null;

                for (var key in formFiles) {
                    formData.append('file', formFiles[key]);
                }
            }

            if (!!tests.formdata && formData != null) {
                var xhr = new XMLHttpRequest();
                var url = form1.action + "&cate=1";

                var categories = GetSelectedCategory();
                if (categories != null) {
                    formData.append("Category", categories);
                }

                var names = GetFileNames();
                if (name != null) {
                    formData.append("FileNames", names);
                }

                xhr.open('POST', url)
                xhr.onload = function () {
                    debugger;
                    if (xhr.readyState==4 && xhr.status == 200)
                    {
                        progress.value = progress.innerHTML = 100;
                        alert("Upload Completed!");
                        formData = null;
                        ClearFilesTable();
                        LoadingPanel.Hide();
                    }
                    else
                    {
                        LoadingPanel.Hide();
                        alert("Error in upload file. Please try later.");
                    }
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
                LoadingPanel.Show();
            }
            else {
                alert("You didn't select files.");
            }
        }

        var formData = null;
        var formFiles = {};
        function OnDropTextarea(event) {
            if (event.dataTransfer) {
                if (event.dataTransfer.files) {
                    var files = event.dataTransfer.files;
                    AddFilesToForm(files);
                }
                else {
                    alert("Your browser does not support the files property.");
                }
            }
            else {
                alert("Your browser does not support the dataTransfer property.");
            }
        }

        function RemoveFileFromForm(fileName) {
            if (formFiles != null) {
                for (var key in formFiles) {
                    if (key == fileName) {
                        delete formFiles[key];
                    }
                }

                RefreshFileTable();
            }
        }

        function RefreshFileTable() {
            ClearFilesTable();
            for (var key in formFiles) {
                AppendFileToTable(formFiles[key]);
            }
        }

        function AddFilesToForm(files) {
            if (formData == null) {
                formData = tests.formdata ? new FormData() : null;

                fileTable.style.display = "";
                btnUpload.SetEnabled(true);
                btnUpload.Click.ClearHandlers();
                btnUpload.Click.AddHandler(function (s, e) {
                    e.processOnServer = false;
                    //if (cbCategory.GetIsValid())
                    UploadFiles();
                });
            }

            for (var i = 0; i < files.length; i++) {                             
                var file = files[i];
                if ('name' in file) {
                    var fileName = file.name;
                }
                else {
                    var fileName = file.fileName;
                }
                if (formFiles[fileName] != null)
                {
                    formFiles[fileName] = file;
                }
                else
                {
                    formFiles[fileName] = file;
                    AppendFileToTable(files[i]);
                }              
            }
        }

        function AppendFileToTable(file) {
            var tableRef = fileTable.getElementsByTagName('tbody')[0];
            var index = tableRef.rows.length;
            var row = tableRef.insertRow(index);

            var cell0 = row.insertCell(0);
            cell0.innerHTML = "" + (index + 1);

            var cell1 = row.insertCell(1);

            if ('name' in file) {
                var fileName = file.name;
            }
            else {
                var fileName = file.fileName;
            }

            //cell1.innerHTML = fileName;
            cell1.appendChild(GetFilenameElement(fileName));

            cell1 = row.insertCell(2);
            cell1.appendChild(GetCategoryElement(fileName));

            cell1 = row.insertCell(3);
            if ('size' in file) {
                var fileSize = file.size;
            }
            else {
                var fileSize = file.fileSize;
            }
            cell1.innerHTML = Math.round(fileSize / 1000);

            cell1 = row.insertCell(4);
            cell1.innerHTML = "<i class='fa fa-times color_blue icon_btn' style='font-size:18px;' onclick='RemoveFileFromForm(\"" + fileName + "\")'>";
        }

        function ClearFilesTable() {
            var rowCount = fileTable.rows.length;
            for (var x = rowCount - 1; x > 0; x--) {
                fileTable.deleteRow(x);
            }
        }

        function GetFilenameElement(fileName) {
            var isValid = (function () {
                var rg1 = /^[^\\/:\*\?"<>\|]+$/; // forbidden characters \ / : * ? " < > |
                var rg2 = /^\./; // cannot start with dot (.)
                //var rg2 = /[^\\/]+\.[^\\/]+$/;
                var rg3 = /^(nul|prn|con|lpt[0-9]|com[0-9])(\.|$)/i; // forbidden file names
                return function isValid(fname) {
                    return rg1.test(fname) && !rg2.test(fname) && !rg3.test(fname);
                }
            })();

            var x = document.createElement("INPUT");
            x.setAttribute("type", "text");
            x.setAttribute("style", "width:90%;border-color:transparent;background-color:transparent;border-style:solid;")
            x.setAttribute("class", "")
            x.setAttribute("value", fileName);
            x.setAttribute("data-filename", fileName);
            x.addEventListener("change", function () {
                if (isValid(x.value)) {
                    var newName = x.value;
                    var ext = GetFileExtention(fileName);
                    if(!endsWith(newName, ext))
                    {
                        if (endsWith(newName, "."))
                            x.value = newName + ext;
                        else
                            x.value = newName + "." + ext;
                    }
                }
                else {
                    alert("File name is invalid.")
                    x.focus();
                }
            });
            //x.addEventListener("blur", function () {
            //    if (!isValid(x.value)) {
            //        alert("File name is invalid.")
            //        x.focus();
            //    }
            //});

            return x;
        }

        function endsWith(str, suffix) {
            return str.indexOf(suffix, str.length - suffix.length) !== -1;
        }

        function GetFileExtention(filename) {
            var a = filename.split(".");
            if (a.length === 1 || (a[0] === "" && a.length === 2)) {
                return "";
            }
            return a.pop();
        }

        function ShowBorder(s) {
            return;
            var tbl = s;
            if (tbl.style.borderColor == 'transparent') {
                tbl.style.borderColor = "#9da0aa";
                tbl.style.backgroundColor = 'white';
            }
            else {
                tbl.style.borderColor = 'transparent';
                tbl.style.backgroundColor = 'transparent';
            }
        }

        function GetCategoryElement(fileName) {
            var cates = ["Financials", ["Short Sale","Approval","Eviction Document","Financials-1st Seller","Finacial-2nd Seller","Offer","Package","Title Report"], "Photos", "Accounting", "Eviction", "Construction", "Others"];
            var x = document.createElement("SELECT");
            x.setAttribute("data-filename", fileName);
            var select_html = ""
            for (var i = 0; i < cates.length; i++) {
                /*test add sub category by steven using HasSub for test  */
                var e_option = cates[i];
               
                if (e_option.constructor == Array)
                {
                    var opt_grop = document.createElement("optgroup");
                   

                    opt_grop.setAttribute("label", e_option[0]);
                    for (var j = 1; j < e_option.length; j++)
                    {
                        var option = document.createElement("option");
                        option.text = e_option[j];
                        option.value = e_option[0] + "/" + e_option[j];
                        $(opt_grop).last().append($(option));
                    }
                    var html = $(opt_grop).html();
                    //debugger;
                    //$(x).last().append('<optgroup label="' + e_option[0] + '">' + $(opt_grop).html() + '</optgroup>');
                    select_html += $(opt_grop).prop('outerHTML');
                    //x.add(opt_grop)
                } else
                {
                    var option = document.createElement("option");

                    option.text = cates[i];
                    option.value = cates[i];
                    x.add(option);
                    select_html += $(option).prop('outerHTML');
                }                
            }
            debugger;
            $(x).html(select_html);

            return x;
        }

        function GetSelectedCategory() {
            var allCategories = [];
            $('#tblFiles select').each(function () {
                var cate = $(this).attr("data-filename") + "=" + $(this).val();
                allCategories.push(cate);
            });

            return allCategories.toString();
        }

        function GetFileNames() {
            var allNames = {};
            $('#tblFiles input').each(function () {
                allNames[$(this).attr("data-filename")] = $(this).val();
            });

            return JSON.stringify(allNames);
        }

    </script>
    <style>
        #trFileHolder {
            border: 2px dashed #ccc !important;
            margin: 20px auto;
        }

            #trFileHolder.hover {
                background-color: #efefef;
                border: 2px dashed #0c0;
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
<body style="padding: 20px;">
    <form id="form1" runat="server">
        <table style="width: 100%; text-align: left;">
            <tr>

                <td class="note">
                    <div style="height: 200px; overflow: auto">
                        <table <%--style="width: 90%; display: none; line-height: 25px" --%>id="tblFiles" class="table table-striped" style="font-size: 14px;">
                            <thead>
                                <tr style="text-transform: uppercase; color: #b1b2b7">
                                    <td style="width: 25px">#</td>
                                    <td>Name (click to change)</td>
                                    <td style="width: 200px">File Category</td>
                                    <td style="width: 80px">Size(KB)</td>
                                    <td style="width: 60px">Delete</td>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div style="padding-bottom: 15px">
                        <dx:ASPxLabel ID="lblSelectImage" runat="server" Text="Select file to upload:" Font-Size="18px" ForeColor="#C4C3C9">
                        </dx:ASPxLabel>
                    </div>
                    <table>
                        <tr>
                            <td>
                                <dx:ASPxUploadControl ID="uplImage" AdvancedModeSettings-EnableMultiSelect="true" runat="server" ClientInstanceName="uploader" CssClass="email_input input_files" NullText="Click here to browse files..." Size="35" Width="10%">
                                    <ValidationSettings MaxFileSize="6194304">
                                    </ValidationSettings>
                                    <ClientSideEvents TextChanged="function(s,e){if(s.GetText()!=''){OnAddFileButtonClick();}}" />
                                </dx:ASPxUploadControl>
                            </td>
                            <td>
                                <a class="dxucButton_MetropolisBlue1" style="font-size: 16px; padding-left: 20px; color: #3993c1" href="javascript:" onclick="OnAddFileButtonClick()">Add</a>
                            </td>
                        </tr>
                    </table> 
                    <dx:ASPxHiddenField runat="server" ID="hfBBLE" ClientInstanceName="hfBBLEClient"></dx:ASPxHiddenField>
                    <asp:HiddenField runat="server" ID="hfBBLEData" />
                </td>
            </tr>
            <tr>
                <td>
                    <span class="color_gray" style="line-height: 50px;">Or... Simply drag your documents from your computer on to this drop zone:
                    </span>
                </td>
            </tr>
            <tr id="trFileHolder" style="height: 230px; width: 100%; margin-top: 20px;">
                <td colspan="2" style="text-align: center;" class="dxeBase_MetropolisBlue1"><i class="fa fa-upload" style="font-size: 90px; color: #dddddd"></i>
                </td>
            </tr>
            <tr id="trProgress" style="display: none">
                <td colspan="2" class="dxeBase_MetropolisBlue1">
                    <p>Upload progress: <progress id="uploadprogress" min="0" max="100" value="0">0</progress></p>
                </td>
            </tr>
            <tr>
                <td style="font-size: 10px">
                    <div style="padding-top: 20px; color: #A7A7A9">
                        <dx:ASPxLabel ID="lblAllowebMimeType" runat="server" Text="Allowed  file types: JPEG, GIF, DOC, PDF, XLSX">
                        </dx:ASPxLabel>
                        <br />
                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Maximum file size: 6Mb">
                        </dx:ASPxLabel>
                    </div>

                </td>
            </tr>
            <tr style="height: 40px;">
                <td></td>
                <td class="buttonCell" style="margin-bottom: 5px;">
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Category:" Visible="false">
                    </dx:ASPxLabel>
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <dx:ASPxComboBox runat="server" ID="cbCategory" ClientInstanceName="cbCategory" DropDownStyle="DropDown" ClientVisible="false" NullText="Input New Category">
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

                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">
                    <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Upload" Visible="false" ClientEnabled="False" CssClass="rand-button rand-button-blue" Style="margin: 0 auto; background: #3993c1" ForeColor="White">
                        <ClientSideEvents Click="function(s, e) { uploader.Upload(); }" />
                    </dx:ASPxButton>
                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Upload" Style="margin: 0 auto; background: #3993c1" ClientInstanceName="btnUpload" ForeColor="White" CssClass="rand-button" ClientEnabled="False" OnClick="ASPxButton1_Click">
                    </dx:ASPxButton>
                </td>
            </tr>


        </table>
        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Text="Uploading..."
            Modal="True">
        </dx:ASPxLoadingPanel>
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

            //debugger;
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
