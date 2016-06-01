<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Portal.aspx.vb" Inherits="IntranetPortal.Portal" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" ng-app="PortalApp">
<head runat="server">
    <title>Portal</title>
    <script src="/bower_components/requirejs/require.js" ></script>
    <script src="require.conf.js"></script>
    <script>
        //need change by path like /Potal.aspx/Require
        requirejs(["js/app"], function () {

        });
    </script>
</head>
<body >
    <uc1:AuditLogs runat="server" ID="AuditLogs" />
    <%-- do not use form test ran code in back --%>
    <%--<form id="form1" runat="server">
    <div>
    
    </div>
    </form>--%>
    <script>
       
    </script>
</body>
</html>
