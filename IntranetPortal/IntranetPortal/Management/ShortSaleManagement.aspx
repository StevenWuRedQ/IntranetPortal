<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleManagement.aspx.vb" Inherits="IntranetPortal.ShortSaleManagement1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3>Enable Title</h3>
        BBLEs: <asp:TextBox runat="server" ID="txtBBLEs"></asp:TextBox>
        Title Users:
        <asp:DropDownList runat="server" ID="ddlTitleUsers"></asp:DropDownList>        
        <asp:Button runat="server" ID="btnEnableTitle" Text="Enable Title" />
        <asp:Label runat="server" ID="lblMsg" ></asp:Label>
    </div>
    </form>
</body>
</html>
