<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AchiveLeadsLog.aspx.vb" Inherits="IntranetPortal.AchiveLeadsLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        BBLEs: <asp:TextBox ID="txtBBLEs" runat="server"></asp:TextBox> (Split with , string)
        <dx:ASPxButton runat="server" ID="btArchive" Text="Archive" Theme="Moderno" OnClick="btArchive_Click"></dx:ASPxButton>
        <br />
        <label runat="server" id="Status"> Status </label>
    </div>
        
    </form>
</body>
</html>
