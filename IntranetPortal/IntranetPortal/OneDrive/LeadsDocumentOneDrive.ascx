<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsDocumentOneDrive.ascx.vb" Inherits="IntranetPortal.LeadsDocumentOneDrive" %>

<script src="/OneDrive/constants.js"></script>
<script src="//js.live.net/v5.0/wl.js"></script>
<script src="/Scripts/stevenjs.js?v=1.02"></script>
<label id="info"></label>

<script type="text/javascript">
    var LeadsFolderId = "folder.d21d5166dd1004e8.D21D5166DD1004E8!173135"

    //WL.Event.subscribe("auth.login", onLogin);
    WL.init({
        client_id: APP_CLIENT_ID,
        redirect_uri: REDIRECT_URL,
        scope: "wl.signin",
        response_type: "token"
    });

    function ConnectToOneDrive() {
        var session = WL.getSession();
        if (session) {
            document.getElementById("btnConnect").innerHTML = "Connected";
            getFolderList(LeadsFolderId);
        } else {
            WL.login({ scope: "wl.signin" }).then(function (response) {
                document.getElementById("btnConnect").innerHTML = "Connected";
                getFolderList(LeadsFolderId);
            });
        }
    }

    function onLogin(session) {

        if (!session.error) {

            WL.api({
                path: "me",
                method: "GET"
            }).then(
                function (response) {
                    document.getElementById("btnConnect").innerHTML = "Connected";
                    getFolderList(LeadsFolderId);
                },
                function (responseFailed) {
                    document.getElementById("btnConnect").innerHTML = "Not Connected";
                    document.getElementById("info").innerText =
                        "Error calling API: " + responseFailed.error.message;
                }
            );
        }
        else {
            document.getElementById("info").innerText =
                "Error signing in: " + session.error_description;
        }
    }

    function ShowUploadControl() {
        popupCtrUploadFiles.Show();
    }

    function uploadFile() {
        var category = document.getElementById("fileCategory");
        var folderId = LeadsFolderId;

        if (category.value != null) {
            folderId = category.value;
        }

        WL.login({
            scope: "wl.skydrive_update"
        }).then(
            function (response) {
                WL.upload({
                    path: folderId,
                    element: "file",
                    overwrite: "rename"
                }).then(
                    function (response) {
                        alert("Upload Finish.");
                        popupCtrUploadFiles.Hide();
                        getFolderList(LeadsFolderId);
                    },
                    function (responseFailed) {
                        document.getElementById("info").innerText =
                            "Error uploading file: " + responseFailed.error.message;
                    }
                );
            },
            function (responseFailed) {
                document.getElementById("info").innerText =
                    "Error signing in: " + responseFailed.error.message;
            }
        );
    }

    function InitDocument() {

    }

    function getFolderList(folderId) {

        //document.getElementById("txtLeadsFolder").value = folderId;
        WL.api({ path: folderId + "/files", method: "GET" }).then(
            function (response) {
                //log(JSON.stringify(response).replace(/,/g, ",\n"));

                LoadResult(response);
            },
            function (response) {
                log("Could not access folders, status = " +
                    JSON.stringify(response.error).replace(/,/g, ",\n"));
            }
        );
    }

    function LoadResult(result) {
        var files = result.data

        var table = document.getElementById("tblResult");
        var category = document.getElementById("fileCategory");
        var rowCount = table.rows.length;

        for (var x = rowCount - 1; x > 0; x--) {
            table.deleteRow(x);
        }

        var divContent = document.getElementById("divFileContent");
        divContent.innerHTML = "";

        for (var i = 0; i < files.length; i++) {
            var file = files[i];

            if (file.type == "folder") {

                var cate = new Option(file.name, file.id);
                category.options.add(cate);

                BuildFolder(file);

            }
            else {

                // Create an empty <tr> element and add it to the 1st position of the table:
                var row = table.insertRow();

                // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
                var cell0 = row.insertCell(0);
                cell0.innerHTML = "<a href=\"#\" onclick=\"getFolderList('" + file.id + "')\">" + file.id + "</a>";

                var cell1 = row.insertCell(1);
                cell1.innerHTML = file.type;

                var cell2 = row.insertCell(2);
                cell2.innerHTML = "<a href='" + file.link + "' target='_blank'>" + file.name + "</a>";

                var cell3 = row.insertCell(3);
                cell3.innerHTML = file.size;

                //var cell4 = row.insertCell(4);
                //cell4.innerHTML = 
            }
        }
    }

    function BuildFolder(foler) {
        WL.api({ path: foler.id + "/files", method: "GET" }).then(
            function (response) {
                var docId = "divfolder_" + foler.id;
                docId = docId.replace(/\./g, "_").replace("!", "_");
                var html = "<div class=\"doc_list_section\"><div id=\"default-example\">";
                html += "<h3 class=\"doc_list_title  color_balck\">" + foler.name + " &nbsp;&nbsp;<i class=\"fa fa-minus-square-o color_blue\" onclick=\"clickCollapse(this, '" + docId + "')\"></i></h3>";
                html += "<div id=\"" + docId + "\">"

                var files = response.data;
                for (var i = 0; i < files.length; i++) {
                    var file = files[i];
                    if (file.type == "file") {
                        html += BuildFile(file);
                    }
                }

                html += "</div>";
                html += "</div>";
                var divContent = document.getElementById("divFileContent");
                divContent.innerHTML += html;
            },
            function (response) {
                log("Could not access folders, status = " +
                    JSON.stringify(response.error).replace(/,/g, ",\n"));
            }
        );
    }

    function BuildFile(file) {
        /*use JSON.stringify() debug objects*/
        var dataStr = new Date(file.updated_time).toDateString();
        var html = "<div class=\"clearfix\">"
        html += "<input type=\"checkbox\" name=\"vehicle\" id=\"doc_list_id_" + file.id + "\" />";
        html += "   <label class=\"doc_list_checks check_margin\" for=\"doc_list_id_" + file.id + "\">";
        html += "       <span class=\"color_balck\">"
        html += "           <a href='#' onclick=\"clickFileLink('" + file.link + "','" + file.source + "',this)\">" + file.name + "</a>";
        html += "               <span class='checks_data_text'> " + "Date:" + dataStr + "&nbsp;" + "Size:" + file.size / 1000 + "Mb </span>"

        //html += "           <a href='"+ file.link +"' target=\"_blank\">" + file.name + "</a>";
        html += "       </span>"
        html += "   </label>"
        html += "</div>"

        return html;
    }
    var currentFile = null;
    var currentSource = null;
    function ShowInfo(msg) {
        document.getElementById("info").innerText = msg;
    }
    function clickFileLink(file,source,e) {
        currentFile = file;
        currentSource = source;
        AspFilePopupMenu.ShowAtElement(e);
    }
    function OnFilePopUpClick(s,e)
    {
       
        
        if (e.item.index == 0)
        {
            if(currentFile!=null)
            {
                PreviewDocument(currentFile)
            }
        } else if (e.item.index == 1)
        {
            /*download*/
            if(currentSource!=null)
            {
                //$('a').preventDefault();
                window.location.href = currentSource;
            }
        }
        else {
            alert("no view history function yet!");
        }
    }
    function PreviewDocument(link) {
        var logPanel = contentSplitter.GetPaneByName("LogPanel");
        var panel = logPanel.GetElement();
        var position = getOffset(panel);

        var width = logPanel.GetClientWidth();
        var height = logPanel.GetClientHeight();

        var pamas = "Width=" + width + "px,Height=" + height + "px,top=" + position.top + "px,left=" + position.left + "px,menubar=no;titlebar=no,location=no";

        window.open(link, "Preview", pamas, true);
    }

    function getOffset(el) {
        var _x = 0;
        var _y = 0;
        while (el && !isNaN(el.offsetLeft) && !isNaN(el.offsetTop)) {
            _x += el.offsetLeft - el.scrollLeft;
            _y += el.offsetTop - el.scrollTop;
            el = el.offsetParent;
        }
        return { top: _y, left: _x };
    }
   

</script>
<dx:ASPxPopupMenu ID="ASPxPopupMenu11" runat="server" ClientInstanceName="AspFilePopupMenu"
    PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
    PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
    ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <ItemStyle Paddings-PaddingLeft="20px" />
    <Items>
        <dx:MenuItem Text="Preview" Name="Preview">
        </dx:MenuItem>
        <dx:MenuItem Text="Download" Name="Download">
        </dx:MenuItem>
       <%-- <dx:MenuItem Text="Preview History" Name="History">
        </dx:MenuItem>--%>
    </Items>

    <ClientSideEvents ItemClick="function(s,e){OnFilePopUpClick(s,e);}" />
</dx:ASPxPopupMenu>

<div style="color: #999ca1;">
    <div style="padding: 35px 20px 35px 20px;" class="border_under_line">
        <div style="width: 100%">
            <div class="font_30">
                <i class="fa fa-file"></i>&nbsp;
                                            <span class="font_light">Documents</span>

            </div>
            <div style="padding-left: 39px;" class="clearfix">
                <span style="font-size: 14px;"><%= LeadsName %></span>

                <span class="time_buttons" style="float: none" onclick="ConnectToOneDrive()" id="btnConnect">Not Connected</span>
                <span class="time_buttons" style="float: none" onclick="ShowUploadControl()">Upload </span>
                <%-- <button onclick="ConnectToOneDrive()" id="btnConnect" type="button">Not Connected</button>
                <button onclick="ShowUploadControl()" type="button">Upload</button>--%>
                <span class="color_blue expand_button" style="padding-right: 25px">Collapse All</span>
                <span class="color_blue expand_button">Expand All&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            </div>
        </div>
    </div>
    <table id="tblResult" hidden="hidden">
        <thead>
            <tr>
                <td>Id
                </td>
                <td>Type
                </td>
                <td>Name
                </td>
                <td>Size
                </td>
            </tr>
        </thead>
        <tbody>
            <tr></tr>
        </tbody>
    </table>
    <div id="divFileContent">
    </div>
</div>
<dx:ASPxPopupControl ClientInstanceName="popupCtrUploadFiles" Width="480px" Height="210px" ID="ASPxPopupControl2"
    HeaderText="Upload Files" AutoUpdatePosition="true" Modal="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            <table>
                <tr style="height: 30px">
                    <td style="width: 90px">Select File:
                    </td>
                    <td>
                        <input id="file" name="file" type="file" /></td>
                </tr>
                <tr style="height: 30px">
                    <td>Category:</td>
                    <td>
                        <select id="fileCategory">
                            <option></option>
                        </select></td>
                </tr>
                <tr style="height: 30px">
                    <td></td>
                    <td>
                        <button onclick="uploadFile()" type="button">Upload</button></td>
                </tr>
            </table>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="popupPreview" ID="ASPxPopupControl1"
    AutoUpdatePosition="true" Modal="false" ShowHeader="false"
    runat="server" PopupHorizontalAlign="RightSides" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
