<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewLeadsInfo.aspx.vb" Inherits="IntranetPortal.ViewLeadsInfo" %>

<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Leads Info</title>    
    <base target="_self" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="height:800px">
       <uc1:LeadsInfo runat="server" ID="LeadsInfo" />    
            </div>
    </form>
</body>
</html>
