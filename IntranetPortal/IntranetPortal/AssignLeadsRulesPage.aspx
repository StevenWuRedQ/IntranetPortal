<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AssignLeadsRulesPage.aspx.vb" Inherits="IntranetPortal.AssignLeadsRulesPage" %>

<%@ Register Src="~/UserControl/AssignRulesControl.ascx" TagPrefix="uc1" TagName="AssignRulesControl" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:AssignRulesControl runat="server" ID="AssignRulesControl" />
    </div>
    </form>
</body>
</html>
