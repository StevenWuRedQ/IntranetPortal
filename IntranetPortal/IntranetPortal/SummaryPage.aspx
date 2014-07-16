<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SummaryPage.aspx.vb" Inherits="IntranetPortal.SummaryPage" %>

<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:UserSummary runat="server" id="UserSummary" />
    </div>
    </form>
</body>
</html>
