﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
 <%--       <uc1:DocumentsUI runat="server" id="DocumentsUI" />--%>
        <uc1:NavMenu runat="server" ID="NavMenu" />
    </div>
    </form>
</body>
</html>
