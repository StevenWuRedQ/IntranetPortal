<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TaskList.aspx.vb" Inherits="IntranetPortal.TaskList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3>Task List</h3>
        <dx:ASPxGridView runat="server" ID="gridTask"></dx:ASPxGridView>
    </div>
    </form>
</body>
</html>
