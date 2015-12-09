<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoadFileFromSharepoint.aspx.vb" Inherits="IntranetPortal.LoadFileFromSharepoint" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:FileUpload runat="server" ID="fileUpload" />       
        <asp:Button runat="server" ID="btnUpload" OnClick="btnUpload_Click" Text="Upload" />
        <asp:Button runat="server" ID="btnShare" OnClick="btnShare_Click" Text="Share" />
        <asp:TextBox runat="server" ID="txtFileName" ></asp:TextBox>
        <asp:Button runat="server" ID="Button1" OnClick="Button1_Click" Text="Preview" />
    </div>
    </form>
</body>
</html>
