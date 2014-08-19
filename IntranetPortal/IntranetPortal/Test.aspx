<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="/styles/stevencss.css" rel='stylesheet' type='text/css' />
    <link href="/css/font-awesome.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scripts/jquery.collapse.js"></script>
    <script src="/scripts/jquery.collapse_storage.js"></script>
    <script src="/scripts/jquery.collapse_cookie_storage.js"></script>
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
