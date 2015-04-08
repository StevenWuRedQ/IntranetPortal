<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewHomeOwner.aspx.vb" Inherits="IntranetPortal.ViewHomeOwner" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxTextBox runat="server" ID="txtBBLE" Theme="Moderno"></dx:ASPxTextBox>
            <dx:ASPxButton runat="server" ID="btnLoad" Text="Load" OnClick="btnLoad_Click" Theme="Moderno"></dx:ASPxButton>
            <dx:ASPxComboBox runat="server" ID="cbOwners" Theme="Moderno"></dx:ASPxComboBox>
            <dx:ASPxButton runat="server" ID="btnView" Text="View" OnClick="btnView_Click" Theme="Moderno"></dx:ASPxButton>
            <dx:ASPxMemo runat="server" ID="txtOwnerData" Width="500px" Height="400px" Theme="Moderno"></dx:ASPxMemo>
        </div>
    </form>
</body>
</html>
