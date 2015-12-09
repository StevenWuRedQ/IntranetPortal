<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UploadToOneDrive.aspx.vb" Inherits="IntranetPortal.UploadToOneDrive" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/OneDrive/constants.js"></script>
    <script src="//js.live.net/v5.0/wl.js"></script>
    <script type="text/javascript">
        WL.init({
            client_id: APP_CLIENT_ID,
            redirect_uri: REDIRECT_URL,
            scope: "wl.signin",
            response_type: "token"
        });

        function uploadFile() {

            WL.login({
                scope: "wl.skydrive_update"
            }).then(
                function (response) {
                    WL.upload({
                        path: LeadsFolderId,
                        element: "file",
                        overwrite: "rename"
                    }).then(
                        function (response) {
                            document.getElementById("info").innerText =
                                "File uploaded.";
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
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input id="file" name="file" type="file" />
        <select id="category">
            <option></option>
        </select>
        <button onclick="uploadFile()" type="button">Upload</button>
        <label id="info"></label>
    </form>
</body>
</html>
