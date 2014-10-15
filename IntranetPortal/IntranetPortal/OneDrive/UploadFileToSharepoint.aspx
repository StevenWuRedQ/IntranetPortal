<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UploadFileToSharepoint.aspx.vb" Inherits="IntranetPortal.UploadFileToSharepoint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
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
        </div>
    </form>
</body>
</html>
