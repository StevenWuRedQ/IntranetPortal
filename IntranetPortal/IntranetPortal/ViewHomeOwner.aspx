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
            <dx:ASPxButton runat="server" ID="btnLoadOwnerInfo" Text="Get Owner Info" OnClick="btnLoadOwnerInfo_Click" Theme="Moderno"></dx:ASPxButton>
            <dx:ASPxLabel ID="lbArgumentSend" runat="server" Text="Send For"></dx:ASPxLabel>
             <dx:ASPxTextBox runat="server" ID="txtBBLEs" Theme="Moderno"></dx:ASPxTextBox>BBLE's Split with , Only can be ran on local.
            <dx:ASPxTextBox runat="server" ID="ASPxTextBox1" Theme="Moderno"></dx:ASPxTextBox>
            <dx:ASPxButton runat="server" ID="btLoadAll" Text="Load All BBLEs home owner" OnClick="btLoadAll_Click" Theme="Moderno"></dx:ASPxButton>
            <dx:ASPxLabel ID="LoadStatus" runat="server" Text=" Status"></dx:ASPxLabel>
            <dx:ASPxMemo runat="server" ID="txtOwnerData" Width="500px" Height="400px" Theme="Moderno"></dx:ASPxMemo>
        </div>
    </form>
</body>
</html>
