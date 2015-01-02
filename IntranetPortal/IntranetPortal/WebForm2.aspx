<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm2.aspx.vb" Inherits="IntranetPortal.WebForm2"  %>

<%@ Register Src="~/UserControl/DoorKnockMap.ascx" TagPrefix="uc1" TagName="DoorKnockMap" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="/css/stevencss.css?v=1.0" rel='stylesheet' type='text/css' />
    <style>
    html, body, #form1, #map_canvas
    {
        font-family: Tahoma;
        margin: 0;
        padding: 0;
        height: 100%;
    }

</style>
</head>
<body>
    <form id="form1" runat="server" style="height:100%;margin:0;padding:0;">   
        <uc1:DoorKnockMap runat="server" id="DoorKnockMap" />   
    </form>
</body>
</html>
