<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShareLeads.aspx.vb" Inherits="IntranetPortal.ShareLeads" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:HiddenField runat="server" ID="hfbble" />
            <dx:ASPxListBox runat="server" ID="lbEmployees" Width="100%" Height="240px"></dx:ASPxListBox>
            <br />
            <dx:ASPxComboBox runat="server" Width="100%" ID="cbEmps"></dx:ASPxComboBox>
            <dx:ASPxButton runat="server" Text="Add" ID="btnAddEmp"></dx:ASPxButton>
            <dx:ASPxButton runat="server" Text="Remove" ID="btnRemoveEmp"></dx:ASPxButton>
        </div>
    </form>
</body>
</html>
