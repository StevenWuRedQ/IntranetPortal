<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EmailSummary.aspx.vb" Inherits="IntranetPortal.EmailSummary" %>

<%@ Register Src="~/EmailTemplate/TaskSummary.ascx" TagPrefix="uc1" TagName="TaskSummary" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <uc1:TaskSummary runat="server" id="TaskSummary" />
    </form>
</body>
</html>
