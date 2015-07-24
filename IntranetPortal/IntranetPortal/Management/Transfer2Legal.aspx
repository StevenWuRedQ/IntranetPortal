<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Transfer2Legal.aspx.vb" Inherits="IntranetPortal.Transfer2Legal" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        BBLE json List: 
        <asp:TextBox ID="BBLELists" runat="server"></asp:TextBox>
        <br />
        <asp:Button ID="TransfterButon" runat="server" Text="Transfter" OnClick="TransfterButon_Click"/>
        <br />  
        <asp:Label ID="TransfterStauts" runat="server" Text="Label"></asp:Label>
    </div>
    </form>
</body>
</html>
