<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="/css/font-awesome.css" type="text/css" rel="stylesheet" />
    <script src="/scripts/jquery.collapse.js"></script>
    <script src="/scripts/jquery.collapse_storage.js"></script>
    <script src="/scripts/jquery.collapse_cookie_storage.js"></script>
    <link rel="stylesheet" href="css/normalize.min.css" />
    <link rel="stylesheet" href="/scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.css" />
    <link rel="stylesheet" href="css/main.css" />
    <script src="/scripts/js/vendor/modernizr-2.6.2-respond-1.1.0.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        Dear {{$UserName}},
        <br />
        <br />
        The urgent task (<b>{{$Action}}</b>) of <b>{{$Address}}</b> is now due. Please complete this as soon as possible. Below is the task description.
        <br />
        <br />
        <table>
            <tr>
                <td style="width: 150px">From:
                </td>
                <td><b>{{$CreateBy}}</b>
                </td>
            </tr>
            <tr>
                <td style="vertical-align:top">Task Description:
                </td>
                <td><b>{{$Description}}</b>
                </td>
            </tr>
            <tr>
                <td>Date Created:
                </td>
                <td><b>{{$DateCreated}}</b>
                </td>
            </tr>
        </table>
        <br />
        To view this lead, click <a href="{{$ApprovalLink}}">Here</a>. 	
        <br /><br />
        Regards,<br />
        My Ideal Property PORTAL team.
        <br />
        <small>This is an automatic email. Please do not reply.</small>

        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="/Scripts/js/vendor/jquery-1.11.0.min.js"><\/script>')</script>
        <script src="/Scripts/js/jquery.easing.1.3.js"></script>
        <script src="/Scripts/js/jquery.debouncedresize.js"></script>
        <script src="/Scripts/js/jquery.throttledresize.js"></script>
        <script src="/Scripts/js/jquery.mousewheel.js"></script>
        <script src="/Scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.min.js"></script>
        <script src="/Scripts/js/main.js"></script>
    </form>
</body>
</html>
