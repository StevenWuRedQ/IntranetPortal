<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsNotify.aspx.vb" Inherits="IntranetPortal.ComplaintsNotify" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Button ID="SendEmailBtn" runat="server" Text="Send Email" OnClick="SendEmailBtn_Click"/>  Stuats:<asp:Label ID="SendStatus" runat="server" Text=""></asp:Label>
        <br />
       
        Json data: 
        <br />
        <textarea runat="server" id="JsonOwnedProperties"></textarea>
        
    </div>
    </form>
</body>
</html>
